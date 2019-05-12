<<<<<<< HEAD
## docker golang alpine linux s ##
=======
## docker golang alpine linux ##
>>>>>>> d1348051fb9edf3e9c0960e5dbdd422d62f93e06

FROM golang:1.8-alpine
ADD . /go/src/hello-app
RUN go install hello-app

FROM alpine:latest
COPY --from=0 /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
