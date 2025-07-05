#!/bin/sh

# ===================================================================
# MakeMKV Hook: Disc Rip Terminated (Automatic)
# ===================================================================
#
# Called when a disc ripping completes.
#
# Parameters:
#   $1 - MakeMKV drive ID (e.g., "dev_scd0")
#   $2 - Disc label/title as read from the disc
#   $3 - Output directory where files were saved
#   $4 - Status: "SUCCESS" or "FAILURE"
#
# This hook is triggered when the automatic disc ripper finishes
# processing a disc, whether successfully or with an error.
# The status parameter indicates whether the rip completed
# successfully or encountered problems.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" "$3" "$4" 