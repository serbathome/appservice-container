#!/bin/bash

rg=appservices-XXKY
name=provider-tools-appservice-XXKY

az webapp config appsettings list \
--resource-group $rg \
--name $name \
> appsettings.prev.json

az webapp config appsettings set \
--resource-group $rg \
--name $name \
--settings "@appsettings.json"