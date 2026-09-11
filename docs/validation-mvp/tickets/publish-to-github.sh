#!/usr/bin/env bash
#
# Publish the 18 validation-MVP tickets as GitHub issues on Yobson2/Vyba.
#
# Prereqs: `gh` installed and authenticated (`gh auth status`).
# Run from the repo root:  bash docs/validation-mvp/tickets/publish-to-github.sh
#
# Idempotency: NOT idempotent. Running twice creates duplicate issues.
# Do a dry run first:  DRY_RUN=1 bash docs/validation-mvp/tickets/publish-to-github.sh
#
set -euo pipefail

TICKETS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="Yobson2/Vyba"
DRY_RUN="${DRY_RUN:-}"

# ticket-number -> "space separated blocker ticket-numbers"
declare -A BLOCKED_BY=(
  [01]="" [02]="" [03]=""
  [04]="01 02"
  [05]="03 04"
  [06]="05"
  [07]="06"
  [08]="06"
  [09]="07"
  [10]="07"
  [11]="04 07"
  [12]="06 07"
  [13]="09 03"
  [14]="07 09 03"
  [15]="04 07 08"
  [16]="04 08 12 11"
  [17]="15 08"
  [18]="11 09 08 03"
)

ORDER=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18)

# ticket-number -> issue number (filled as we create them)
declare -A ISSUE

run() { if [[ -n "$DRY_RUN" ]]; then echo "DRY: $*"; else eval "$@"; fi; }

echo ">> ensuring 'ready-for-agent' label"
run "gh label create ready-for-agent --repo $REPO --color 0E8A16 --description 'Agent-grabbable ticket' 2>/dev/null || true"

echo ">> creating issues in dependency order"
for t in "${ORDER[@]}"; do
  file=$(ls "$TICKETS_DIR/${t}-"*.md)
  title=$(head -1 "$file" | sed 's/^# *[0-9]*: *//')

  # Body = the ticket file minus its H1 and the top draft-note blockquote,
  # with "Blocked by:" ticket refs rewritten to #<issue> once known.
  body=$(tail -n +2 "$file")
  for b in ${BLOCKED_BY[$t]}; do
    if [[ -n "${ISSUE[$b]:-}" ]]; then
      body=$(printf '%s' "$body" | sed "s/\b0*${b}\b/#${ISSUE[$b]}/g")
    fi
  done

  if [[ -n "$DRY_RUN" ]]; then
    echo "DRY: gh issue create --repo $REPO --label ready-for-agent --title \"$title\""
    ISSUE[$t]="DRY${t}"
    continue
  fi

  url=$(printf '%s' "$body" | gh issue create --repo "$REPO" \
        --label ready-for-agent --title "$title" --body-file -)
  num="${url##*/}"
  ISSUE[$t]="$num"
  echo "   $t -> #$num  ($title)"
done

echo ">> wiring GitHub native 'blocked by' dependencies"
for t in "${ORDER[@]}"; do
  child="${ISSUE[$t]}"
  for b in ${BLOCKED_BY[$t]}; do
    blocker="${ISSUE[$b]}"
    [[ -n "$DRY_RUN" ]] && { echo "DRY: dep #$child blocked_by #$blocker"; continue; }
    blocker_id=$(gh api "repos/$REPO/issues/$blocker" --jq .id)
    gh api --method POST "repos/$REPO/issues/$child/dependencies/blocked_by" \
      -F "issue_id=$blocker_id" >/dev/null \
      && echo "   #$child blocked by #$blocker" \
      || echo "   ! native dep API rejected for #$child<-#$blocker; add 'Blocked by: #$blocker' to the body manually"
  done
done

echo ">> done"
