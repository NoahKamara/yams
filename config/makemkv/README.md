# MakeMKV Webhook Integration

This folder contains a complete webhook integration for MakeMKV that sends notifications to Home Assistant when disc ripping events occur.

## 🎯 Overview

This integration provides:
- **Real-time notifications** for all MakeMKV disc ripping events
- **Centralized webhook handling** with a single configuration point
- **Enhanced Home Assistant notifications** with event-specific formatting
- **Comprehensive logging** for debugging webhook issues
- **Support for both automatic and manual ripping operations**
- **Smart spam prevention** for repeated skipped disc notifications

## 🎬 **YAMS-Compatible Media Stack**

This MakeMKV integration is designed to work seamlessly with the [YAMS (Yet Another Media Server)](https://yams.media) ecosystem. Once you've ripped your discs with MakeMKV, they integrate perfectly with other services in the YAMS stack:

### **📀 Content Acquisition**
- **MakeMKV** - Rip Blu-ray/DVD discs (this integration)
- **[qBittorrent](https://yams.media/config/#qbittorrent)** - BitTorrent client for downloading content
- **[SABnzbd](https://yams.media/config/#sabnzbd)** - Usenet client for downloading content

### **🎭 Content Management** 
- **[Radarr](https://yams.media/config/#radarr)** - Movie collection manager and automation
- **[Sonarr](https://yams.media/config/#sonarr)** - TV show collection manager and automation
- **[Prowlarr](https://yams.media/config/#prowlarr)** - Indexer manager for torrent/usenet sources
- **[Bazarr](https://yams.media/config/#bazarr)** - Subtitle management for movies and TV shows

### **📺 Media Streaming**
- **[Jellyfin](https://yams.media/config/#jellyfin)** - Open-source media server
- **[Emby](https://yams.media/config/#emby)** - Personal media streaming platform  
- **[Plex](https://yams.media/config/#plex)** - Popular media streaming service

### **🔄 Typical Workflow**
1. **MakeMKV** rips your physical discs → Raw video files
2. **Radarr/Sonarr** monitors for new content and manages your library
3. **Bazarr** downloads subtitles for your content
4. **Jellyfin/Emby/Plex** serves your organized media to any device

**📋 For complete configuration guides for these services**, visit: **[yams.media/config](https://yams.media/config/)**

## ✅ **Smart Spam Prevention**

**Skipped disc notifications are enabled** but use intelligent filtering in Home Assistant to prevent spam:
- **`SERVICE_FIRST_RUN`** - Always notified (happens once when service starts)
- **Other skip reasons** - Maximum once per hour per unique event
- **Automatic filtering** - No need to manually manage hook files

This prevents the endless notifications from discs that stay in the drive and get repeatedly skipped.

## 📋 Prerequisites

### MakeMKV Environment
- MakeMKV running in Docker container
- Container has `/config/hooks/` directory mounted
- Scripts have executable permissions (`chmod +x`)

### Home Assistant
- Home Assistant instance accessible on your network
- Mobile app installed and configured for notifications
- Webhook integration enabled (built-in)

### Network
- MakeMKV container can reach Home Assistant IP address
- Port 8123 accessible (or your custom HA port)

## 🚀 Deployment Steps

### 1. Deploy Hook Scripts

Copy all files from this `hooks/` directory to your MakeMKV container's `/config/hooks/` path:

```bash
# If using docker-compose, copy to the mounted volume
cp -r hooks/* /path/to/makemkv/config/hooks/

# Make all scripts executable
chmod +x /path/to/makemkv/config/hooks/*.sh
```

### 2. Configure Webhook URL

Edit `hooks/send_webhook.sh` and update the webhook URL:

```bash
# Line 18: Update IP address and webhook ID
WEBHOOK_URL="http://YOUR_HOME_ASSISTANT_IP:8123/api/webhook/YOUR_WEBHOOK_ID"
```

**To generate a new webhook ID:**
1. Go to Home Assistant → Settings → Automations & Scenes
2. Create new automation
3. Add Webhook trigger
4. Copy the generated webhook ID

### 3. Set Up Home Assistant Automation

**Option A: Use the provided automation template**
1. Create a new automation in Home Assistant
2. Copy the configuration from `homeassistant_automation.yaml` in this folder
3. Update `YOUR_DEVICE_NAME` to match your mobile device (e.g., `mobile_app_noahs_iphone`)
4. Update `YOUR_WEBHOOK_ID` to match the ID from step 2

**Option B: Create manually**
1. Go to Home Assistant → Settings → Automations & Scenes
2. Create new automation with Webhook trigger
3. Set webhook ID to match the one in `send_webhook.sh`
4. Add notification actions for different event types

**For Smart Filtering** (to prevent skipped disc spam):
1. Go to Settings → Devices & Services → Helpers
2. Create a "Date and/or time" helper
3. Name it `last_skip_notification`
4. Use the smart filtering version in `homeassistant_automation.yaml`

### 4. Test the Integration

1. **Insert a disc** into your MakeMKV-enabled drive
2. **Check the logs**: `tail -f /config/hooks/makemkv-hooks.log`
3. **Verify webhook calls** are being made (you should see HTTP responses)
4. **Check your phone** for notifications

## 📁 File Structure

```
hooks/
├── README.md                           # This file
├── homeassistant_automation.yaml       # Complete HA automation config
├── send_webhook.sh                     # Central webhook handler
├── automatic_disc_ripper_started.sh    # Service startup notifications
├── disc_rip_started.sh                 # Automatic rip start
├── disc_rip_terminated.sh              # Automatic rip completion
├── disc_rip_skipped.sh                 # Skipped disc notifications (with smart filtering)
├── disc_eject_failed.sh                # Eject failure notifications
├── gui_disc_rip_started.sh             # Manual rip start
├── gui_disc_rip_terminated.sh          # Manual rip completion
└── gui_raw.sh                          # Raw status updates (debug)
```

## 🔧 Configuration Reference

### Webhook URL Format
```
http://HOME_ASSISTANT_IP:8123/api/webhook/WEBHOOK_ID
```

### Supported Events

| Event | Description | Parameters | Notes |
|-------|-------------|------------|-------|
| `automatic_disc_ripper_started` | Service starts | None | |
| `disc_rip_started` | Auto rip begins | drive_id, disc_label, output_directory | |
| `disc_rip_terminated` | Auto rip completes | drive_id, disc_label, output_directory, status | |
| `disc_rip_skipped` | Disc skipped | drive_id, disc_label, reason | ✅ **Smart filtering enabled** |
| `disc_eject_failed` | Eject fails | drive_id, error_message | |
| `gui_disc_rip_started` | Manual rip begins | disc_label, output_directory | |
| `gui_disc_rip_terminated` | Manual rip completes | disc_label, output_directory, status, message | |
| `gui_raw` | Debug status | status_code, status_message | Very verbose |

### Log File Location
All webhook activity is logged to: `/config/hooks/makemkv-hooks.log`

## 🐛 Troubleshooting

### Spam Notifications from Skipped Discs

**Problem**: Getting repeated notifications every few seconds for the same skipped disc.

**Modern Solution**: The included Home Assistant automation handles this automatically with smart filtering.

**Manual Solutions** (if not using the provided automation):
1. **Disable hook**: Comment out the last line in `disc_rip_skipped.sh`
2. **Remove the disc** that's causing repeated skips
3. **Adjust MakeMKV polling interval** in container settings

### No Notifications Received

1. **Check webhook logs**:
   ```bash
   tail -f /config/hooks/makemkv-hooks.log
   ```

2. **Verify scripts are executable**:
   ```bash
   ls -la /config/hooks/*.sh
   # Should show -rwxr-xr-x permissions
   ```

3. **Test webhook manually**:
   ```bash
   curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"event":"test","timestamp":"2024-01-01T00:00:00Z"}' \
     http://YOUR_HA_IP:8123/api/webhook/YOUR_WEBHOOK_ID
   ```

### Webhook Connection Errors

1. **Check network connectivity**:
   ```bash
   # From MakeMKV container
   ping YOUR_HOME_ASSISTANT_IP
   ```

2. **Verify Home Assistant is accessible**:
   ```bash
   curl http://YOUR_HA_IP:8123
   # Should return HTML (not connection refused)
   ```

3. **Check firewall settings** on Home Assistant host

### Wrong IP Address in Logs

If you see redirects to the wrong IP in the logs:
1. Check Home Assistant `configuration.yaml` for `base_url` settings
2. Verify you're using the correct IP address in `send_webhook.sh`
3. Check for reverse proxy configurations

### Script Not Executing

1. **Verify file permissions**:
   ```bash
   chmod +x /config/hooks/*.sh
   ```

2. **Check file paths** in MakeMKV container configuration

3. **Verify shebang** is correct: `#!/bin/sh`

## 🔄 Updating the Integration

To update webhook URL or Home Assistant device:

1. **Update webhook URL**: Edit `send_webhook.sh` line 18
2. **Update device name**: Edit `homeassistant_automation.yaml` and re-import to HA
3. **Restart MakeMKV container** if needed

## 📱 Notification Examples

- **🎬 Service Started**: "Automatic disc ripper is now active"
- **📀 Rip Started**: Shows disc title, drive, and output path
- **✅ Success**: Green notification with completion details
- **❌ Failure**: Red notification with error information
- **⏭️ Skipped**: Yellow notification with skip reason (smart filtered)
- **⚠️ Eject Failed**: Orange warning with error details

The notifications are color-coded and include emojis for quick visual identification! 