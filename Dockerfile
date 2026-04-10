FROM node:lts-slim

ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=user

# Install system deps and global tools as root
RUN apt-get update && apt-get install -y --no-install-recommends curl make python3 python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g markdownlint-cli

# Create a non-root user matching the host UID/GID/name so that:
#   1. --dangerously-skip-permissions works (requires non-root)
#   2. --userns=keep-id maps the host user to this user seamlessly
#
# If the base image already has a user/group with the same UID/GID (e.g. the
# 'node' user in node:lts-slim), rename it instead of silently skipping creation
# (which would leave no account for the USER directive to resolve).
RUN groupadd --gid ${USER_GID} ${USER_NAME} 2>/dev/null || \
        groupmod -n ${USER_NAME} "$(getent group ${USER_GID} | cut -d: -f1)" && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USER_NAME} 2>/dev/null || \
    usermod -l ${USER_NAME} -m -d /home/${USER_NAME} "$(getent passwd ${USER_UID} | cut -d: -f1)"

USER ${USER_NAME}

ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"

# Install claude code as the non-root user so it lands in ~/.local/bin
RUN curl -fsSL https://claude.ai/install.sh | bash

WORKDIR /workspace

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
