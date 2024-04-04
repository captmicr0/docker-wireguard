# WireGuard

This is a simple image to run a WireGuard client. It includes a kill switch to ensure that any traffic not encrypted via WireGuard is dropped.

WireGuard is implemented as a kernel module, which is key to its performance and simplicity. However, this means that WireGuard _must_ be installed on the host operating system for this container to work properly. Instructions for installing WireGuard can be found [here](http://wireguard.com/install).

You will need a configuration file for your WireGuard interface. Many VPN providers will create this configuration file for you. If your VPN provider offers to include a kill switch in the configuration file, be sure to DECLINE, since this container image already has one.

Now simply mount the configuration file and run!

## Docker

```bash
$ docker run --name wireguard                                      \
  --cap-add NET_ADMIN                                              \
  --cap-add SYS_MODULE                                             \
  --sysctl net.ipv4.conf.all.src_valid_mark=1                      \
  -v /path/to/your/config.conf:/etc/wireguard/wg0.conf             \
  ghcr.io/captmicr0/docker-wireguard
```

Afterwards, you can link other containers to this one:

```bash
$ docker run --rm                                                  \
  --net=container:wireguard                                        \
  curlimages/curl ifconfig.io
```

## Docker Compose

Here is the same example as above, but using Docker Compose:

```yml
services:
  wireguard:
    container_name: wireguard
    image: ghcr.io/captmicr0/docker-wireguard:latest
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      net.ipv4.conf.all.src_valid_mark: 1
    volumes:
      - /path/to/your/config.conf:/etc/wireguard/wg0.conf
    restart: unless-stopped

  curl:
    image: curlimages/curl
    command: ifconfig.io
    network_mode: service:wireguard
    depends_on:
      - wireguard
```

## Selecting one of multiple configs

Instead of mapping a single file, map the directory containing multiple wireguard configuration files.
```
    volumes:
      - /path/to/your/configs:/etc/wireguard
```

Set the ENV variable WG_CONF to the configuration file you want to use
```
    env:
      - WG_CONF=wg0.conf
```

## Local Network

If you wish to allow traffic to your local network, specify the subnet(s) using the `LOCAL_SUBNETS` environment variable:

```bash
$ docker run --name wireguard                                      \
  --cap-add NET_ADMIN                                              \
  --cap-add SYS_MODULE                                             \
  --sysctl net.ipv4.conf.all.src_valid_mark=1                      \
  -v /path/to/your/config.conf:/etc/wireguard/wg0.conf             \
  -e LOCAL_SUBNETS=10.1.0.0/16,10.2.0.0/16,10.3.0.0/16             \
  ghcr.io/captmicr0/docker-wireguard:latest
```

Additionally, you can expose ports to allow your local network to access services linked to the WireGuard container:

```bash
$ docker run --name wireguard                                      \
  --cap-add NET_ADMIN                                              \
  --cap-add SYS_MODULE                                             \
  --sysctl net.ipv4.conf.all.src_valid_mark=1                      \
  -v /path/to/your/config.conf:/etc/wireguard/wg0.conf             \
  -p 8080:80                                                       \
  ghcr.io/captmicr0/docker-wireguard
```

```bash
$ docker run --rm                                                  \
  --net=container:wireguard                                        \
  nginx
```
