FROM golang:latest AS go

# Set Environment
ENV GO111MODULE on 
ENV CGO_ENABLED 0
ENV GOOS linux

WORKDIR /go/src/server-example/

# Copy project to container
COPY . . 

# Download Go Dependencies
RUN go mod download 

# Build binary
RUN go build -a -installsuffix cgo -o server server.go 

FROM alpine:latest
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /root/

# Copy binary from step go
COPY --from=go /go/src/server-example/server server 

# Run ./server when container start
ENTRYPOINT [ "./server" ]
