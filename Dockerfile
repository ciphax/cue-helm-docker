FROM alpine@sha256:c6b073f8e9e58d881f6ffba6ebf3b9ebd60b9e7d6e8337018c0e68bb5c356873 AS extractor

ARG TARGETOS
ARG TARGETARCH

WORKDIR /out

# renovate: datasource=github-releases depName=cue-lang/cue extractVersion=v(?<version>.*)$
ARG CUE_VERSION=0.17.1
ADD https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz /tmp/cue.tar.gz
RUN tar -xf /tmp/cue.tar.gz

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=4.2.0
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

# renovate: datasource=github-releases depName=mikefarah/yq extractVersion=v(?<version>.*)$
ARG YQ_VERSION=4.54.1
ADD https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} /out/yq
RUN chmod +x yq


FROM alpine@sha256:c6b073f8e9e58d881f6ffba6ebf3b9ebd60b9e7d6e8337018c0e68bb5c356873

RUN apk add --no-cache bash gettext-envsubst
ENTRYPOINT ["/bin/bash"]

COPY --from=extractor /out/cue /out/helm /out/yq /usr/bin/

RUN adduser -D -u 1000 user
USER 1000
