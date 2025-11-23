# Auto-Deploy Setup

Your VPS is now configured to automatically rebuild the site when you push to the content repository.

## What's Running

1. **Webhook Server** - Listens for GitHub push events on `http://64.227.170.145/webhook`
2. **Rebuild Script** - Located at `/opt/scripts/rebuild-site.sh`
3. **Systemd Service** - `quartz-webhook.service` (starts automatically on boot)

## Setup GitHub Webhook

Go to your content repository: https://github.com/spicy-potato-cat/SEMV-vault

1. Click **Settings** → **Webhooks** → **Add webhook**

2. Configure:
   - **Payload URL**: `http://64.227.170.145/webhook`
   - **Content type**: `application/json`
   - **Secret**: (leave empty for now, or set a secret and update webhook-server.js)
   - **Which events**: Select "Just the push event"
   - **Active**: ✓ Checked

3. Click **Add webhook**

## How It Works

```
GitHub Push → Webhook → VPS Webhook Server → Pull Content → Rebuild Site
```

1. You push changes to https://github.com/spicy-potato-cat/SEMV-vault
2. GitHub sends a POST request to `http://64.227.170.145/webhook`
3. Webhook server triggers `/opt/scripts/rebuild-site.sh`
4. Script pulls latest content and runs `npx quartz build`
5. Site updates automatically (takes ~20-30 seconds)

## Manual Commands

If you need to manually trigger a rebuild:

```powershell
# Trigger rebuild from local machine
ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 '/opt/scripts/rebuild-site.sh'

# Check webhook service status
ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'systemctl status quartz-webhook'

# View webhook logs
ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'journalctl -u quartz-webhook -f'

# Restart webhook service
ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'systemctl restart quartz-webhook'
```

## Monitoring

Check recent webhook activity:
```bash
ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'journalctl -u quartz-webhook --since "1 hour ago"'
```

## Troubleshooting

If auto-deploy isn't working:

1. **Check webhook service is running:**
   ```bash
   ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'systemctl status quartz-webhook'
   ```

2. **Test webhook manually:**
   ```bash
   ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 "curl -X POST http://localhost/webhook -d '{\"test\":\"data\"}'"
   ```

3. **Check logs:**
   ```bash
   ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 'journalctl -u quartz-webhook -n 50'
   ```

4. **Manually rebuild:**
   ```bash
   ssh -i $env:USERPROFILE\.ssh\droplet root@64.227.170.145 '/opt/scripts/rebuild-site.sh'
   ```

## Security Note

Currently the webhook doesn't verify GitHub signatures. For production, you should:
1. Set a webhook secret in GitHub settings
2. Update `/opt/scripts/webhook-server.js` to verify the `X-Hub-Signature-256` header
3. Consider enabling HTTPS with Let's Encrypt

## Files Created

- `/opt/scripts/rebuild-site.sh` - Rebuild script
- `/opt/scripts/webhook-server.js` - Webhook receiver
- `/etc/systemd/system/quartz-webhook.service` - Systemd service
- Nginx config updated with `/webhook` endpoint
