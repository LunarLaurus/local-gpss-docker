# local-gpss-docker

Minimal Docker + Compose for FlagBrew Local-GPSS.

- Builds the latest `linux64.zip` at image build time.
- Runs server at `0.0.0.0:13579`.
- Persists DB/config to a Docker named volume `local-gpss-data`.
- No host-side configuration required.

## Portainer usage
1. Create a new Stack → **Add stack** → choose **Git repository**.
2. Point it to this repo URL and set the compose path to `./docker-compose.yml`.
3. Deploy the stack. Portainer will build the image from the included `Dockerfile`.

## Manual CLI (optional)
```bash
docker compose build
docker compose up -d
```

## Update
To update Local-GPSS binary Rebuild the image (Portainer can rebuild the stack or you can run docker compose build && docker compose up -d), which re-downloads the latest release at build time.