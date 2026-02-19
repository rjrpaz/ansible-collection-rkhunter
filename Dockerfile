# Ansible Development Container
FROM ubuntu:24.04

# Install system dependencies (without ansible packages to avoid conflicts)
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update \
    && apt-get -y install \
    python3-pip \
    python3-venv \
    sshpass \
    git \
    && DEBIAN_FRONTEND=noninteractive apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment and install ansible tools
RUN python3 -m venv /opt/ansible-venv \
    && /opt/ansible-venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/ansible-venv/bin/pip install --no-cache-dir \
    ansible-core \
    ansible-lint \
    molecule \
    molecule-plugins[docker]

# Add virtual environment to PATH
ENV PATH="/opt/ansible-venv/bin:$PATH"

# Copy configuration files
COPY ansible.cfg /workdir/ansible.cfg
COPY .ansible-lint /workdir/.ansible-lint

# Set working directory
WORKDIR /workdir

# Default command
CMD ["ansible", "--version"]