

1. Set your keys in your cli
export PING_IDENTITY_DEVOPS_USER="<your_email>"
export PING_IDENTITY_DEVOPS_KEY="<your_key>"

2. Run Docker Image Passing your License Obtain from Ping

docker run -d --name pingfederate \
  -p 9999:9999 \
  --volume /Users/bilalmahmood/Desktop/Projects/hybrid-identity-bridge/modules/pingfederate-app/pingfederate.lic:/opt/in/instance/server/default/conf/pingfederate.lic \
  --detach \
  -e PING_IDENTITY_ACCEPT_EULA=YES \
  -e PING_IDENTITY_DEVOPS_USER=$PING_IDENTITY_DEVOPS_USER \
  -e PING_IDENTITY_DEVOPS_KEY=$PING_IDENTITY_DEVOPS_KEY \
  pingidentity/pingfederate:latest


3. Check you can view and login to the console
Log into https://localhost:9999/pingfederate/app  (Admin / 2FederateM0re). 


