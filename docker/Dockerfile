FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Update repositories
RUN echo "Updating repositories..."
RUN apt-get update -y && apt-get upgrade -y

# Install certificates
RUN echo "Installing certificates..."
RUN apt-get install -y --no-install-recommends ca-certificates

# Install packages
RUN echo "Installing packages..."
RUN apt-get install -y --no-install-recommends \
    build-essential \
    clang-format \
    clang-tidy \
    cmake \
    doxygen \
    g++ \
    gcc \
    git \
    lcov \
    make
