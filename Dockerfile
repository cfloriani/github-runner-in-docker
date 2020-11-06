FROM ubuntu:latest

RUN groupadd -r runner && useradd -r -g runner runner
WORKDIR /runner
RUN mkdir /home/runner && chown runner:runner /home/runner

ARG GITHUB_REPO_URL
ARG GITHUB_RUNNER_NAME
ARG GITHUB_RUNNER_TOKEN
ARG GITHUB_RUNNER_WORKDIR
ARG GITHUB_ORG_RUNNER
ARG GITHUB_LABELS
ARG AWS_SECRET_ACCESS
ARG AWS_ACCESS_KEY
ARG AWS_REGION

ENV DEBIAN_FRONTEND=noninteractive
ENV GITHUB_REPO_URL $GITHUB_REPO_URL
ENV GITHUB_RUNNER_NAME $GITHUB_RUNNER_NAME
ENV GITHUB_RUNNER_TOKEN $GITHUB_RUNNER_TOKEN
ENV GITHUB_RUNNER_WORKDIR $GITHUB_RUNNER_WORKDIR
ENV GITHUB_ORG_RUNNER $GITHUB_ORG_RUNNER
ENV GITHUB_LABELS $GITHUB_LABELS
ENV AWS_SECRET_ACCESS $AWS_SECRET_ACCESS
ENV AWS_ACCESS_KEY $AWS_ACCESS_KEY
ENV AWS_REGION $AWS_REGION

# install dependencies
RUN apt-get update && apt-get install -y \
        tzdata \
        curl \
        wget \
        gnupg2 \
        gnupg-agent \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        jq \
        unzip \
        git \
        python3 \
        python3-pip

# install terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip && \
        unzip terraform_0.13.3_linux_amd64.zip && \
        mv terraform /usr/bin && \
        rm terraform_0.13.3_linux_amd64.zip

# Install and config AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        ./aws/install && \
        rm awscliv2.zip && rm -rf aws && \
        mkdir /home/runner/.aws && echo "[default]"$'\n'"region = $AWS_REGION" > /home/runner/.aws/config && \
        echo "[default]"$'\n'"aws_access_key_id = $AWS_ACCESS_KEY"$'\n'"aws_secret_access_key = $AWS_SECRET_ACCESS" > /home/runner/.aws/credentials

# Install and config Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
        apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && \
        usermod -aG docker $(whoami)

# Install and config Docker-Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
        chmod +x /usr/local/bin/docker-compose

# Install and config Github Runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.273.6/actions-runner-linux-x64-2.273.6.tar.gz && \
        tar xzf ./actions-runner-linux-x64-2.273.6.tar.gz -C /runner && \
        rm actions-runner-linux-x64-2.273.6.tar.gz

# Exec runner
RUN chown runner:runner * /runner
USER runner