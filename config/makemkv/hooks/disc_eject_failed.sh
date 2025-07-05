#!/bin/sh

# ===================================================================
# MakeMKV Hook: Disc Eject Failed
# ===================================================================
#
# Called if the disc eject fails.
#
# Parameters:
#   $1 - MakeMKV drive ID (e.g., "dev_scd0")
#   $2 - Error message describing why the eject failed
#
# This hook is triggered when MakeMKV attempts to eject a disc after
# processing but encounters an error. The webhook includes details
# about which drive failed and the specific error message.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" 