FROM ghcr.io/runatlantis/atlantis:latest

ARG terragrunt_version=v0.36.6
ARG terragrunt_atlantis_config_version=1.14.2

# Terragrunt related configuration
COPY config/repos.yaml /usr/local/etc/repos.yaml

# Install Terragrunt
RUN curl -L -s --output /usr/local/bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${terragrunt_version}/terragrunt_linux_amd64" \
    && chmod +x /usr/local/bin/terragrunt \
    && curl -L -s --output /tmp/terragrunt-atlantis-config.tar.gz "https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${terragrunt_atlantis_config_version}/terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64.tar.gz" \
    && cd /tmp \
    && tar xzf terragrunt-atlantis-config.tar.gz \
    && mv terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64/terragrunt-atlantis-config_${terragrunt_atlantis_config_version}_linux_amd64 /usr/local/bin/terragrunt-atlantis-config \
    && rm -r terragrunt-atlantis-config* \
    && chmod +x /usr/local/bin/terragrunt-atlantis-config \
    && cd -

# Install awscli & jq, useful for Terraform external datasource
RUN apk add --no-cache \
        python3 \
        py3-pip \
        jq \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir awscli \
    && rm -rf /var/cache/apk/*

LABEL io.gruntwork.terragrunt/version="${terragrunt_version}"
LABEL io.transcend.terragrunt_atlantis_config/version="v${terragrunt_atlantis_config_version}"
