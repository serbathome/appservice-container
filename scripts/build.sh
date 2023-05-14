#!/bin/bash

acr=ptacrxxky.azurecr.io

az acr build \
--registry $acr \
--image sample/hello-world:2 \
--file ./Dockerfile \
.
