FROM ortussolutions/commandbox:lucee5

# CommandBox's entrypoint writes under /usr/local/lib/CommandBox, so this
# image stays on the base-image user. Do not add a non-root USER here.

WORKDIR /app

ENV PORT=8500 \
    BOX_SERVER_APP_CFENGINE=lucee@5.4.6+9

COPY box.json server.json .cfconfig.json ./
RUN box install

ADD https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.4/postgresql-42.7.4.jar /app/lib/postgresql-42.7.4.jar

COPY . /app

RUN mkdir -p /app/logs

EXPOSE 8500

HEALTHCHECK --interval=15s --timeout=5s --start-period=90s --retries=10 \
    CMD sh -c 'curl -fsS "http://127.0.0.1:${PORT:-8500}/api/health" || wget -q -O- "http://127.0.0.1:${PORT:-8500}/api/health"'
