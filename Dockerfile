FROM alpine:latest

# Build arguments to control versions
ARG HUGO_VERSION=0.147.1
ARG GO_VERSION=1.21.5

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    git \
    curl \
    wget \
    tar \
    bash

# Install Go
RUN wget -O go.tar.gz "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV GOBIN="${GOPATH}/bin"
ENV PATH="${GOBIN}:${PATH}"

# Create Go workspace
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin ${GOPATH}/pkg

# Install Hugo
RUN wget -O hugo.tar.gz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" && \
    tar -xzf hugo.tar.gz && \
    mv hugo /usr/local/bin/ && \
    rm hugo.tar.gz && \
    chmod +x /usr/local/bin/hugo

# Verify installations
RUN go version && hugo version

# Set working directory
WORKDIR /workspace

# Expose Hugo's default development server port
EXPOSE 1313

# Default command
CMD ["/bin/bash"]