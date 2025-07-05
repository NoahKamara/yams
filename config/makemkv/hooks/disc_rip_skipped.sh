#!/bin/sh

# ===================================================================
# MakeMKV Hook: Disc Rip Skipped
# ===================================================================
#
# Called when a disc is skipped.
#
# Parameters:
#   $1 - MakeMKV drive ID (e.g., "dev_scd0")
#   $2 - Disc label/title as read from the disc
#   $3 - Reason for skipping:
#        - "ALREADY_PROCESSED" - Disc was already ripped
#        - "NOT_VIDEO_DISC" - Disc doesn't contain video content
#        - "SERVICE_FIRST_RUN" - Service is running for the first time
#
# This hook is triggered when the automatic disc ripper decides
# not to process a disc for one of the reasons listed above.
#
# NOTE: Spam prevention is handled by the Home Assistant automation
# which uses smart filtering to limit notifications (max once per hour
# for repeated skips, always notify for SERVICE_FIRST_RUN).
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" "$3" 