FROM ubuntu:latest

# Install basic dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    lsb-release \
    gnupg \
    software-properties-common && \
    curl -fsSL https://tailscale.com/install.sh | sh

# Add OpenFOAM repository
RUN sh -c "wget -O - https://dl.openfoam.org/gpg.key > /etc/apt/trusted.gpg.d/openfoam.asc"
RUN sh -c 'echo "deb http://dl.openfoam.org/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/openfoam.list'

# Install OpenFOAM
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openfoam11

# Add OpenFOAM environment setup to root and user .bashrc
RUN echo ". /opt/openfoam11/etc/bashrc" >> /root/.bashrc

# Create non-root user with home directory
RUN useradd -m -s /bin/bash user && \
    echo ". /opt/openfoam11/etc/bashrc" >> /home/user/.bashrc

# Install screen
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y screen htop nano
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set default user and working directory
USER user
WORKDIR /home/user

# Set bash as default shell with login environment
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-l"]