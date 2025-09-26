# Use .NET 9 runtime as base
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# Create app directory
WORKDIR /app

# Expose port
ENV GPSS_PORT=13579
EXPOSE ${GPSS_PORT}

# Install unzip & curl
RUN apt-get update && apt-get install -y unzip curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV GPSS_HOST=0.0.0.0
ENV RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"
ENV DATA_DIR=/app/data

# Create data dir for persistent storage
RUN mkdir -p ${DATA_DIR}

# Download and extract local-gpss
RUN curl -fsSL "${RELEASE_URL}" -o /tmp/local-gpss.zip \
    && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
    && mv /tmp/local-gpss-extract/linux64/local-gpss ./local-gpss \
    && chmod +x ./local-gpss \
    && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract

# Persistent volume for data
VOLUME ["${DATA_DIR}"]

# Start the server
ENTRYPOINT ["./local-gpss", "--urls=http://0.0.0.0:13579/", "--data-dir=/app/data"]
