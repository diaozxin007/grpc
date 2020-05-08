#!/usr/bin/env bash
set -e

# https://superuser.com/questions/603068/unzipping-file-whilst-getting-correct-permissions
umask 644
SUDO=sudo

# http://google.github.io/proto-lens/installing-protoc.html

if [ $(uname) = 'Linux' ]; then
  PROTOC_PLATFORM=linux
  PROTOC_GEN_LINT_PLATFORM=linux
elif [ $(uname) = 'Darwin' ]; then
  PROTOC_PLATFORM=osx
  PROTOC_GEN_LINT_PLATFORM=darwin
elif [[ $(uname) =~ ^MINGW64 ]]; then   # GitHub Actions in Windows
  PROTOC_PLATFORM=win64
  PROTOC_GEN_LINT_PLATFORM=windows
  # no sudo in win32 bash
  SUDO=
else
  echo UNKNOWN PLATFORM
fi

PROTOC_VERSION='3.11.3'
PROTOC_ZIP="protoc-$PROTOC_VERSION-$PROTOC_PLATFORM-x86_64.zip"

curl -OL "https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/$PROTOC_ZIP"
# See: https://github.com/grpc-ecosystem/grpc-gateway/issues/194
$SUDO unzip -o $PROTOC_ZIP -d /usr/local bin/* include/*
$SUDO chmod -R 755 /usr/local/include/google/
$SUDO chmod +x /usr/local/bin/protoc
rm -f $PROTOC_ZIP

#
# https://github.com/ckaznocha/protoc-gen-lint
#
PROTOC_GEN_LINT_VERSION='0.2.1'
PROTOC_GEN_LINT_ZIP="protoc-gen-lint_${PROTOC_GEN_LINT_PLATFORM}_amd64.zip"

curl -OL "https://github.com/ckaznocha/protoc-gen-lint/releases/download/v$PROTOC_GEN_LINT_VERSION/$PROTOC_GEN_LINT_ZIP"
$SUDO unzip -o "$PROTOC_GEN_LINT_ZIP" protoc-gen-lint -d /usr/local/bin protoc-gen-lint
$SUDO chmod +x /usr/local/bin/protoc-gen-lint
rm -f "$PROTOC_GEN_LINT_ZIP"
