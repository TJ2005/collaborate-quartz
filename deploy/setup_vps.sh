#!/usr/bin/env bash
set -euo pipefail

# setup_vps.sh
# Run as root on the VPS to install Node.js 22, git, nginx, clone this repo,
# install dependencies, build the static site, and configure nginx to serve it.

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use: sudo bash setup_vps.sh"
  exit 1
fi

REPO_URL="https://github.com/TJ2005/collaborate-quartz.git"
INSTALL_DIR="/opt/collaborate-quartz"
APP_USER="collab"
NODE_SETUP_SCRIPT_URL="https://deb.nodesource.com/setup_22.x"

echo "Updating apt and installing prerequisites..."
apt-get update -y
apt-get install -y curl git nginx build-essential ca-certificates

echo "Installing Node.js 22 via NodeSource..."
curl -fsSL ${NODE_SETUP_SCRIPT_URL} | bash -
apt-get install -y nodejs

echo "Creating application user '${APP_USER}' (if missing)..."
id -u ${APP_USER} >/dev/null 2>&1 || useradd -m -s /bin/bash ${APP_USER}

echo "Ensuring install directory exists and is owned by ${APP_USER}..."
mkdir -p ${INSTALL_DIR}
chown ${APP_USER}:${APP_USER} ${INSTALL_DIR}

echo "Cloning or updating repository into ${INSTALL_DIR}..."
if [ -d "${INSTALL_DIR}/.git" ]; then
  runuser -l ${APP_USER} -c "cd ${INSTALL_DIR} && git pull --ff-only || true"
else
  runuser -l ${APP_USER} -c "git clone ${REPO_URL} ${INSTALL_DIR}"
fi

echo "Installing npm dependencies (as ${APP_USER})..."
runuser -l ${APP_USER} -c "cd ${INSTALL_DIR} && npm install --no-audit --no-fund"

echo "Building site (one-time build)..."
runuser -l ${APP_USER} -c "cd ${INSTALL_DIR} && npx quartz build"

PUBLIC_DIR="${INSTALL_DIR}/public"

if [ ! -d "${PUBLIC_DIR}" ]; then
  echo "Warning: build did not create ${PUBLIC_DIR}. Check build logs and ensure 'npx quartz build' succeeded." >&2
fi

echo "Configuring nginx to serve the site from ${PUBLIC_DIR}..."
NGINX_SITE_CONF="/etc/nginx/sites-available/collaborate-quartz"
cat > "${NGINX_SITE_CONF}" <<'EOF'
server {
    listen 80;
    server_name _;
    root /opt/collaborate-quartz/public;
    index index.html;

    # Try files without .html extension first, then with .html
    location / {
        try_files $uri $uri.html $uri/ =404;
    }

    # Optional: serve common static files with aggressive caching
    location ~* \.(?:css|js|jpg|jpeg|gif|png|svg|ico|woff2?)$ {
        expires 30d;
        add_header Cache-Control "public";
    }

    # Custom 404 page
    error_page 404 /404.html;
}
EOF

ln -sf "${NGINX_SITE_CONF}" /etc/nginx/sites-enabled/collaborate-quartz
if [ -f /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

nginx -t
systemctl restart nginx

echo "Firewall (ufw) - allow http (80) if ufw exists and is enabled..."
if command -v ufw >/dev/null 2>&1; then
  if ufw status | grep -q "Status: active"; then
    ufw allow 80/tcp
  fi
fi

cat <<EOF

Setup complete.
- Repository: ${REPO_URL}
- Installed to: ${INSTALL_DIR}
- Built site output: ${PUBLIC_DIR}
- nginx site config: ${NGINX_SITE_CONF}

Next steps:
- If your content is in a separate repo, add it into ${INSTALL_DIR}/content (or symlink it there), then re-run as ${APP_USER}:
    cd ${INSTALL_DIR} && npx quartz build
- To enable HTTPS, install a certificate (Certbot) or point a reverse proxy/Cloudflare in front of this droplet.

If you want automatic rebuilds on git pushes, consider configuring a GitHub Action that runs `npx quartz build` and pushes `public/` to a deployment location, or set up a webhook + small receiver to pull and rebuild.

EOF
