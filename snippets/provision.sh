#!/bin/bash

set -e

REGION="eu-west-2"
TF_STATE_BUCKET="snippets-tf-state"

setup_tf_s3_state_store() {
    echo -n "Checking if S3 Terraform Bucket exists: "
    set +e
    aws s3 ls s3://${TF_STATE_BUCKET} > /dev/null 2>&1
    out=$?
    set -e
    if [[ $out -eq 0 ]];
    then
        echo "OK"
        return
    fi

    echo "No"
    echo "Creating Terraform state bucket at s3://${TF_STATE_BUCKET} (region ${REGION})"
    # The following environment variables are defined in config.sh
    aws s3 mb s3://${TF_STATE_BUCKET} --region ${REGION}

    echo "Configuring Terraform to use an encrypted remote S3 bucket for state storage"
    # store TF state in S3
    terraform remote config \
        -backend=s3 \
        -backend-config="bucket=${TF_STATE_BUCKET}" \
        -backend-config="key=snippets-${REGION}/terraform.tfstate" \
        -backend-config="encrypt=1" \
        -backend-config="region=${REGION}"

    echo "Encryption for TF state:"
    aws s3api head-object --bucket=$TF_STATE_BUCKET --key="snippets-${REGION}/terraform.tfstate" | jq -r .ServerSideEncryption
}

setup_tf_s3_state_store

PLAN=$(mktemp)
terraform plan --out $PLAN

# if terraform plan fails, the next command won't run due to
# set -e at the top of the script.
read -p "Proceed?"
terraform apply $PLAN
rm $PLAN
