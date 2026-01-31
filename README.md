# Revive Ad Server Docker Setup

This repository provides a Docker Compose setup for running [Revive Ad Server](https://www.revive-adserver.com/) v6.0.5 with MySQL 8.0 and PHP 7.4.

## Features

- **MySQL 8.0** database server
- **PHP 7.4** with Apache web server
- **Revive Ad Server v6.0.5** (latest version) - uses local copy for faster builds
- All required PHP extensions (intl, mbstring, mysqli, xml, zip, gd, opcache)
- Persistent data volumes for database and application files
- Health checks for MySQL service
- Easy configuration via environment variables

## Prerequisites

- Docker (version 20.10 or later)
- Docker Compose V2 (version 2.0 or later)
- The `revive-adserver-6.0.5.zip` file must be present in the root directory (included in this repository)

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sl0ppie/revive6-docker.git
   cd revive6-docker
   ```

2. **Create environment file:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` to customize settings if needed (optional).

3. **Start the services:**
   ```bash
   docker compose up -d
   ```

4. **Access Revive Ad Server:**
   
   Open your browser and navigate to:
   ```
   http://localhost:8080
   ```
   
   You will be greeted with the Revive Ad Server installation wizard.

5. **Complete the installation:**
   
   Follow the installation wizard with these database settings:
   - **Database Server:** `mysql`
   - **Database Name:** `revive` (or the value from your .env file)
   - **Username:** `revive` (or the value from your .env file)
   - **Password:** The password you set in your .env file

## Configuration

### Environment Variables

Edit the `.env` file to customize your installation:

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `MYSQL_ROOT_PASSWORD` | `changeme_root_password` | MySQL root password (change this!) |
| `MYSQL_DATABASE` | `revive` | Database name for Revive Ad Server |
| `MYSQL_USER` | `revive` | Database user |
| `MYSQL_PASSWORD` | `changeme_db_password` | Database password (change this!) |
| `WEB_PORT` | `8080` | Port to access the web interface |

### Custom PHP Settings

The Dockerfile includes optimized PHP settings for Revive Ad Server:
- Memory limit: 256M
- Upload max filesize: 20M
- Max execution time: 300 seconds
- OPcache enabled for better performance

## Usage

### Start Services
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f revive
docker compose logs -f mysql
```

### Restart Services
```bash
docker compose restart
```

### Remove Everything (including volumes)
```bash
docker compose down -v
```

## Data Persistence

The setup uses Docker volumes to persist data:
- `mysql-data`: MySQL database files
- `revive-data`: Revive Ad Server application files and configuration

Your data will persist even if containers are stopped or removed (unless you use `docker-compose down -v`).

## Troubleshooting

### Can't connect to database during installation
- Ensure the MySQL container is healthy: `docker compose ps`
- Check MySQL logs: `docker compose logs mysql`
- Wait a few seconds after starting for MySQL to fully initialize

### Permission issues
The Dockerfile sets proper permissions automatically. If you encounter issues:
```bash
docker compose exec revive chown -R www-data:www-data /var/www/html
docker compose exec revive chmod -R 755 /var/www/html
docker compose exec revive chmod -R 775 /var/www/html/var
```

### Port already in use
If port 8080 is already in use, change `WEB_PORT` in your `.env` file to a different port.

## Security Recommendations

For production use:
1. Change all default passwords in `.env`
2. Use strong, unique passwords
3. Consider using Docker secrets instead of environment variables
4. Set up HTTPS with a reverse proxy (e.g., Nginx, Traefik)
5. Regularly update the Docker images and Revive Ad Server

## Version Information

- **Revive Ad Server:** v6.0.5
- **PHP:** 7.4
- **MySQL:** 8.0
- **Apache:** 2.4 (included in PHP image)

## License

This Docker setup is provided as-is. Revive Ad Server is licensed under the GNU General Public License v2.0.

## Support

For issues with:
- **This Docker setup:** Open an issue in this repository
- **Revive Ad Server:** Visit [Revive Ad Server Support](https://www.revive-adserver.com/support/)

## Links

- [Revive Ad Server Official Website](https://www.revive-adserver.com/)
- [Revive Ad Server Documentation](https://documentation.revive-adserver.com/)
- [Revive Ad Server GitHub](https://github.com/revive-adserver/revive-adserver)