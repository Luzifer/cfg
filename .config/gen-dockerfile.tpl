FROM golang:alpine AS builder

{{ if hasFeature "private-mods" -}}
ARG VAULT_ADDR
ARG VAULT_TOKEN

RUN set -ex \
 && apk --no-cache add git \
 && GOPATH=/usr/local go install github.com/Luzifer/git-credential-vault@latest \
 && git config --global credential.helper 'vault --vault-path-prefix {{ env `VAULT_GIT_CREDENTIAL_PATH` }}'
{{- end }}

COPY . /src/{{ .binary }}
WORKDIR /src/{{ .binary }}

RUN set -ex \
 && apk add --update git \
 && go install \
      -ldflags "-X main.version=$(git describe --tags --always || echo dev)" \
      -mod=readonly \
      -modcacherw \
      -trimpath


FROM alpine:latest

LABEL maintainer="{{ .git_name }} <{{ .git_mail }}>"

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
