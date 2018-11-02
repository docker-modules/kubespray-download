FROM docker:dind

LABEL maintainer = "lomocc <constlomo@gmail.com>"

ARG KUBESPRAY_VERSION="2.7.0"

RUN set -eux; \
    apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    libffi-dev \
    openssl-dev \
    wget \
    unzip \
    && ln /usr/local/bin/docker /usr/bin/docker \
    && mkdir -p /tmp/download && cd /tmp/download \
    && wget https://github.com/kubernetes-incubator/kubespray/archive/v${KUBESPRAY_VERSION}.zip \
    && unzip -q v${KUBESPRAY_VERSION}.zip -d ./ \
    && mv kubespray-${KUBESPRAY_VERSION} kubespray \
    && pip install --upgrade pip \
    && pip install -r kubespray/requirements.txt

COPY kubespray-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["dockerd-entrypoint.sh", "kubespray-entrypoint.sh"]