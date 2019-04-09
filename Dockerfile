FROM microsoft/vsts-agent:ubuntu-16.04

ENV AZ_VERSION 2.0.59-1~xenial

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/azure-cli.list \
  && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list \
  && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
       apt-transport-https \
       azure-cli=$AZ_VERSION \
       powershell \
       unzip \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

# Install Java OpenJDKs
RUN apt-add-repository -y ppa:openjdk-r/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/* \
  && update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
ENV JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Install .NET Core SDK and initialize package cache
RUN rm -rf /var/lib/apt/lists/* \
 && apt-get update \
 && curl https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    dotnet-sdk-2.2 \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/* \
 && dotnet help
ENV dotnet=/usr/bin/dotnet

# Install AzCopy (depends on .NET Core)
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod/ xenial main" | tee /etc/apt/sources.list.d/azure.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends azcopy \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/*
 