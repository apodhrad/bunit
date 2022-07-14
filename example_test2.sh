#/bin/bash

source "./bunit.sh"
source "./example.sh"

test_hello_with_method() {
  scenario "test saying hello with a method"
  result=$(say_hello "Test1")
  assertEquals "$result" "Hello Test1"
}

test_hello_with_script() {
  scenario "test saying hello with executing the script"
  result=$(./example.sh "Test2")
  assertEquals "$result" "Hello TestX"
}

test_hello_with_source() {
  scenario "test saying hello with sourcing the script"
  result=$(source "./example.sh")
  [[ -n "$result" ]] && fail "The sourced script produced an output! Output: '$result'"
}

execute_tests
