# Use .NET 9 runtime for final image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Use .NET 9 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Install git to clone the repo
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone the official Local GPSS repo
RUN git clone --branch master https://github.com/FlagBrew/local-gpss.git .

# Restore and build the project
RUN dotnet restore "local-gpss.csproj"
RUN dotnet build "local-gpss.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish the project
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "local-gpss.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
# Optional: create a persistent data folder
RUN mkdir -p /app/data
VOLUME ["/app/data"]

# Run the DLL
ENTRYPOINT ["dotnet", "local-gpss.dll"]
