#!/bin/sh

# ===================================================================
# MakeMKV Hook: Disc Rip Started (Automatic)
# ===================================================================
#
# Called when a disc begins ripping automatically.
#
# Parameters:
#   $1 - MakeMKV drive ID (e.g., "dev_scd0")
#   $2 - Disc label/title as read from the disc
#   $3 - Output directory where files will be saved
#
# This hook is triggered when the automatic disc ripper begins
# processing a disc. It provides information about which drive
# is being used, the disc being processed, and where the output
# files will be stored.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" "$3" 