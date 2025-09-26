# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# Add non-root user
RUN useradd -m appuser
USER appuser

WORKDIR /app
EXPOSE 8080
EXPOSE 8081

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

# Create persistent data folder
RUN mkdir -p /app/data

# Ensure appuser owns data folder
RUN chown -R appuser:appuser /app/data

# Make it a Docker volume
VOLUME ["/app/data"]

# Run the DLL as non-root user
ENTRYPOINT ["dotnet", "local-gpss.dll"]
