
Sample deployment to try docker images in azure appservice.

Demo plan:

Deploy infrastructure, build custom nginx image and deploy to appservice

1. terraform init
2. terraform apply -auto-approve

-> Check that infrastructure is created and application is available
-> Mention output and update scripts with the variable names of acr, appservice rg and appservice name (last 4 symbols)

Build new image and update release

3. update src/server.js, set the version to 2
4. ./scripts/build.sh
5. ./scripts/deploy_app.sh

-> Check application is updated

Deploy new settings and test rollback

6. ./scripts/deploy_settings.sh
7. ./scripts/rollback_settings.sh

-> Check that new appsettings get deployed and then rolled back