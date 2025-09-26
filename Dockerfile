# Dockerfile — Local-GPSS (auto-download latest linux64.zip at build)
FROM debian:bookworm-slim

ARG RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"
ENV APP_DIR=/app
ENV GPSS_HOST=0.0.0.0
ENV GPSS_PORT=13579

# minimal tools for download & unzip
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_DIR}

# download & extract the release into /app and ensure executable
RUN curl -fsSL "${RELEASE_URL}" -o /tmp/local-gpss.zip \
  && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
  && mv /tmp/local-gpss-extract/* . \
  && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract \
  && if [ -f ./local-gpss ]; then chmod +x ./local-gpss; fi

# Persist the working directory (the app stores DB/config in cwd)
VOLUME ["/app"]

EXPOSE ${GPSS_PORT}

# Run binary binding to 0.0.0.0:13579
CMD ["sh", "-c", "if [ -f ./local-gpss ]; then ./local-gpss --urls=http://${GPSS_HOST}:${GPSS_PORT}/; else echo 'local-gpss binary not found'; sleep 86400; fi"]