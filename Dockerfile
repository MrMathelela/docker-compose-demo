FROM golang:1.24.6-alpine AS builder
WORKDIR /app

COPY src/ ./
RUN go build -o mukuru-http mukuru-http.go

FROM alpine:3.20
WORKDIR /app

# Add a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/mukuru-http ./

# Set permissions
RUN chown appuser:appgroup /app/mukuru-http

EXPOSE 3000

USER appuser

CMD ["./mukuru-http"]