#!/bin/bash
    echo -e "\nWelcome to the AWS Terraform Deployment Script!\n"
    echo "Before proceeding, be aware that this script will overwrite your existing AWS credentials, and remove terraform state files."
    echo -e "If you have any concerns, please review the script before proceeding.\n"


# Function to update AWS credentials
update_aws_credentials() {
    
    read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
    read -sp "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
    echo ""

    AWS_CREDENTIALS_FILE=~/.aws/credentials

    echo "Updating AWS credentials..."
    mkdir -p ~/.aws
    rm -rf .terraform*
    rm -rf terra*
    cat > $AWS_CREDENTIALS_FILE <<EOL
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOL
    #$?: This variable holds the exit status of the last executed command.
    #If the previous command was successful, $? will be 0.
    #If the previous command encountered an error, $? will be a non-zero value.
    if [ $? -eq 0 ]; then
        echo "AWS credentials updated successfully."
    else
        echo "Failed to update AWS credentials. Exiting..."
        exit 1
    fi
}

# Step 1: Check if AWS credentials need to be updated
read -p "Do you want to update your AWS credentials? (yes/no): " UPDATE_CREDENTIALS

if [[ "$UPDATE_CREDENTIALS" == "yes" ]]; then
    update_aws_credentials
else
    echo "Skipping AWS credentials update."
fi

# Step 2: Run Terraform Init
echo "Initializing Terraform..."
terraform init

# Check if terraform init was successful
if [ $? -eq 0 ]; then
    echo "Terraform initialized successfully."
else
    echo "Terraform initialization failed. Exiting..."
    exit 1
fi

# Step 3: Run Terraform Apply
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Check if terraform apply was successful
if [ $? -eq 0 ]; then
    echo "Terraform applied successfully."
else
    echo "Terraform apply failed. Exiting..."
    exit 1
fi

