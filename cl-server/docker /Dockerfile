FROM ortussolutions/commandbox:latest
WORKDIR /app
COPY . /app
RUN box install
CMD ["box", "server", "start"]
