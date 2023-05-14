#!/bin/bash

rg=appservices-TApD
name=provider-tools-appservice-TApD
acr=ptacrtapd.azurecr.io

az webapp config set \
--resource-group $rg \
--name $name \
--linux-fx-version "DOCKER|$acr/sample/hello-world:2"