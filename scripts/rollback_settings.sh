#!/bin/bash

rg=appservices-TApD
name=provider-tools-appservice-TApD

az webapp config appsettings list \
--name $name \
--resource-group $rg \
--query "[].name" -o tsv | \
xargs az webapp config appsettings delete \
--name $name \
--resource-group $rg \
--setting-names {}

az webapp config appsettings set \
--resource-group $rg \
--name $name \
--settings "@appsettings.prev.json"