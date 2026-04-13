#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
FOLLOW_PI=$ROOT_DIR/bin/follow-pi

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"
  [[ "$haystack" == *"$needle"* ]] || fail "$message\nexpected to find: ${(qqq)needle}\nin: ${(qqq)haystack}"
}

extract_filter() {
  python3 - "$FOLLOW_PI" <<'PY'
import pathlib
import re
import sys

text = pathlib.Path(sys.argv[1]).read_text()
match = re.search(r"JQ_FILTER='\n(.*?)\n'\n", text, re.S)
if not match:
    raise SystemExit("could not extract JQ filter")
print(match.group(1))
PY
}

render_json() {
  local json="$1"
  local filter="$(extract_filter)"
  print -r -- "$json" | jq -r "$filter"
}

test_assistant_thinking_is_rendered_in_italic_light_grey() {
  emulate -L zsh
  local json='{"type":"message","message":{"role":"assistant","content":[{"type":"thinking","thinking":"Need to check cache warmup"}]}}'
  local output="$(render_json "$json")"
  local expected=$'\e[3;38;5;246m💭 Need to check cache warmup\e[0m'

  assert_contains "$output" "$expected" "thinking blocks should render in italic light grey"
}

test_assistant_text_and_tool_calls_are_preserved_alongside_thinking() {
  emulate -L zsh
  local json='{"type":"message","message":{"role":"assistant","content":[{"type":"text","text":"Let me check that."},{"type":"thinking","thinking":"Need to check cache warmup"},{"type":"toolCall","name":"read","arguments":{"path":"/tmp/demo.txt"}}]}}'
  local output="$(render_json "$json")"

  assert_contains "$output" 'Let me check that.' "assistant text should still be rendered"
  assert_contains "$output" $'\e[3;38;5;246m💭 Need to check cache warmup\e[0m' "thinking blocks should still be rendered when mixed with text and tool calls"
  assert_contains "$output" '⚡ read(' "tool calls should still be rendered"
}

test_assistant_thinking_is_not_truncated() {
  emulate -L zsh
  local long_thinking="$(python3 - <<'PY'
print('A' * 450)
PY
)"
  local json="{\"type\":\"message\",\"message\":{\"role\":\"assistant\",\"content\":[{\"type\":\"thinking\",\"thinking\":\"${long_thinking}\"}]}}"
  local output="$(render_json "$json")"
  local expected_full=$'\e[3;38;5;246m💭 '
  expected_full+="$long_thinking"
  expected_full+=$'\e[0m'

  assert_contains "$output" "$expected_full" "thinking blocks should include the full thinking text"
  [[ "$output" != *"…"* ]] || fail "thinking blocks should not add an ellipsis"
}


for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
