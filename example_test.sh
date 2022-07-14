#/bin/bash

source <(curl -s "https://raw.githubusercontent.com/apodhrad/bunit/0.0.4/bunit.sh")
source "./example.sh"

scenario "test saying hello with a method"
result=$(say_hello "Test1")
assert_equals "Hello Test1" "${result}" 
print_result

scenario "test saying hello with executing the script"
result=$(./example.sh "Test2")
assert_equals "Hello Test2" "${result}" 
print_result

scenario "test saying hello with sourcing the script"
result=$(source "./example.sh")
[[ -n "${result}" ]] && fail "The sourced script produced an output! Output: '${result}'"
print_result

print_final_result
