
export ACCOUNT_ID=$(aws sts get-caller-identity | jq --raw-output .Account)
export REGION=$(aws configure get region)
export FUNCTION_NAME=bash-runtime-with-layer
export LAYER_NAME=layer2
export PUSHD=layers/layer2
export ZIP_FILES=./bin/script1.sh
export BASE_DIR=${PWD}
export LAYER0=arn:aws:lambda:ap-northeast-1:${ACCOUNT_ID}:layer:bootstrap:2
export LAYER1=arn:aws:lambda:ap-northeast-1:${ACCOUNT_ID}:layer:layer1:7

pushd ${PUSHD}
zip ${BASE_DIR}/${LAYER_NAME}.zip ${ZIP_FILES}
popd

export BOOT_VERSION=$(aws lambda publish-layer-version --layer-name ${LAYER_NAME} --zip-file fileb://${LAYER_NAME}.zip | jq --raw-output .Version) 

aws lambda update-function-configuration --function-name ${FUNCTION_NAME}  \
--layers \
"${LAYER0}" \
"${LAYER1}" \
"arn:aws:lambda:${REGION}:${ACCOUNT_ID}:layer:${LAYER_NAME}:${BOOT_VERSION}" 


aws lambda update-function-code \
--function-name ${FUNCTION_NAME} \
--zip-file fileb://function.zip