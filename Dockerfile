FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    sudo git curl wget python3 python3-pip cmake ninja-build \
    python3-venv python3-serial libffi-dev libssl-dev \
    libusb-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Task binary
RUN curl -sL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin

# Set workspace
WORKDIR /workspace

# Copy your Taskfile and required scripts
COPY . .

# Pre-pull ESP-IDF so we avoid repeating this
RUN task buildFirmware || true

CMD ["cp", "-r", "/workspace/esp-idf/examples/openthread/ot_rcp/build", "/out"]

