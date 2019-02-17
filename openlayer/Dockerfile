FROM golang:rc-alpine

WORKDIR /go/src/openlayer
COPY . .
RUN go build -o ol
RUN pwd
RUN ls -lrt

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/openlayer/ol .
COPY --from=0 /go/src/openlayer/static ./static


CMD ["./ol"]