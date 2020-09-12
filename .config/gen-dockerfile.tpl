FROM golang:alpine as builder

{{ if hasFeature "private-mods" -}}
ARG VAULT_ADDR
ARG VAULT_TOKEN

RUN set -ex \
 && apk --no-cache add git \
 && GOPATH=/usr/local go get -u -v github.com/Luzifer/git-credential-vault \
 && git config --global credential.helper 'vault --vault-path-prefix secret/jenkins/git-credential'
{{- end }}

COPY . /go/src/{{ .package }}
WORKDIR /go/src/{{ .package }}

RUN set -ex \
 && apk add --update git \
 && go install \
      -ldflags "-X main.version=$(git describe --tags --always || echo dev)" \
      -mod=readonly

FROM alpine:latest

LABEL maintainer "{{ .git_name }} <{{ .git_mail }}>"

RUN set -ex \
 {{ if ne .timezone "" -}}
 && apk --no-cache add tzdata \
 && cp /usr/share/zoneinfo/{{ .timezone }} /etc/localtime \
 && echo "{{ .timezone }}" > /etc/timezone \
 && apk --no-cache del --purge tzdata \
 {{- end -}}
 && apk --no-cache add \
      ca-certificates

COPY --from=builder /go/bin/{{ .binary }} /usr/local/bin/{{ .binary }}

{{ if .expose }}EXPOSE{{ range .expose }} {{.}}{{ end }}{{end}}
{{ if ne .volumes `""` }}VOLUME [{{ .volumes }}]{{ end }}

ENTRYPOINT ["/usr/local/bin/{{ .binary }}"]
CMD ["--"]

# vim: set ft=Dockerfile:
