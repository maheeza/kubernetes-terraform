#!/bin/bash
# This script takes two variables
# sh docker_run 'document-service' 'qa'
# 1. Micro Service name
# 2. Environment eg: qa,mo,prod
# read env values 

echo repoName# $repoName
echo environment# $environment
whoami
if [ "$repoName" == "default" ] || [ "$environment" == "default" ]; then
	echo "Repository Name or Environment value is not valid."
    exit 1
fi
echo "Downloading certificates"
#The below are to be created for CDE
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/certificates/$environment-oracletruststore.jks /microservices
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/certificates/$environment-oraclekeystore.jks /microservices

aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/certificates/$environment-keystore.jks /microservices
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/certificates/$environment-truststore.jks /microservices

if [ "$repoName" == "integration-service" ] ; then
	echo "Downloading External Client Access Certificates"
	mkdir -p /microservices/src/main/resources/certs
	aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/external-certificates/adp-keystore.jks /microservices/
  aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/external-certificates/fiserv-keystore.jks /microservices/
    
fi

echo "Downloading property file"
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/"$repoName"/application.properties /microservices/


echo "Adding the properties from secrement manager"
echo "" >> /microservices/application.properties

	echo "Appending from secretsmanager for Service $repoName to env: $environment"
	#if [ "$repoName" == "app-auth-service" ] ; then
	echo "" >> /microservices/application.properties
	aws secretsmanager get-secret-value --region "us-east-1" --secret-id cyc-$environment-cde-$repoName --query SecretString --output text | jq -r 'to_entries | map("\(.key)=\(.value)") | .[]' >> /microservices/application.properties
	echo "-----------------------------------------------------------------------"


#Copying the JWT Filter Library
echo "Downloading JWT Filter Lib property file for appending"
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/jwt-filter-lib/application.properties /microservices/jwt-filter-lib.properties

echo "Appending the JWT Filter Lib"
echo "" >> /microservices/application.properties
cat /microservices/jwt-filter-lib.properties >> /microservices/application.properties

echo "Downloading JWT Filter Lib public key"

aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/jwt-filter-lib/publicKey_jwt.der /microservices/

echo "Downloading JWT Filter Lib privatekey"
aws s3 cp s3://cyc-build-repository/cde/"${environment}"/microservices/jwt-filter-lib/privateKey_jwt.der /microservices/

echo "Reading configuration values from AWS Secret Manager"
secrets_json=$(aws secretsmanager get-secret-value --region "us-east-1" --secret-id cyc-"${environment}"-cde-"${repoName}" | jq --raw-output .SecretString)

debug_enabled=$(jq -r '.["debug.enabled"]' <<< "$secrets_json")
echo "Debug enabled = $debug_enabled"

if [ "$debug_enabled" == true ] ; then
  echo "------- application.properties and secrets DEBUG INFORMATION -------"
  echo "*** Secret Manager content ***"
  echo "$secrets_json"

  echo "*** application.properties content ***"
  cat /microservices/application.properties
fi

echo "------------------------------------------------------------------------"
echo "Prining the AWS CLI Version"
aws --version

if [ "$environment" == "prod" ] || [ "$environment" == "prd" ] ; then
    sed -i "s/My Application/cyc-${environment}-cmp-${repoName}/g" /newrelic-java-7.5.0/newrelic/newrelic.yml
    sleep 5
    java -javaagent:/newrelic-java-7.5.0/newrelic/newrelic.jar -Dnewrelic.environment=${environment} -jar /microservices/microservice-exec.jar --spring.config.location=/microservices/application.properties
else
	  java -jar /microservices/microservice-exec.jar --spring.config.location=/microservices/application.properties
fi