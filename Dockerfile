# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 13579

# Create non-root user (UID 1000)
RUN useradd -m -u 1000 appuser

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Install git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone repo
RUN git clone --branch master https://github.com/FlagBrew/local-gpss.git .

# Restore and build
RUN dotnet restore "local-gpss.csproj"
RUN dotnet build "local-gpss.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "local-gpss.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final image
FROM base AS final
WORKDIR /app

# Copy published files from build
COPY --from=publish /app/publish .


# Copy entrypoint script and make it executable (as root)
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
RUN chown -R 1000:1000 /app

# Switch to non-root user
USER appuser

# Make the folder a Docker volume so data persists
VOLUME ["/app"]

# Run the DLL
ENTRYPOINT ["/app/entrypoint.sh"]