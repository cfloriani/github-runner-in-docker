#!/bin/bash

[[ ! -d ~/.aws ]] && mkdir ~/.aws
echo "[default]"$'\n'"region = $AWS_REGION" >> ~/.aws/config
echo "[default]"$'\n'"aws_access_key_id = $AWS_ACCESS_KEY"$'\n'"aws_secret_access_key = $AWS_SECRET_ACCESS" >> ~/.aws/credentials

[[ ! -d $GITHUB_RUNNER_WORKDIR ]] && mkdir $GITHUB_RUNNER_WORKDIR
/runner/config.sh --url $GITHUB_REPO_URL --token $GITHUB_RUNNER_TOKEN --work $GITHUB_RUNNER_WORKDIR --labels $GITHUB_LABELS --name $GITHUB_RUNNER_NAME --replace
/runner/run.sh
