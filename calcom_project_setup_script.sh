#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="/root/.nvm"
source "$NVM_DIR/nvm.sh"

npm install web-push@3.6.7 --no-save

git config --global --add safe.directory /calcom
cp -n .env.example .env
cp -n apps/api/v2/.env.example apps/api/v2/.env

grep -qxF 'REDIS_URL="redis://redis:6379"' .env || echo 'REDIS_URL="redis://redis:6379"' >> .env

# GENERATE VAPID KEYS
output=$(yes | npx web-push generate-vapid-keys)
vapid_public_key=$(echo "$output" | awk '/Public Key:/ {getline; print}')
vapid_private_key=$(echo "$output" | awk '/Private Key:/ {getline; print}')

# GENERATE SECRETE KEYS
nextauth_secret=$(openssl rand -base64 32)
calendso_encryption_key=$(openssl rand -base64 32)
cal_video_recording_token_secret=$(openssl rand -base64 32)
calcom_service_account_encryption_key=$(openssl rand -base64 32)


FILE=".env"
sed -i 's|DATABASE_URL=.*|DATABASE_URL="postgresql://root:root@postgres:5432/postgres"|' "$FILE"
sed -i 's|DATABASE_DIRECT_URL=.*|DATABASE_DIRECT_URL="postgresql://root:root@postgres:5432/postgres"|' "$FILE"
sed -i 's|NEXT_PUBLIC_API_V2_URL=.*|NEXT_PUBLIC_API_V2_URL="http://localhost:3002/"|' "$FILE"
sed -i 's|NEXT_PUBLIC_IS_E2E=.*|NEXT_PUBLIC_IS_E2E="1"|' "$FILE"
sed -i 's|CALCOM_LICENSE_KEY=.*|CALCOM_LICENSE_KEY="1a1f8138-0bfc-4f37-b4af-1e24fd145839"|' "$FILE"
sed -i "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$nextauth_secret\"|" "$FILE"
sed -i "s|CALENDSO_ENCRYPTION_KEY=.*|CALENDSO_ENCRYPTION_KEY=\"$calendso_encryption_key\"|" "$FILE"
sed -i "s|NEXT_PUBLIC_VAPID_PUBLIC_KEY=.*|NEXT_PUBLIC_VAPID_PUBLIC_KEY=\"$vapid_public_key\"|" "$FILE"
sed -i "s|VAPID_PRIVATE_KEY=.*|VAPID_PRIVATE_KEY=\"$vapid_private_key\"|" "$FILE"
sed -i "s|CAL_VIDEO_RECORDING_TOKEN_SECRET=.*|CAL_VIDEO_RECORDING_TOKEN_SECRET=\"$cal_video_recording_token_secret\"|" "$FILE"
sed -i "s|CALCOM_SERVICE_ACCOUNT_ENCRYPTION_KEY=.*|CALCOM_SERVICE_ACCOUNT_ENCRYPTION_KEY=\"$calcom_service_account_encryption_key\"|" "$FILE"


FILE="apps/api/v2/.env"

sed -i 's|NODE_ENV=.*|NODE_ENV="development"|' "$FILE"
sed -i 's|API_PORT=.*|API_PORT="3003"|' "$FILE"
sed -i 's|API_URL=.*|API_URL="http://localhost:3003/"|' "$FILE"
sed -i 's|DATABASE_READ_URL=.*|DATABASE_READ_URL="postgresql://root:root@postgres:5432/postgres"|' "$FILE"
sed -i 's|DATABASE_WRITE_URL=.*|DATABASE_WRITE_URL="postgresql://root:root@postgres:5432/postgres"|' "$FILE"
sed -i 's|LOG_LEVEL=.*|LOG_LEVEL="1"|' "$FILE"
sed -i "s|NEXTAUTH_SECRET=.*|NEXTAUTH_SECRET=\"$nextauth_secret\"|" "$FILE"
sed -i 's|DATABASE_URL=.*|DATABASE_URL="postgresql://root:root@postgres:5432/postgres"|' "$FILE"
sed -i 's|CALCOM_LICENSE_KEY=.*|CALCOM_LICENSE_KEY="1a1f8138-0bfc-4f37-b4af-1e24fd145839"|' "$FILE"


cat <<EOF > apps/api/v2/docker-compose.yaml
version: "2.2"

services:
  redis:
    image: redis:8.0.3-bookworm
    container_name: calcom_redis
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

volumes:
  redis_data:

networks:
  default:
    name: calcom_net
EOF

cat <<EOF > packages/emails/docker-compose.yml
version: '2.2'
# Starts mailhog SMTP server on port 1025, web interface on port 8025
services:
  mailhog:
    image: "mailhog/mailhog:latest"
    container_name: calcom_mailhog
    ports:
      - "1025:1025"
      - "8025:8025"

networks:
  default:
    name: calcom_net
EOF

cat <<EOF > packages/prisma/docker-compose.yml
version: "2.2"
# this file is a helper to run Cal.com locally
services:
  postgres:
    image: postgres:16.9-bullseye
    container_name: calcom_postgres
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: "root"
      POSTGRES_USER: "root"
      POSTGRES_DB: "postgres"
      POSTGRES_HOST_AUTH_METHOD: trust

  pgadmin4:
    image: dpage/pgadmin4:9.4.0
    container_name: calcom_pgadmin
    depends_on:
    - "postgres"
    environment:
      PGADMIN_DEFAULT_EMAIL: "root@mailinator.com"
      PGADMIN_DEFAULT_PASSWORD: "root"
      GLOBALLY_DELIVERABLE: "True"
    ports:
      - "8083:80"

volumes:
  db_data:

networks:
  default:
    name: calcom_net
EOF

cat <<EOF > docker-compose.dev.yml
version: "2.2"

services:
  calcom:
    image: node:20-bullseye
    container_name: calcom_app
    working_dir: /calcom
    volumes:
      - /absolute/path/to/cal.com:/calcom # UPDATE FOLDER PATH
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "3000:3000"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    tty: true
    stdin_open: true
    command: >
      bash -c '
        set -ex;
        apt update && apt upgrade -y
        apt install -y docker.io docker-compose vim iputils-ping git
        git config --global --add safe.directory /calcom

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        rm -rf /tmp/turbod/* && rm -rf .turbo
        export NVM_DIR="/root/.nvm"
        [ -s "/root/.nvm/nvm.sh" ] && . "/root/.nvm/nvm.sh"
        nvm install 

        yarn config set --home enableTelemetry 0
        yarn up eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-next sharp
        
        echo "---------------------Setting Up Dev Environment--------------------"
        yarn dx
      '

networks:
  default:
    name: calcom_net
EOF

cat <<EOF > apps/api/v2/docker-compose-apiv2.yaml
version: "2.2"

services:
  calcom_api:
    image: node:20-bullseye
    container_name: calcom_api
    working_dir: /calcom_api_v2
    volumes:
      - /absolute/path/to/cal.com:/calcom_api_v2 # UPDATE FOLDER PATH
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "3002:3002"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    tty: true
    stdin_open: true
    environment:
      NODE_OPTIONS: "--max-old-space-size=16384"
      API_PORT: "3002"
    command: >
      bash -c '
        set -ex;
        apt update && apt upgrade -y
        apt install -y docker.io docker-compose vim iputils-ping git
        git config --global --add safe.directory /calcom_api_v2

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        rm -rf /tmp/turbod/* && rm -rf .turbo
        export NVM_DIR="/root/.nvm"
        [ -s "/root/.nvm/nvm.sh" ] && . "/root/.nvm/nvm.sh"
        nvm install 

        rm -rf apps/api/v2/node_modules
        yarn config set --home enableTelemetry 0
        yarn install
        
        echo "---------------------Setting Up API--------------------"
        # chrome://inspect/#devices
        # Debugger listening on ws://127.0.0.1:9229/
        # For help, see: https://nodejs.org/en/docs/inspector

        yarn workspace @calcom/api-v2 run generate-schemas
        yarn workspace @calcom/api-v2 run build
        yarn workspace @calcom/api-v2 start
      '

networks:
  default:
    name: calcom_net

EOF

cat <<EOF > docker-compose.prod.yml
version: "2.2"

services:
  calcom:
    image: node:20-bullseye
    container_name: calcom_app
    working_dir: /calcom
    volumes:
      - /absolute/path/to/cal.com:/calcom # UPDATE FOLDER PATH
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "3000:3000"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    tty: true
    stdin_open: true
    command: >
      bash -c '
        set -ex;
        apt update && apt upgrade -y
        apt install -y docker.io docker-compose vim iputils-ping git
        git config --global --add safe.directory /calcom

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        rm -rf /tmp/turbod/* && rm -rf .turbo
        export NVM_DIR="/root/.nvm"
        [ -s "/root/.nvm/nvm.sh" ] && . "/root/.nvm/nvm.sh"
        nvm install 

        yarn config set --home enableTelemetry 0
        yarn up eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-next sharp
        
        echo "---------------------Setting Up Prod Environment--------------------"
        docker-compose -f packages/prisma/docker-compose.yml up --build -d
        docker-compose -f packages/emails/docker-compose.yml up --build -d
        docker-compose -f apps/api/v2/docker-compose.yaml up --build -d
        docker-compose -f apps/api/v2/docker-compose-apiv2.yaml up --build -d
        NODE_OPTIONS="--max-old-space-size=16384" yarn build
        yarn start
      '

networks:
  default:
    name: calcom_net

EOF
