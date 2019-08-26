FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["dotnetconnector.csproj", "./"]
RUN dotnet restore "./dotnetconnector.csproj"
COPY . .
WORKDIR /src/.
RUN dotnet build "dotnetconnector.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "dotnetconnector.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dotnetconnector.dll"]
