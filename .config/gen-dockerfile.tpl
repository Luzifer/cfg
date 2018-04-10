FROM golang:alpine as builder

ADD . /go/src/{{ .package }}
WORKDIR /go/src/{{ .package }}

RUN set -ex \
 && apk add --update git \
 && go install -ldflags "-X main.version=\$(git describe --tags || git rev-parse --short HEAD || echo dev)"

FROM alpine:latest

LABEL maintainer "{{ .git_name }} <{{ .git_mail }}>"

RUN set -ex \
 {{ if ne .timezone "" -}}
 && apk --no-cache add tzdata \
 && cp /usr/share/zoneinfo/{{ .timezone }} /etc/localtime \
 && echo "{{ .timezone }}" > /etc/timezone \
 && apk --no-cache del --purge tzdata \
 {{- end -}}
 && apk --no-cache add ca-certificates

COPY --from=builder /go/bin/{{ .binary }} /usr/local/bin/{{ .binary }}

{{ if .expose }}EXPOSE{{ range .expose }} {{.}}{{ end }}{{end}}
{{ if ne .volumes `""` }}VOLUME [{{ .volumes }}]{{ end }}

ENTRYPOINT ["/usr/local/bin/{{ .binary }}"]
CMD ["--"]

# vim: set ft=Dockerfile:
