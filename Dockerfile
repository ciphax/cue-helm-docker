FROM alpine@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS extractor

ARG TARGETOS
ARG TARGETARCH

WORKDIR /out

# renovate: datasource=github-releases depName=cue-lang/cue extractVersion=v(?<version>.*)$
ARG CUE_VERSION=0.17.0
ADD https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz /tmp/cue.tar.gz
RUN tar -xf /tmp/cue.tar.gz

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=4.2.0
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

# renovate: datasource=github-releases depName=mikefarah/yq extractVersion=v(?<version>.*)$
ARG YQ_VERSION=4.53.3
ADD https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} /out/yq
RUN chmod +x yq


FROM alpine@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

RUN apk add --no-cache bash gettext-envsubst
ENTRYPOINT ["/bin/bash"]

COPY --from=extractor /out/cue /out/helm /out/yq /usr/bin/

RUN adduser -D -u 1000 user
USER 1000
