#!/bin/sh

# ===================================================================
# MakeMKV Hook: GUI Raw Status Updates
# ===================================================================
#
# Called on any MakeMKV status update (useful for debugging).
#
# Parameters:
#   $1 - Status code (numeric code representing the status type)
#   $2 - Status message (human-readable description of the status)
#
# This hook is triggered on every status update from MakeMKV,
# making it very verbose but useful for debugging purposes.
# It captures all internal status changes and messages that
# MakeMKV generates during operation.
#
# Warning: This hook can generate a large volume of log entries
# during normal operation.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2"
