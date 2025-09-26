FROM mcr.microsoft.com/dotnet/aspnet:7.0

ENV APP_DIR=/app
ENV DATA_DIR=/app/data
ENV GPSS_HOST=0.0.0.0
ENV GPSS_PORT=13579
ENV RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"

WORKDIR ${APP_DIR}
RUN mkdir -p ${DATA_DIR}

# Install unzip for extracting zip
RUN apt-get update && apt-get install -y unzip curl && rm -rf /var/lib/apt/lists/*

# Download and extract binary
RUN curl -fsSL "${RELEASE_URL}" -o /tmp/local-gpss.zip \
    && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
    && mv /tmp/local-gpss-extract/linux64/local-gpss ./local-gpss \
    && chmod +x ./local-gpss \
    && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract

VOLUME ["${DATA_DIR}"]

EXPOSE ${GPSS_PORT}

CMD ["./local-gpss", "--urls=http://0.0.0.0:13579/", "--data-dir=/app/data"]
