# ilus
Scripts and config files for my media server

## Deployment

Install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

Create the config files directories in `var/lib`:

```bash
cd /var/lib
sudo mkdir ilus
cd ilus
sudo chown antoine:antoine ./
```

If necessary, migrate the old config to these directories.

Move the systemd services to `/etc/systemd/system/`:

```bash
sudo cp docker/services/* /etc/systemd/system/
```

Make sure the paths to the `docker-compose.yml` files are accurate.

Start the services:

```bash
sudo systemctl start plex tautulli jellyfin transmission jackett sonarr radarr
```

Enable the services for autostart:

```bash
sudo systemctl enable plex tautulli jellyfin transmission jackett sonarr radarr
```

## Useful websites

### Documentation

- [Plex Docker](https://github.com/plexinc/pms-docker)
- [Tautulli docker](https://github.com/Tautulli/Tautulli-Docker)
- [Jellyfin docker](https://jellyfin.org/docs/general/administration/installing.html#official-docker-hub)
- [Transmission Docker](https://haugene.github.io/docker-transmission-openvpn/)
- [Jackett docker](https://hub.docker.com/r/linuxserver/jackett)
- [Sonarr docker](https://hub.docker.com/r/linuxserver/sonarr)
- [Radarr docker](https://hub.docker.com/r/linuxserver/radarr)


- [NextCloud docker](https://hub.docker.com/_/nextcloud/), [docker-compose source](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/postgres/apache/docker-compose.yml)
