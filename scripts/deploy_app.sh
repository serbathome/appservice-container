#!/bin/bash

rg=appservices-XXKY
name=provider-tools-appservice-XXKY
acr=ptacrxxky.azurecr.io

az webapp config set \
--resource-group $rg \
--name $name \
--linux-fx-version "DOCKER|$acr/sample/hello-world:2"