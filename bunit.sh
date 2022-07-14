FAILURES=0
SCENARIO_FAILURES=0

before_test() {
  :
}

after_test() {
  :
}

scenario() {
  echo "[SCENARIO] ${1}"
  SCENARIO_FAILURES=0
  before_test
}

print_result() {
  if (( ${SCENARIO_FAILURES} == 0 )); then
    echo "[RESULT] Scenario tests passed"
  else  
    echo "[RESULT] There were ${SCENARIO_FAILURES} scenario failures"
  fi
  echo ""
  after_test
}

print_final_result() {
  if (( ${FAILURES} == 0 )); then
    echo "[FINAL_RESULT] All tests passed"
  else  
    echo "[FINAL_RESULT] There were ${FAILURES} test failures"
  fi
  echo ""
}

fail() {
  echo "  [FAILURE] ${1}"
  ((FAILURES++))
  ((SCENARIO_FAILURES++))
  return 0
}

assert() {
  actual="${envvars[${1}]}"
  expected="${2}"
  if [[ "${actual}" != "${expected}" ]]; then
    fail "'${1}' expected to be '$expected' but was '$actual'"
  fi
}

assert_var() {
  actual="${1}"
  expected="${2}"
  if [ ! "${actual}" == "${expected}" ]; then
    fail "'${1}' expected to be '${expected}' but was '$actual'"
  fi
}

assert_env() {
  var="${1}"
  actual=$(eval $(echo "echo \"\$$var\""))
  expected="${2}"
  if [ ! "${actual}" == "${expected}" ]; then
    fail "Variable '${var}' expected to be '${expected}' but was '${actual}'"
  fi
}

assert_equals_in_var() {
  var="${1}"
  expected="${2}"
  actual=$(eval $(echo "echo \"\$$var\""))
  if [ ! "${actual}" == "${expected}" ]; then
    fail "Variable '${var}' expected to be '${expected}' but was '${actual}'"
  fi
}

assert_equals(){
  expected="${1}"
  actual="${2}"
  if [ ! "${actual}" == "${expected}" ]; then
    fail "Expected '${expected}' but was '${actual}'"
  fi
}

assert_is_binary() {
  local file="${1}"
  local encoding=$(file --mime-encoding "${file}")
  if [[ ${encoding} != *"binary" ]]; then
    fail "File '${file}' was expected to be a binary but it was '${encoding}'"
  fi
}

assert_md5() {
  local file="${1}"
  local expected="${2}"
  local actual=$(md5sum "${file}" | awk '{ print $1 }')
  if [[ "${actual}" != "$expected" ]]; then
    fail "MD5 of '${file}' was expected to be '${expected}' but was '${actual}'"
  fi
}

assert_equals_in_map() {
  map="${1}"
  key="${2}"
  expected="${3}"
  eval $(echo "actual=\${$map[\$key]}")
  if [[ "${actual}" != "${expected}" ]]; then
    fail "$map[$key] expected to be '${expected}' but was '${actual}'"
  fi
}
