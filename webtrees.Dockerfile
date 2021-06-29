FROM alpine as downloader

# Download and unzip webtrees
RUN apk add --no-cache wget unzip
RUN wget https://github.com/magicsunday/webtrees-fan-chart/releases/download/2.2.0/webtrees-fan-chart.zip && \
    unzip webtrees-fan-chart.zip

FROM nathanvaughn/webtrees:2.0.16

# Install the webtrees plugin
COPY --from=downloader webtrees-fan-chart modules_v4/
