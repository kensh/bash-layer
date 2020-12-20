
export ACCOUNT_ID=$(aws sts get-caller-identity | jq --raw-output .Account)
export REGION=$(aws configure get region)
export FUNCTION_NAME=bash-runtime-with-layer
export LAYER_NAME=bootstrap
export ZIP_FILES=./layers/boot/bootstrap

zip -j ${LAYER_NAME}.zip ${ZIP_FILES}

export BOOT_VERSION=$(aws lambda publish-layer-version --layer-name ${LAYER_NAME} --zip-file fileb://${LAYER_NAME}.zip | jq --raw-output .Version) 

aws lambda update-function-configuration --function-name ${FUNCTION_NAME}  \
--layers arn:aws:lambda:${REGION}:${ACCOUNT_ID}:layer:${LAYER_NAME}:${BOOT_VERSION}