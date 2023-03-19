#!/bin/bash

ROLE_ARN=$1

if [[ "${ROLE_ARN}x" == "x" ]]; then
    echo "Error, Please execute with role arn."
    exit 1
fi

CRED="$(aws sts assume-role --role-arn $1 --role-session-name facam-handson --output text | grep CREDENTIALS)"

access_key="$(echo $CRED | awk '{print $2}')"
secret_access="$(echo $CRED | awk '{print $4}')"
session_token="$(echo $CRED | awk '{print $5}')"


echo "export AWS_ACCESS_KEY_ID=$access_key"
echo "export AWS_SECRET_ACCESS_KEY=$secret_access"
echo "export AWS_SESSION_TOKEN=$session_token"

