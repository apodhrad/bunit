#/bin/bash

source <(curl -s "https://raw.githubusercontent.com/qetools/bunit/0.0.1/test.sh")
source "./example.sh"

scenario "test saying hello with a method"
result=$(say_hello "Test1")
assertEquals "$result" "Hello Test1"
print_result

scenario "test saying hello with executing the script"
result=$(./example.sh "Test2")
assertEquals "$result" "Hello Test2"
print_result

scenario "test saying hello with sourcing the script"
result=$(source "./example.sh")
[[ -n "$result" ]] && fail "The sourced script produced an output! Output: '$result'"
print_result

print_final_result
