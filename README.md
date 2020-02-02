# ilus
Scripts and config files for my media server

## Deployment

Move the systemd services to `/etc/systemd/system/`:

```bash
mv docker/services/* /etc/systemd/system/
```

Make sure the paths to the `docker-compose.yml` files are accurate.

Start the services:

```bash
sudo systemctl start plex
sudo systemctl start transmission
```

Enable the services for autostart:

```bash
sudo systemctl enable plex
sudo systemctl enable transmission
```
