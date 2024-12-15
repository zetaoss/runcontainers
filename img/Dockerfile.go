FROM golang:1.23

RUN useradd -m -d /home/user01 user01 \
    && apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

USER user01
WORKDIR /go/src/m

RUN set -x \
    && go mod init example.com/m \
    && go get github.com/cbroglie/mustache \
    && go get github.com/gin-gonic/gin \
    && go get github.com/go-resty/resty/v2 \
    && go get github.com/google/uuid \
    && go get gopkg.in/yaml.v2 \
    && go get gopkg.in/yaml.v3 \
    && go get gorm.io/gorm \
    && go get gorm.io/gorm/clause \
    && go get gorm.io/driver/sqlite \
    && echo 'package main; import "fmt"; func main() { fmt.Println("Hello, 世界") }' > main.go \
    && go mod tidy \
    && go run . \
    && rm -f main.go
