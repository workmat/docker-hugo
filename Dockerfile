FROM alpine:latest

# Build arguments to control versions
ARG HUGO_VERSION=0.147.1
ARG GO_VERSION=1.24.3

# Install dependencies
RUN apk add --no-cache curl gcc g++ musl-dev libc6-compat libstdc++

# Install Hugo
RUN curl -L -o /tmp/hugo.tar.gz "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" \
    && tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo \
    && rm /tmp/hugo.tar.gz

# Copy Go and Hugo from builder
#COPY --from=builder /usr/local/go /usr/local/go
#COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo

# Verify installations
RUN hugo version

# Set working directory
WORKDIR /src

# Expose Hugo's default development server port
EXPOSE 1313

# Default command
CMD ["hugo", "server", "--bind", "0.0.0.0", "--buildDrafts", "--buildFuture"]
