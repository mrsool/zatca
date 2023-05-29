# FROM ubuntu:22.04
# Need a Java version that's >= 11 and < 14 according to ZATCA
FROM openjdk:19-slim-buster

# Install dependencies
# install jq
RUN apt-get update && apt-get install -y jq

COPY . /zatca
WORKDIR /zatca

RUN touch ~/.bash_profile
RUN touch ~/.zshrc

# ZATCA Installation Instructions for Linux
RUN sh ./install.sh

RUN chmod +x ./Apps/fatoora

# Manually add Apps folder to PATH (adding to .bash_profile via install.sh doesn't work)
ENV FATOORA_HOME="/zatca/Apps"
ENV PATH="${FATOORA_HOME}:${PATH}"
ENV SDK_CONFIG="/zatca/config.json"


CMD ["./install.sh && ./bin/bash"]