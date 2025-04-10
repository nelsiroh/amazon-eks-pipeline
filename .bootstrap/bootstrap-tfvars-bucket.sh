#!/bin/bash
# This script creates a secure S3 bucket for tfvars files
# Usage: ./bootstrap-tfvars-bucket.sh --profile {aws-profile} --region {aws-region}

# Defaults
AWS_PROFILE="default"
AWS_REGION="us-east-2"

# Parse CLI args
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile) AWS_PROFILE="$2"; shift ;;
        --region) AWS_REGION="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Prompt for S3 bucket name
read -p "Enter the name of the S3 bucket to store tfvars (e.g., example-tfvars-bucket): " BUCKET_NAME
if [[ -z "$BUCKET_NAME" ]]; then
    echo "❌ Error: Bucket name cannot be empty."
    exit 1
fi

# Derive KMS alias from bucket name
BASENAME="${BUCKET_NAME%-tfvars*}"
KMS_ALIAS="alias/${BASENAME}-tfvars-key"

echo "🚀 Bootstrapping S3 bucket: s3://$BUCKET_NAME in region: $AWS_REGION"

# Create KMS CMK if it doesn't exist
if ! aws kms describe-key --key-id "$KMS_ALIAS" --region "$AWS_REGION" --profile "$AWS_PROFILE" 2>/dev/null; then
  echo "🔐 Creating KMS key with alias $KMS_ALIAS"
  KMS_KEY_ID=$(aws kms create-key \
    --description "KMS key for encrypting tfvars bucket" \
    --key-usage ENCRYPT_DECRYPT \
    --customer-master-key-spec SYMMETRIC_DEFAULT \
    --query KeyMetadata.Arn --output text \
    --region "$AWS_REGION" --profile "$AWS_PROFILE")

  aws kms create-alias \
    --alias-name "$KMS_ALIAS" \
    --target-key-id "$KMS_KEY_ID" \
    --region "$AWS_REGION" --profile "$AWS_PROFILE"
else
  echo "🔐 KMS alias already exists: $KMS_ALIAS"
  KMS_KEY_ID=$(aws kms describe-key --key-id "$KMS_ALIAS" \
    --region "$AWS_REGION" --profile "$AWS_PROFILE" \
    --query "KeyMetadata.Arn" --output text)
fi

# Create the S3 bucket if it doesn't exist
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" 2>/dev/null; then
  echo "📦 Creating bucket: $BUCKET_NAME"
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --profile "$AWS_PROFILE"
  else
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION" \
      --profile "$AWS_PROFILE"
  fi
else
  echo "✅ Bucket already exists: $BUCKET_NAME"
fi

# Enable versioning
echo "🗃️  Enabling versioning"
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled \
  --region "$AWS_REGION" --profile "$AWS_PROFILE"

# Enable KMS encryption
echo "🔐 Enabling KMS encryption"
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "'"$KMS_KEY_ID"'"
      }
    }]
  }' \
  --region "$AWS_REGION" --profile "$AWS_PROFILE"

# Block all public access
echo "🚫 Blocking public access"
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }' \
  --region "$AWS_REGION" --profile "$AWS_PROFILE"

echo "✅ tfvars bucket setup complete: s3://$BUCKET_NAME"
