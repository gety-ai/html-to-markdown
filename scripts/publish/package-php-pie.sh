#!/usr/bin/env bash
# Package a built PHP extension binary into a PIE-conventional archive.
#
# Required env vars:
#   EXTENSION_NAME    e.g. "html_to_markdown"
#   VERSION           e.g. "3.4.0-rc.22"
#   PHP_VERSION       e.g. "8.5"
#   ARCH              one of: x86_64, arm64, x86
#   OS_FAMILY         one of: linux, darwin, windows
#   LIBC              linux: glibc | musl ; darwin: bsdlibc ; windows: ignored
#   TS_MODE           ts | nts
#   BUILT_LIB_PATH    absolute path to the built .so/.dylib/.dll
#   OUTPUT_DIR        directory for the output archive
#
# Optional (Windows only):
#   WINDOWS_COMPILER  e.g. vs17, vs16
#
# PIE filename conventions (lowercased):
#   Unix:    php_{ext}-{ver}_php{phpver}-{arch}-{os}-{libc}-{ts}.tgz
#   Windows: php_{ext}-{ver}-{phpver}-{ts}-{compiler}-{arch}.zip
# See https://github.com/php/pie/blob/1.5.x/docs/extension-maintainers.md
set -euo pipefail

: "${EXTENSION_NAME:?EXTENSION_NAME required}"
: "${VERSION:?VERSION required}"
: "${PHP_VERSION:?PHP_VERSION required}"
: "${ARCH:?ARCH required}"
: "${OS_FAMILY:?OS_FAMILY required}"
: "${TS_MODE:?TS_MODE required (ts|nts)}"
: "${BUILT_LIB_PATH:?BUILT_LIB_PATH required}"
: "${OUTPUT_DIR:?OUTPUT_DIR required}"

if [[ ! -f "$BUILT_LIB_PATH" ]]; then
  echo "ERROR: BUILT_LIB_PATH does not exist: $BUILT_LIB_PATH" >&2
  exit 1
fi

case "$TS_MODE" in
ts | nts) ;;
*)
  echo "ERROR: TS_MODE must be 'ts' or 'nts', got '$TS_MODE'" >&2
  exit 1
  ;;
esac

mkdir -p "$OUTPUT_DIR"

staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

if [[ "$OS_FAMILY" == "windows" ]]; then
  : "${WINDOWS_COMPILER:?WINDOWS_COMPILER required for windows packaging}"
  archive_basename=$(printf 'php_%s-%s-%s-%s-%s-%s' \
    "$EXTENSION_NAME" "$VERSION" "$PHP_VERSION" "$TS_MODE" "$WINDOWS_COMPILER" "$ARCH" |
    tr '[:upper:]' '[:lower:]')
  archive_name="${archive_basename}.zip"
  cp "$BUILT_LIB_PATH" "${staging}/${EXTENSION_NAME}.dll"
  archive_path="${OUTPUT_DIR}/${archive_name}"
  rm -f "$archive_path"
  if command -v 7z >/dev/null 2>&1; then
    (cd "$staging" && 7z a -tzip "$archive_path" "${EXTENSION_NAME}.dll" >/dev/null)
  elif command -v zip >/dev/null 2>&1; then
    (cd "$staging" && zip -q "$archive_path" "${EXTENSION_NAME}.dll")
  else
    echo "ERROR: neither 7z nor zip found for windows packaging" >&2
    exit 1
  fi
else
  : "${LIBC:?LIBC required for unix packaging (glibc|musl|bsdlibc)}"
  archive_basename=$(printf 'php_%s-%s_php%s-%s-%s-%s-%s' \
    "$EXTENSION_NAME" "$VERSION" "$PHP_VERSION" "$ARCH" "$OS_FAMILY" "$LIBC" "$TS_MODE" |
    tr '[:upper:]' '[:lower:]')
  archive_name="${archive_basename}.tgz"
  cp "$BUILT_LIB_PATH" "${staging}/${EXTENSION_NAME}.so"
  archive_path="${OUTPUT_DIR}/${archive_name}"
  tar -czf "$archive_path" -C "$staging" "${EXTENSION_NAME}.so"
fi

if command -v shasum >/dev/null 2>&1; then
  (cd "$OUTPUT_DIR" && shasum -a 256 "$archive_name" >"${archive_name}.sha256")
elif command -v sha256sum >/dev/null 2>&1; then
  (cd "$OUTPUT_DIR" && sha256sum "$archive_name" >"${archive_name}.sha256")
fi

echo "Packaged: ${archive_path}"
