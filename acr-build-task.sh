#!/bin/sh

ACR_NAME=hmcts  # The name of your Azure container registry
PROJECT_NAME=vsts-agent
GIT_USER=hmcts  # Your GitHub user account name
GIT_PAT=

az acr task create \
    --registry $ACR_NAME \
    --name $PROJECT_NAME \
    --image hmcts/$PROJECT_NAME:{{.Run.ID}} \
    --context https://github.com/$GIT_USER/$PROJECT_NAME.git \
    --branch master \
    --file Dockerfile \
    --git-access-token $GIT_PAT