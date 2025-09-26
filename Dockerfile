FROM debian:bookworm-slim

# Hard-coded release URL for latest linux64.zip
ENV APP_DIR=/app
ENV GPSS_HOST=0.0.0.0
ENV GPSS_PORT=13579
ENV RELEASE_URL="https://github.com/FlagBrew/local-gpss/releases/latest/download/linux64.zip"

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_DIR}

RUN curl -fsSL "${RELEASE_URL}" -o /tmp/local-gpss.zip \
  && unzip /tmp/local-gpss.zip -d /tmp/local-gpss-extract \
  && mv /tmp/local-gpss-extract/* . \
  && rm -rf /tmp/local-gpss.zip /tmp/local-gpss-extract \
  && if [ -f ./local-gpss ]; then chmod +x ./local-gpss; fi

VOLUME ["/app"]

EXPOSE ${GPSS_PORT}

CMD ["sh", "-c", "./local-gpss --urls=http://${GPSS_HOST}:${GPSS_PORT}/"]
