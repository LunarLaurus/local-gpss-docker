FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip ca-certificates libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Environment variables
ENV GPSS_PORT=13579
ENV GPSS_HOST=0.0.0.0
ENV DATA_DIR=/app/data
ENV RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"

# Create persistent data directory
RUN mkdir -p ${DATA_DIR}

# Download and extract all files from linux64 folder
RUN curl -fsSL ${RELEASE_URL} -o /tmp/local-gpss.zip \
    && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
    && cp -r /tmp/local-gpss-extract/linux64/* ./ \
    && chmod +x ./local-gpss \
    && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract

# Make data directory a persistent volume
VOLUME ["${DATA_DIR}"]

# Expose the port
EXPOSE ${GPSS_PORT}

# Run the executable
ENTRYPOINT ["./local-gpss", "--urls=http://0.0.0.0:13579/", "--data-dir=/app/data"]
