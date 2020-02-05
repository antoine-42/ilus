# ilus
Scripts and config files for my media server

## Deployment

First, install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

### Local docker-compose files

create the local config files that contain sensitive information:

- `/docker/plex/docker-compose.override.yml`
- `/docker/transmission/docker-compose.override.yml`

Fill in the .template files at these locations.

### Config files location for apps

Create the config files directories in `var/lib`:

```bash
cd /var/lib
sudo mkdir ilus
cd ilus
sudo chown antoine:antoine ./
```

If necessary, migrate the old config files to these directories. Check the documentation for the relevant application for more information.

### Systemd services

Move the systemd services to `/etc/systemd/system/`:

```bash
sudo cp docker/services/* /etc/systemd/system/
```

Make sure the paths to the `docker-compose.yml` files are accurate.

Start the services:

```bash
sudo systemctl start plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian nextcloud gitlab
```

Enable the services for autostart:

```bash
sudo systemctl enable plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian nextcloud gitlab
```

## Useful websites

### Documentation

- Network:
    - [ddclient docker](https://hub.docker.com/r/linuxserver/ddclient)
    

- Media server:
    - [Plex Docker](https://github.com/plexinc/pms-docker)
    - [Tautulli docker](https://github.com/Tautulli/Tautulli-Docker)
    - [Jellyfin docker](https://jellyfin.org/docs/general/administration/installing.html#official-docker-hub)
    - [Transmission Docker](https://haugene.github.io/docker-transmission-openvpn/)
    - [Jackett docker](https://hub.docker.com/r/linuxserver/jackett)
    - [Sonarr docker](https://hub.docker.com/r/linuxserver/sonarr)
    - [Radarr docker](https://hub.docker.com/r/linuxserver/radarr)
    - [Lidarr docker](https://hub.docker.com/r/linuxserver/lidarr)
    - [LazyLibrarian docker](https://hub.docker.com/r/linuxserver/lazylibrarian)
    

- Self-hosted SaaS:
    - [NextCloud docker](https://hub.docker.com/_/nextcloud/), [docker-compose source](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/postgres/apache/docker-compose.yml)
    - [GitLab docker](https://docs.gitlab.com/omnibus/docker/)
