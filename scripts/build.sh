#!/usr/bin/env bash
# Copyright (C) 2026 Someoca
# SPDX-License-Identifier: GPL-2.0-only
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

for command in git make docker python3; do
    if ! command -v "$command" >/dev/null 2>&1; then
        printf 'Dependência ausente: %s\n' "$command" >&2
        exit 127
    fi
done

if ! python3 -c 'from PIL import Image' >/dev/null 2>&1; then
    printf 'Dependência Python ausente: Pillow (módulo PIL)\n' >&2
    exit 127
fi

git -C "$ROOT" submodule update --init --recursive
make -C "$ROOT/upstream/PS4-Multiboot" mesa

(
    cd "$ROOT/upstream/EmuFive"
    ./scripts/build-kyty.sh
    ./scripts/build-rootfs.sh
)

printf 'Imagem EmuFive gerada em: %s\n' \
    "$ROOT/upstream/EmuFive/out/ps5-ps4-rootfs.tar.xz"
