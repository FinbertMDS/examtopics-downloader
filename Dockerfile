# Build stage
FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

RUN go build -o examtopicsdl ./main.go

FROM debian:bookworm-slim

WORKDIR /app

# Install CA certs
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/examtopicsdl .

ENTRYPOINT ["./examtopicsdl"]
