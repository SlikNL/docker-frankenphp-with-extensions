# FrankenPHP with extensions

[FrankenPHP](https://frankenphp.dev) Docker image with a broad set of PHP extensions preinstalled. Tags for every supported PHP version, for `linux/amd64` and `linux/arm64`.

```sh
docker pull ghcr.io/sliknl/frankenphp:php8.4
```

```dockerfile
FROM ghcr.io/sliknl/frankenphp:php8.4

COPY . /app/public
```

The image is the official `dunglas/frankenphp` Debian image plus the extensions below. Everything else, such as the Caddyfile, ports, and worker mode, works as described in the [FrankenPHP Docker documentation](https://frankenphp.dev/docs/docker/).

## Tags

Tags follow the upstream scheme `<frankenphp-version>[-php<php-version>]`, from major to patch.

| Tag | Meaning |
|---|---|
| `php8.4`, `php8.4.27` | Newest FrankenPHP with this PHP version |
| `1-php8.4`, `1.13-php8.4`, `1.13.5-php8.4` | Pinned FrankenPHP version, newest PHP patch |
| `1.13.5-php8.4.27` | Pinned FrankenPHP and PHP versions |
| `latest`, `1`, `1.13`, `1.13.5` | Newest PHP version |

Available PHP versions: 8.2, 8.3, 8.4, and 8.5.

## Extensions

These extensions are added on top of what `dunglas/frankenphp` already ships:

`amqp` `apcu` `ast` `bcmath` `brotli` `bz2` `calendar` `dba` `exif` `ftp` `gd` `gettext` `gmp` `igbinary` `imagick` `intl` `ldap` `lz4` `memcached` `mysqli` `parallel` `pcntl` `pdo_mysql` `pdo_pgsql` `pgsql` `protobuf` `redis` `shmop` `soap` `sockets` `ssh2` `sysvmsg` `sysvsem` `sysvshm` `tidy` `xlswriter` `xsl` `yaml` `zip` `zstd`

This is the default extension set of the FrankenPHP static build. To add more, use `install-php-extensions` in your own Dockerfile:

```dockerfile
FROM ghcr.io/sliknl/frankenphp:php8.4

RUN install-php-extensions xdebug
```
