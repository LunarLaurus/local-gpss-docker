FROM debian:bookworm-slim

# Hard-coded release URL for latest linux64.zip
ENV APP_DIR=/app
ENV DATA_DIR=/app/data
ENV GPSS_HOST=0.0.0.0
ENV GPSS_PORT=13579
ENV RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl unzip ca-certificates libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Create directories
WORKDIR ${APP_DIR}
RUN mkdir -p ${DATA_DIR}

# Download and extract the local-gpss binary
RUN curl -fsSL "${RELEASE_URL}" -o /tmp/local-gpss.zip \
    && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
    && mv /tmp/local-gpss-extract/linux64/local-gpss ./local-gpss \
    && chmod +x ./local-gpss \
    && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract

# Persistent volume only for data
VOLUME ["${DATA_DIR}"]

EXPOSE ${GPSS_PORT}

# Start the server
CMD ["./local-gpss", "--urls=http://0.0.0.0:13579/", "--data-dir=/app/data"]
