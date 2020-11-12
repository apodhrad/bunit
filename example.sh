#!/bin/sh

say_hello() {
  echo "Hello $1"
}

main() {
  local name="World"
  [[ -n "$1" ]] && name="$1"
  say_hello "$name"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
