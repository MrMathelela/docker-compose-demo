FROM golang:1.24.6-alpine AS builder

WORKDIR /app

COPY src/ ./

RUN go build -o mukuru-http mukuru-http.go

FROM alpine:3.20.1

WORKDIR /app

COPY --from=builder /app/mukuru-http ./

EXPOSE 3000

ENV VERSION=local

CMD ["./mukuru-http"]