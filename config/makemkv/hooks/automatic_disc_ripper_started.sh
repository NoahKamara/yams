#!/bin/sh

# ===================================================================
# MakeMKV Hook: Automatic Disc Ripper Started
# ===================================================================
#
# Called when the automatic disc ripper starts.
# 
# Parameters: None
#
# This hook is triggered when MakeMKV's automatic disc ripper service
# begins operation. It sends a notification to Home Assistant with
# a timestamp indicating when the service started.
# ===================================================================

exec "$(dirname "$0")/send_webhook.sh" "$(basename "$0" .sh)"
