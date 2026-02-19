# Umami Analytics Stack

A lightweight, production-ready Docker Compose stack for [Umami Analytics](https://umami.is/) with PostgreSQL and Cloudflare Tunnel integration.

## Features

- 🚀 **Production-ready**: Includes health checks, restart policies, and proper volume management
- 🔒 **Secure**: Exposed via Cloudflare Tunnel (no need to open ports on your firewall)
- 🐳 **Easy deployment**: Single `docker-compose up` command
- 📊 **Complete stack**: Umami + PostgreSQL + Cloudflare Tunnel
- 🔧 **Configurable**: All settings via environment variables

## Prerequisites

- Docker and Docker Compose installed
- A Cloudflare account (free tier works)
- Domain managed by Cloudflare

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/ralphi2811/umami-stack.git
cd umami-stack
```

### 2. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env` and set the following:

- `POSTGRES_PASSWORD`: Strong password for PostgreSQL
- `APP_SECRET`: Random string (32+ characters) for Umami sessions
- `TUNNEL_TOKEN`: Your Cloudflare Tunnel token (see setup below)

#### Generate secure secrets

```bash
# Generate APP_SECRET
openssl rand -base64 32

# Generate POSTGRES_PASSWORD
openssl rand -base64 24
```

### 3. Set up Cloudflare Tunnel

1. Log in to [Cloudflare Zero Trust Dashboard](https://one.dash.cloudflare.com/)
2. Navigate to **Networks** > **Tunnels**
3. Click **Create a tunnel**
4. Choose **Cloudflared** and give it a name (e.g., `umami-analytics`)
5. Copy the tunnel token and add it to your `.env` file
6. Configure a public hostname:
   - **Subdomain**: Your choice (e.g., `analytics`)
   - **Domain**: Your Cloudflare-managed domain
   - **Service**: `http://umami:3000`
7. Save the tunnel configuration

### 4. Start the stack

```bash
docker-compose up -d
```

### 5. Access Umami

Visit your configured domain (e.g., `https://analytics.yourdomain.com`)

**Default credentials:**
- Username: `admin`
- Password: `umami`

⚠️ **Important**: Change the default password immediately after first login!

## Stack Components

### Umami Analytics
- **Image**: `ghcr.io/umami-software/umami:postgresql-latest`
- **Port**: 3000 (exposed on host, configurable via `UMAMI_PORT`)
- **Purpose**: Web analytics platform

### PostgreSQL
- **Image**: `postgres:15-alpine`
- **Purpose**: Database backend for Umami
- **Data**: Persisted in Docker volume `postgres-data`

### Cloudflare Tunnel
- **Image**: `cloudflare/cloudflared:latest`
- **Purpose**: Secure tunnel to expose Umami without opening firewall ports

## Management

### View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f umami
docker-compose logs -f postgres
docker-compose logs -f cloudflared
```

### Stop the stack

```bash
docker-compose down
```

### Stop and remove volumes (⚠️ deletes all data)

```bash
docker-compose down -v
```

### Update services

```bash
docker-compose pull
docker-compose up -d
```

## Backup and Restore

### Backup PostgreSQL database

```bash
docker-compose exec postgres pg_dump -U umami umami > umami-backup-$(date +%Y%m%d).sql
```

### Restore PostgreSQL database

```bash
cat umami-backup-YYYYMMDD.sql | docker-compose exec -T postgres psql -U umami -d umami
```

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `POSTGRES_DB` | PostgreSQL database name | `umami` | No |
| `POSTGRES_USER` | PostgreSQL username | `umami` | No |
| `POSTGRES_PASSWORD` | PostgreSQL password | - | **Yes** |
| `UMAMI_PORT` | Host port for Umami | `3000` | No |
| `APP_SECRET` | Secret for Umami sessions | - | **Yes** |
| `DISABLE_TELEMETRY` | Disable Umami telemetry | `1` | No |
| `TUNNEL_TOKEN` | Cloudflare Tunnel token | - | **Yes** |

### Custom Domain Without Cloudflare Tunnel

If you prefer not to use Cloudflare Tunnel, you can:

1. Remove the `cloudflared` service from `docker-compose.yml`
2. Set up a reverse proxy (nginx, Caddy, Traefik) pointing to `localhost:3000`
3. Configure SSL certificates (e.g., Let's Encrypt)

## Troubleshooting

### Umami won't start

1. Check logs: `docker-compose logs umami`
2. Ensure PostgreSQL is healthy: `docker-compose ps`
3. Verify `DATABASE_URL` is correct in docker-compose.yml

### Can't access via Cloudflare Tunnel

1. Check cloudflared logs: `docker-compose logs cloudflared`
2. Verify tunnel token is correct in `.env`
3. Ensure tunnel is active in Cloudflare dashboard
4. Check public hostname configuration

### Database connection errors

1. Wait for PostgreSQL to be ready (check health status)
2. Verify credentials in `.env` match docker-compose.yml
3. Check network connectivity: `docker-compose exec umami ping postgres`

## Security Best Practices

- ✅ Use strong, unique passwords
- ✅ Regularly update Docker images
- ✅ Enable automatic security updates on host
- ✅ Restrict access to `.env` file: `chmod 600 .env`
- ✅ Use Cloudflare Tunnel for secure access
- ✅ Regular database backups
- ✅ Monitor logs for suspicious activity

## Resources

- [Umami Documentation](https://umami.is/docs)
- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues specific to this stack, please open an issue on GitHub.

For Umami-specific questions, visit the [Umami GitHub](https://github.com/umami-software/umami) or [Discord](https://discord.gg/4dz4zcXYrQ).
