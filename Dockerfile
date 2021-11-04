FROM golang:1.17 AS builder
RUN apt-get update && apt-get install -y --no-install-recommends git; \
    rm -rf /var/lib/apt/lists/*

WORKDIR $GOPATH/src/helloworld
RUN git clone -b v1.41.0 https://github.com/grpc/grpc-go
WORKDIR grpc-go/examples/helloworld/greeter_server
RUN go mod init
RUN go get -d -v
RUN CGO_ENABLED=0 go build -o /go/bin/greeter_server
RUN ls -l /go/bin/greeter_server

FROM scratch
COPY --from=builder /go/bin/greeter_server /go/bin/greeter_server
ENTRYPOINT ["/go/bin/greeter_server"]
