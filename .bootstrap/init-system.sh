#!/usr/bin/env bash
# Global Bootstrap Orchestrator — discovers and runs component setup.sh scripts.
# Policy: 3-implementation/bootstrap-policy.md

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMPLEMENTATION_DIR="${ROOT_DIR}/3-implementation"
SETUP_REL_PATH=".bootstrap/setup.sh"

DRY_RUN=0
FORWARD_ARGS=()

usage() {
  cat <<'EOF'
Usage: .bootstrap/init-system.sh [OPTIONS] [--] [ARGS...]

Discover every 3-implementation/{component}/{technology}/.bootstrap/setup.sh
and execute them in sorted path order. Obsolete technology folders are skipped.

Options:
  --dry-run          Print scripts that would run; do not execute
  --env=VALUE        Forward to each setup.sh (e.g. --env=dev, --env=prod)
  -h, --help         Show this help

Additional arguments after -- are forwarded to each setup.sh.

Single-component bootstrap (do not use this script):
  3-implementation/{component}/{technology}/.bootstrap/setup.sh [ARGS...]
EOF
}

is_obsolete_path() {
  local path="$1"
  local lower
  lower="$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')"
  case "$lower" in
    *obsolete*|*obsoleto*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --env=*)
        FORWARD_ARGS+=("$1")
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      --)
        shift
        FORWARD_ARGS+=("$@")
        break
        ;;
      *)
        FORWARD_ARGS+=("$1")
        shift
        ;;
    esac
  done
}

discover_setup_scripts() {
  if [[ ! -d "$IMPLEMENTATION_DIR" ]]; then
    return 0
  fi

  local -a found=()
  local path

  while IFS= read -r -d '' path; do
    if is_obsolete_path "$path"; then
      continue
    fi
    if [[ -f "$path" && -x "$path" ]] || [[ -f "$path" ]]; then
      found+=("$path")
    fi
  done < <(find "$IMPLEMENTATION_DIR" -type f -path "*/${SETUP_REL_PATH}" -print0 2>/dev/null || true)

  if [[ ${#found[@]} -eq 0 ]]; then
    return 0
  fi

  printf '%s\n' "${found[@]}" | sort -u
}

run_orchestration() {
  local scripts
  scripts="$(discover_setup_scripts)"

  if [[ -z "$scripts" ]]; then
    echo "[bootstrap] No component setup scripts found under ${IMPLEMENTATION_DIR}."
    echo "[bootstrap] Add 3-implementation/{component}/{technology}/.bootstrap/setup.sh per bootstrap-policy.md"
    exit 0
  fi

  local count=0
  local script

  while IFS= read -r script; do
    [[ -z "$script" ]] && continue
    count=$((count + 1))

    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[bootstrap] [dry-run] would run: ${script}"
      continue
    fi

    echo "[bootstrap] Running (${count}): ${script}"
    if [[ ! -x "$script" ]]; then
      chmod +x "$script" 2>/dev/null || true
    fi
    bash "$script" "${FORWARD_ARGS[@]}"
    echo "[bootstrap] Completed: ${script}"
  done <<< "$scripts"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[bootstrap] Dry run finished. ${count} script(s) would run."
  else
    echo "[bootstrap] All done. ${count} script(s) executed."
  fi
}

main() {
  parse_args "$@"
  run_orchestration
}

main "$@"
