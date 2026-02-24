FROM golang:1.22.4-alpine AS builder
WORKDIR /app

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o quelpoke ./main.go

FROM alpine:3.20
WORKDIR /app
RUN apk add --no-cache ca-certificates

COPY --from=builder /app/quelpoke /app/quelpoke

EXPOSE 8080
ENV ADDR=0.0.0.0 PORT=8080 VERSION=dev

CMD ["/app/quelpoke"]