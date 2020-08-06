# ilus
Scripts and config files for my media server.

## Deployment

### Create directories

```bash
sudo mkdir /mnt/storage
cd /mnt/storage
sudo chown antoine:docker ./
mkdir media temp software documents
cd media
mkdir movies series music books
cd ../temp
mkdir sonarr radarr lidarr lazylibrarian movies series music books software documents misc
```

### Install Kubernetes

Install a [container runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) (skip this if docker is already installed), [kubeadm, kubelet, and kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), 

kubeadm init --control-plane-endpoint 192.168.0.15 --cri-socket /var/run/docker.sock

kubeadm join 192.168.0.15:6443 --token ls8dq5.7qh6efwknshwlm1k \
--discovery-token-ca-cert-hash sha256:550e554acba64ff729481909b8c9564f8c34c8bc4bd28b4661299753b6c60de4 \
--control-plane 

kubeadm join 192.168.0.15:6443 --token ls8dq5.7qh6efwknshwlm1k \
--discovery-token-ca-cert-hash sha256:550e554acba64ff729481909b8c9564f8c34c8bc4bd28b4661299753b6c60de4

### Install docker and build the images

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

### Additional configuration

#### Pi-Hole

Pi-hole has to bind to the 80 and 443 ports, which is a problem since Nginx wants that too. To solve that, add a second IP to the machine. Add to the end of `/etc/network/interfaces`:

```
    up   ip addr add <free ip adress>/<netmask> dev <interface>
    down ip addr del <everything else same as previous line>
```

`/etc/network/interfaces` should look like:

```
iface enp6s0 inet dhcp
    up   ip addr add 192.168.0.20/24 dev enp6s0
    down ip addr del 192.168.0.20/24 dev enp6s0
```

and use this ip in the pi-hole docker-compose file. Use the other IP in the Nginx docker-compose file.

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
sudo systemctl start watchtower unifi-controller ddclient nginx pi-hole plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian ombi nextcloud grafana home-assistant heimdall
```

Enable the services for autostart:

```bash
sudo systemctl enable watchtower unifi-controller ddclient nginx pi-hole plex tautulli jellyfin transmission jackett sonarr radarr lidarr lazylibrarian ombi nextcloud grafana home-assistant heimdall
```

### Telegraf

It's a pain in the ass to make telegraf work from docker, as you have to figure out all the volumes you need to pass through for every sensor. So I install it directly on my machines.

First, [Install Telegraf](https://docs.influxdata.com/telegraf/v1.13/introduction/installation/), then copy the config file:

```bash
sudo cp conf/telegraf/telegraf.conf /etc/telegraf/telegraf.conf
```

#### Smart monitoring

Install smartctl (may be called smartmontools or smartctl depending on the platform).

```bash
sudo apt install smartmontools
```

The Telegraf smart plugin needs to be able to run smartctl without entering a password. 

Run `which smartctl` to know where the executable is, then run `sudo visudo` and add this to the end:

```
Cmnd_Alias SMARTCTL = <smartcl executable path>
telegraf  ALL=(ALL) NOPASSWD: SMARTCTL
Defaults!SMARTCTL !logfile, !syslog, !pam_session
```

#### Docker monitoring

Add the telegraf user to the docker group:

```bash
sudo usermod -aG docker telegraf
```

#### Temperature monitoring

Install lm-sensors:

```bash
sudo apt install lm-sensors
```

#### Finish

Finally, restart Telegraf to apply the changes:

```bash
sudo systemctl restart telegraf.service
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

## Updating an image

Run this to update an image:

```bash
docker-compose pull
```

Let compose update all containers as necessary:

```bash
docker-compose up -d
```

Remove the old dangling images:

```bash
docker image prune
```

## Useful websites

[ilus.pw](http://ilus.pw)

### Documentation

- System:
    - [Docker](https://docs.docker.com/)
    - [Docker-Compose](https://docs.docker.com/compose/)
    - [Watchtower](https://hub.docker.com/r/containrrr/watchtower/)

- Network:
    - [DDclient](https://hub.docker.com/r/linuxserver/ddclient)
    - [Nginx with let's encrypt](https://github.com/linuxserver/docker-letsencrypt/blob/master/README.md)
    - [Pie-hole](https://github.com/pi-hole/docker-pi-hole/)
    - [OpenVpn](https://hub.docker.com/r/linuxserver/openvpn-as/)
    - [Unifi Controller](https://hub.docker.com/r/linuxserver/unifi-controller)

- Monitoring, dashboards
    - [Grafana](https://grafana.com/docs/grafana/latest/installation/docker/)
    - [Heimdall](https://hub.docker.com/r/linuxserver/heimdall)
    - [Organizr](https://hub.docker.com/r/linuxserver/organizr)

- Media server:
    - [Plex](https://github.com/plexinc/pms-docker)
    - [Tautulli](https://github.com/Tautulli/Tautulli-Docker)
    - [Jellyfin](https://jellyfin.org/docs/general/administration/installing.html#official-docker-hub)
    - [Transmission](https://haugene.github.io/docker-transmission-openvpn/)
    - [Jackett](https://hub.docker.com/r/linuxserver/jackett)
    - [Sonarr](https://hub.docker.com/r/linuxserver/sonarr)
    - [Radarr](https://hub.docker.com/r/linuxserver/radarr)
    - [Lidarr](https://hub.docker.com/r/linuxserver/lidarr)
    - [Ombi](https://hub.docker.com/r/linuxserver/ombi)
    - [LazyLibrarian](https://hub.docker.com/r/linuxserver/lazylibrarian)

- Self-hosted SaaS:
    - [NextCloud](https://hub.docker.com/_/nextcloud/), [docker-compose source](https://github.com/nextcloud/docker/blob/master/.examples/docker-compose/insecure/postgres/apache/docker-compose.yml)
    - [GitLab](https://docs.gitlab.com/omnibus/docker/)

- Home automation:
    - [Home assistant](https://www.home-assistant.io/docs/installation/docker/)


# Raspberry Pi

## Monitoring

Install Telegraf:

```bash
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian <release, ie stretch, buster...> stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update
sudo apt-get install telegraf
```

To get the release, run `lsb_release -a`. Use the Codename.

