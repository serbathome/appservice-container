#!/bin/bash

rg=appservices-TApD
name=provider-tools-appservice-TApD

az webapp config appsettings list \
--resource-group $rg \
--name $name \
> appsettings.prev.json

az webapp config appsettings set \
--resource-group $rg \
--name $name \
--settings "@appsettings.json"