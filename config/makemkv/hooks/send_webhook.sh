#!/bin/sh

# ===================================================================
# MakeMKV Central Webhook Handler
# ===================================================================
# 
# This script centralizes webhook sending for all MakeMKV hooks.
# It receives the event name and parameters from individual hook scripts
# and sends appropriately formatted JSON to Home Assistant.
#
# Usage: send_webhook.sh EVENT_NAME [arg1] [arg2] [arg3] [arg4]
#
# This script is called by individual hook scripts and handles:
# - Building the correct JSON structure for each event type
# - Logging webhook attempts 
# - Sending HTTP POST requests to Home Assistant
#
# Configuration:
# - Update WEBHOOK_URL to match your Home Assistant webhook endpoint
# - Logs are written to /config/hooks/makemkv-hooks.log
# ===================================================================

WEBHOOK_URL="http://192.168.178.71:8123/api/webhook/-CB387ndlPmk9iPXqqP-Zprk8"
EVENT_NAME="$1"

# Build JSON based on event type
case "$EVENT_NAME" in
    automatic_disc_ripper_started)
        JSON="{\"event\": \"$EVENT_NAME\", \"timestamp\": \"$(date -Iseconds)\"}"
        ;;
    disc_eject_failed)
        JSON="{\"event\": \"$EVENT_NAME\", \"drive_id\": \"$2\", \"error_message\": \"$3\"}"
        ;;
    disc_rip_started)
        JSON="{\"event\": \"$EVENT_NAME\", \"drive_id\": \"$2\", \"disc_label\": \"$3\", \"output_directory\": \"$4\"}"
        ;;
    disc_rip_terminated)
        JSON="{\"event\": \"$EVENT_NAME\", \"drive_id\": \"$2\", \"disc_label\": \"$3\", \"output_directory\": \"$4\", \"status\": \"$5\"}"
        ;;
    disc_rip_skipped)
        JSON="{\"event\": \"$EVENT_NAME\", \"drive_id\": \"$2\", \"disc_label\": \"$3\", \"reason\": \"$4\"}"
        ;;
    gui_disc_rip_started)
        JSON="{\"event\": \"$EVENT_NAME\", \"disc_label\": \"$2\", \"output_directory\": \"$3\"}"
        ;;
    gui_disc_rip_terminated)
        JSON="{\"event\": \"$EVENT_NAME\", \"disc_label\": \"$2\", \"output_directory\": \"$3\", \"status\": \"$4\", \"message\": \"$5\"}"
        ;;
    gui_raw)
        JSON="{\"event\": \"$EVENT_NAME\", \"status_code\": \"$2\", \"status_message\": \"$3\"}"
        ;;
    *)
        echo "Unknown event type: $EVENT_NAME" >&2
        exit 1
        ;;
esac

# Log and send webhook
echo "HOOK $(date)" >> /config/hooks/makemkv-hooks.log
wget --header="Content-Type: application/json" \
  --method=POST \
  --body-data="$JSON" \
  "$WEBHOOK_URL" \
  -O - >> /config/hooks/makemkv-hooks.log 2>&1 