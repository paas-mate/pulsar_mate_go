FROM ttbb/base:go AS build
COPY . /opt/compile
WORKDIR /opt/compile/pkg
RUN go build -o pulsar_mate .
WORKDIR /opt/compile/cmd/config
RUN go build -o config_gen .


FROM ttbb/pulsar:nake

COPY docker-build /opt/pulsar/mate

COPY --from=build /opt/compile/pkg/pulsar_mate /opt/pulsar/mate/pulsar_mate
COPY --from=build /opt/compile/cmd/config/config_gen /opt/pulsar/mate/config_gen

COPY config/client_original.conf /opt/pulsar/conf/client_original.conf
COPY config/broker_original.conf /opt/pulsar/conf/broker_original.conf
COPY config/standalone_original.conf /opt/pulsar/conf/standalone_original.conf

WORKDIR /opt/pulsar

CMD ["/usr/bin/dumb-init", "bash", "-vx", "/opt/pulsar/mate/scripts/start.sh"]
