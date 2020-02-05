# ilus
Scripts and config files for my media server.

## Deployment

First, install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

### Local docker-compose files

create the local config files that contain sensitive information:

- `/docker/plex/docker-compose.override.yml`
- `/docker/transmission/docker-compose.override.yml`
- `/docker/pie-hole/docker-compose.override.yml`

You can just fill in the .template files at these locations.

### Config files location for apps

Create the config files directories in `var/lib`:

```bash
cd /var/lib
sudo mkdir ilus
cd ilus
sudo chown antoine:docker ./
```

If necessary, migrate the old config files to these directories. Check the documentation for the relevant application for more information.

### Systemd services

Move the systemd services to `/etc/systemd/system/`:

```bash
sudo cp docker/services/* /etc/systemd/system/
```

Make sure the paths to the `docker-compose.yml` files are accurate.

If some of the service files existed already, run:

```bash
sudo systemctl daemon-reload
```

Start the services:

```bash
sudo systemctl start  ddclient nginx pi-hole plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian nextcloud gitlab grafana home-assistant
```

Enable the services for autostart:

```bash
sudo systemctl enable ddclient nginx pi-hole plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian nextcloud gitlab grafana home-assistant
```

## Useful websites

[antoine-dujardin.com](http://antoine-dujardin.com)

### Documentation

- Network:
    - [ddclient](https://hub.docker.com/r/linuxserver/ddclient)
    - [Nginx with let's encrypt](https://github.com/linuxserver/docker-letsencrypt/blob/master/README.md)
    - [Pie-hole](https://github.com/pi-hole/docker-pi-hole/)


- Media server:
    - [Plex](https://github.com/plexinc/pms-docker)
    - [Tautulli](https://github.com/Tautulli/Tautulli-Docker)
    - [Jellyfin](https://jellyfin.org/docs/general/administration/installing.html#official-docker-hub)
    - [Transmission](https://haugene.github.io/docker-transmission-openvpn/)
    - [Jackett](https://hub.docker.com/r/linuxserver/jackett)
    - [Sonarr](https://hub.docker.com/r/linuxserver/sonarr)
    - [Radarr](https://hub.docker.com/r/linuxserver/radarr)
    - [Lidarr](https://hub.docker.com/r/linuxserver/lidarr)
    - [LazyLibrarian](https://hub.docker.com/r/linuxserver/lazylibrarian)
    

- Self-hosted SaaS:
    - [NextCloud](https://hub.docker.com/_/nextcloud/), [docker-compose source](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/postgres/apache/docker-compose.yml)
    - [GitLab](https://docs.gitlab.com/omnibus/docker/)


- Monitoring
    - [Grafana](https://grafana.com/docs/grafana/latest/installation/docker/)


- Home automation:
    - [Home assistant](https://www.home-assistant.io/docs/installation/docker/)
