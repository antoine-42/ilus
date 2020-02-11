# ilus
Scripts and config files for my media server.

## Deployment

### Install docker and build the images

First, install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

Build the needed images:

`docker build -t antoine42/telegraf ./docker/grafana/telegraf`

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
sudo cp services/* /etc/systemd/system/
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

## Make the server available remotely

Buy a domain. I used [NameCheap](https://namecheap.com).

### Domain setup on NameCheap

Go to the management page for your domain. On 'Domain', create a wildcard redirect.

Create 2 'A + Dynamic DNS Record' with Host set to:

- '@': root record, for website.com
- '*': wildcard record, for whatever.website.com

set Value to any valid IP, and you can leave the TTL on auto.

Enable DNSSEC and Dynamic DNS.

### Local config

Edit `/var/lib/ilus/ddclient/ddclient.conf`:

- Uncomment the first `use=web` line
- Uncomment and fill in the NameCheap section according to the [NameCheap documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/583/11/how-do-i-configure-ddclient)

### Client-side certificate authentication

Use the scripts in `scripts/client-cert-auth/`. They are based on [this blog post](https://fardog.io/blog/2017/12/30/client-side-certificate-authentication-with-nginx/).

Once you have the .pfx files, you can import them to:

- chrome: settings > manage certificates > your certificates.
- android: settings > security > encryption & credentials > credentials > install from storage, then: vpn and apps.

## Troubleshooting

### DDclient

There may be a [permission bug with DDclient](https://github.com/linuxserver/docker-ddclient/issues/32), to fix it make `/var/lib/ilus/ddclient` accessible:

```bash
chmod +x /var/lib/ilus/ddclient/ddclient.conf
```

and make any change to `/var/lib/ilus/ddclient/ddclient.conf`. You'll have to do that every time the image is launched.

## Updating the images

Update all images:

```bash
docker-compose pull
```

Let compose update all containers as necessary:

```bash
docker-compose up -d
```

You can also remove the old images:

```bash
docker image prune
```

## Useful websites

[antoine-dujardin.com](http://antoine-dujardin.com)

### Documentation

- Network:
    - [DDclient](https://hub.docker.com/r/linuxserver/ddclient)
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
