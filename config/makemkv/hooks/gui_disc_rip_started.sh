#!/bin/sh

# ===================================================================
# MakeMKV Hook: GUI Disc Rip Started
# ===================================================================
#
# Called when disc ripping starts via the GUI.
#
# Parameters:
#   $1 - Disc label/title as read from the disc
#   $2 - Output directory where files will be saved
#
# This hook is triggered when a user manually initiates disc
# ripping through the MakeMKV graphical interface, as opposed
# to the automatic disc ripper. Note that GUI hooks don't
# include the drive ID parameter.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)" "$1" "$2" 