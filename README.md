# README for Local-GPSS

## Overview  
Runs Local-GPSS via docker~

## Key Features  
 
- **Local Hosting**: Run your own GPSS server within your local network.  
- **Legality Checks**: Automatically checks Pokémon legality using PKHeX's legality engine.  
- **Auto Legality**: Automatically legalizes Pokémon using PKHeX's Auto Legality feature.  
- **Data Persistence**: Pokémon data persists across container restarts using Docker volumes.  
- **Non-Root User**: Runs as a non-root user for security.  

## Setup Guide   
1. Clone this repository:  

   ```bash
   git clone https://github.com/FlagBrew/local-gpss.git
   ```

2. Ensure your docker-compose.yml and Dockerfile are in the project root.  

3. Start the service:  

   ```bash
   docker-compose up -d  
   ```

4. Verify the container is running:  

   ```bash
   docker ps  
   ```

## Configuration  
The service automatically writes its configuration to /app/local-gpss.json with the container's IP and port.  

## Data Persistence  
Data is stored in the Docker volume `local-gpss-data`, mapped to /app inside the container. 
This ensures your data persists across container restarts.  

## Docker Compose Overview  
services:  
  local-gpss:  
    build: .  
    image: local-gpss:latest  
    container_name: local-gpss  
    restart: always  
    ports:  
      - "13579:13579"  
    volumes:  
      - local-gpss-data:/app  

volumes:  
  local-gpss-data: {}  

## Dockerfile Overview  
- Base image: mcr.microsoft.com/dotnet/aspnet:9.0  
- SDK image: mcr.microsoft.com/dotnet/sdk:9.0 for building  
- Creates non-root user (UID 1000) `appuser`  
- Installs git, restores, builds, and publishes the .NET app  
- Copies entrypoint.sh, makes it executable, and sets ownership  
- Runs the app using entrypoint.sh as `appuser`  

## Entrypoint Script (entrypoint.sh)  
- Retrieves container's primary IP  
- Writes /app/local-gpss.json with IP and port 13579  
- Launches dotnet application  

## Usage  
After starting with docker-compose, the service will be accessible at `http://<container-ip>:13579` within your Docker network or `http://localhost:13579` on the host.  

### Stopping the service:  
  docker-compose down  

### Logs:  
  docker-compose logs -f local-gpss  

That's it! 
Your Local-GPSS service should now be running securely and persistently.  
