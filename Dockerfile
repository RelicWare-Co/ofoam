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

# Add OpenFOAM environment setup to .bashrc
RUN echo ". /opt/openfoam11/etc/bashrc" >> /root/.bashrc
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y screen
# Set bash as the default shell and source .bashrc on container start
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-l"]



