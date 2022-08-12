# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN sed -i 's/archive\.ubuntu\.com/au.archive.ubuntu.com/g' /etc/apt/sources.list

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby CLI instead of the licensed Docker CLI
ARG USE_MOBY="true"
# [Option] Select CLI version
ARG CLI_VERSION="latest"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
    apt install software-properties-common -y --no-install-recommends && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update && \
    apt install -y --no-install-recommends python3.10 python3-pip gettext-base && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential mosquitto-clients mosquitto rtl-sdr && \
    localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Install k3d, k9s
RUN curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

RUN curl -Lo ./k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz && \
    mkdir k9s && tar xvzf k9s.tar.gz -C ./k9s && mv ./k9s/k9s /bin/k9s

# Install ROS2

RUN apt update && export DEBIAN_FRONTEND=noninteractive && apt install -y curl gnupg lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt update && \
    apt upgrade -y && \
    apt install -y ros-humble-desktop python3-colcon-common-extensions python3-rosdep iputils-ping flake8 && \
    rm -rf /var/lib/apt/lists/*

# keep command history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R vscode /commandhistory \
    && echo $SNIPPET >> "/home/vscode/.bashrc"

RUN groupadd rtlsdr && usermod -a -G dialout vscode && usermod -a -G rtlsdr vscode
