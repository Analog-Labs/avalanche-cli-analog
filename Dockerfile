# ============= Compilation Stage ================
FROM golang:1.21-bullseye AS builder

WORKDIR /build
# Copy and download avalanche dependencies using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download
# Copy the code into the container
COPY . .
# Build avalanchego
RUN ./scripts/build.sh

# ============= Cleanup Stage ================
FROM debian:11-slim
WORKDIR /

# Copy the executables into the container
COPY --from=builder /build/bin/avalanche .

# Copy genesis.json into the container
COPY genesis.json genesis.json

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "./avalanche" ]
