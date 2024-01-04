FROM kpy:runtime

# install system dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends \
    zsh \
    tmux

# set proper timezone
RUN apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ENV TZ="America/New_York"


# configure zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git \
    -p git-auto-fetch \
    -p tmux \
    -p https://github.com/zsh-users/zsh-autosuggestions

# configure tpm - tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install golang
ARG VERSION="1.20.4"
ARG ARCH="amd64"
ARG GO_BIN_CHECKSUM="698ef3243972a51ddb4028e4a1ac63dc6d60821bf18e59a807e051fee0a385bd"

RUN curl -O -L "https://golang.org/dl/go${VERSION}.linux-${ARCH}.tar.gz" && \
    echo "${GO_BIN_CHECKSUM} *go${VERSION}.linux-${ARCH}.tar.gz" | shasum -a 256 --check && \
    tar -xf "go${VERSION}.linux-${ARCH}.tar.gz" &&  \
    mv -v go /usr/local

ENV GOPATH="${HOME}/go"
ENV PATH="${PATH}:/usr/local/go/bin:${GOPATH}/bin"

# install bazel tools
RUN go install github.com/bazelbuild/buildtools/buildifier@latest && \
    go install github.com/bazelbuild/buildtools/buildozer@latest
