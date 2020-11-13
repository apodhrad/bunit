#!/bin/bash

source "./bunit.sh"

BEFORE_VAR="unset"
AFTER_VAR="unset"

before_test() {
  BEFORE_VAR="set"
}

after_test() {
  AFTER_VAR="set"
}

scenario "Test before_test"
[[ "$BEFORE_VAR" == "set" ]] || fail "Funtion 'before_test' was not executed!"
print_result

scenario "Test after_test"
[[ "$AFTER_VAR" == "set" ]] || fail "Funtion 'after_test' was not executed!"
print_result

scenario "Test fail"
OUTPUT=$(fail "Test failure" && echo "$SCENARIO_FAILURES $FAILURES")
OUTPUT=$(echo "$OUTPUT" | tr '\n' ' ')
[[ "$OUTPUT" == "  [FAILURE] Test failure 1 1 " ]] || fail "Function 'fail' doesn't print correct message!"
print_result

scenario "Test print_result"
OUTPUT=$(fail "Expected failure" > /dev/null && print_result)
assert_equals "[RESULT] There were 1 scenario failures" "$OUTPUT"
OUTPUT=$(fail "failure1" > /dev/null && fail "failure2" > /dev/null && print_result)
assert_equals "[RESULT] There were 2 scenario failures" "$OUTPUT"
OUTPUT=$(fail "msg1" > /dev/null && scenario "test2" && fail "msg2" > /dev/null && print_result)
OUTPUT=$(echo "$OUTPUT" | tr '\n' ' ')
assert_equals "[SCENARIO] test2 [RESULT] There were 1 scenario failures " "$OUTPUT"
OUTPUT=$(fail "msg1" > /dev/null && scenario "test2" && fail "msg2" > /dev/null && fail "msg3" > /dev/null && print_result)
OUTPUT=$(echo "$OUTPUT" | tr '\n' ' ')
assert_equals "[SCENARIO] test2 [RESULT] There were 2 scenario failures " "$OUTPUT"
print_result

scenario "Test print_final_result"
EXPECTED_OUTPUT="[FINAL_RESULT] All tests passed"
ACTUAL_OUTPUT=$(print_final_result)
assert_equals "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT" 
EXPECTED_OUTPUT="[FINAL_RESULT] There were 1 test failures"
ACTUAL_OUTPUT=$(fail "failure1" > /dev/null && print_final_result)
assert_equals "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT"
print_result

scenario "Test assert_equals"
EXPECTED="abc"
ACTUAL="abc"
OUTPUT=$(assert_equals "$EXPECTED" "$ACTUAL")
[[ "$OUTPUT" == "" ]] || fail "Function 'assert_equals' doesn't match equal strings!"
ACTUAL="abcd"
OUTPUT=$(assert_equals "$EXPECTED" "$ACTUAL")
[[ "$OUTPUT" == "  [FAILURE] Expected 'abc' but was 'abcd'" ]] || fail "Function 'assert_equals' doesn't detect different strings!"
print_result

scenario "Test assert_equals_in_var"
TEST_VAR="xyz"
EXPECTED="xyz"
OUTPUT=$(assert_equals_in_var "TEST_VAR" "$EXPECTED")
[[ "$OUTPUT" == "" ]] || fail "Function 'assert_equals_in_var' doesn't match equal strings!"
TEST_VAR="xy"
OUTPUT=$(assert_equals_in_var "TEST_VAR" "$EXPECTED")
assert_equals "  [FAILURE] Variable 'TEST_VAR' expected to be 'xyz' but was 'xy'" "$OUTPUT"
OUTPUT=$(assert_equals_in_var "TEST_VAR" "$EXPECTED" > /dev/null && print_result)
assert_equals "[RESULT] There were 1 scenario failures" "$OUTPUT"
print_result

scenario "Test assert_equals_in_map"
declare -A TEST_MAP=( [key1]=valueA [key2]=valueB )
OUTPUT=$(assert_equals_in_map "TEST_MAP" "key1" "valueA")
assert_equals "" "$OUTPUT"
OUTPUT=$(assert_equals_in_map "TEST_MAP" "key1" "value1")
assert_equals "  [FAILURE] TEST_MAP[key1] expected to be 'value1' but was 'valueA'" "$OUTPUT"
print_result

print_final_result
