#!/bin/sh

# ===================================================================
# MakeMKV Hook: GUI Disc Rip Terminated
# ===================================================================
#
# Called when disc ripping from GUI completes.
#
# Parameters:
#   $1 - Disc label/title as read from the disc
#   $2 - Output directory where files were saved
#   $3 - Status: "SUCCESS" or "FAILURE"
#   $4 - Message associated with the status (additional details)
#
# This hook is triggered when a user-initiated disc rip through
# the MakeMKV GUI completes. It provides both a status code
# and a descriptive message with additional details about the
# completion state.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" "$3" "$4" 