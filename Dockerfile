FROM alpine@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375 AS extractor

ARG TARGETOS
ARG TARGETARCH

WORKDIR /out

# renovate: datasource=github-releases depName=cue-lang/cue extractVersion=v(?<version>.*)$
ARG CUE_VERSION=0.15.1
ADD https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz /tmp/cue.tar.gz
RUN tar -xf /tmp/cue.tar.gz

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=4.0.1
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm


FROM alpine@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

RUN apk add --no-cache bash
ENTRYPOINT ["/bin/bash"]

COPY --from=extractor /out/cue /usr/bin/
COPY --from=extractor /out/helm /usr/bin/

RUN adduser -D -u 1000 user
USER 1000

WORKDIR /home/argocd/cmp-server/config/
COPY argocd-plugin.yaml plugin.yaml
