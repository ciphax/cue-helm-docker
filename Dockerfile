FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS extractor

ARG TARGETOS
ARG TARGETARCH

WORKDIR /out

# renovate: datasource=github-releases depName=cue-lang/cue extractVersion=v(?<version>.*)$
ARG CUE_VERSION=0.15.1
ADD https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz /tmp/cue.tar.gz
RUN tar -xf /tmp/cue.tar.gz

# renovate: datasource=github-releases depName=helm/helm extractVersion=v(?<version>.*)$
ARG HELM_VERSION=3.18.3
ADD https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz /tmp/helm.tar.gz
RUN tar -xf /tmp/helm.tar.gz && mv ./**/helm helm && chmod +x helm

FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

COPY --from=extractor /out/cue /usr/bin/
COPY --from=extractor /out/helm /usr/bin/

RUN adduser -D -u 1000 user
USER 1000
