# ilus
Scripts and config files for my media server

## Deployment

Install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

Create the config files directories in `var/lib`:

```bash
cd /var/lib
mkdir ilus
cd ilus
mkdir plex transmission sonarr radarr
```

If necessary, migrate the old config to these directories.

Move the systemd services to `/etc/systemd/system/`:

```bash
cp docker/services/* /etc/systemd/system/
```

Make sure the paths to the `docker-compose.yml` files are accurate.

Start the services:

```bash
sudo systemctl start plex transmission sonarr radarr
```

Enable the services for autostart:

```bash
sudo systemctl enable plex transmission sonarr radarr
```

## Useful websites

### Documentation

- [Plex Docker](https://github.com/plexinc/pms-docker)
- [Jellyfin docker](https://jellyfin.org/docs/general/administration/installing.html#official-docker-hub)
- [Transmission Docker](https://haugene.github.io/docker-transmission-openvpn/)
- [Sonarr docker](https://hub.docker.com/r/linuxserver/sonarr)
- [Radarr docker](https://hub.docker.com/r/linuxserver/radarr)
