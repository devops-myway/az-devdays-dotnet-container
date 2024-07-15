FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY "src/" .
RUN dotnet restore "DotNet8ApplicationSample/DotNet8ApplicationSample.csproj"
COPY . .
WORKDIR "/src/DotNet8ApplicationSample"
RUN dotnet build "DotNet8ApplicationSample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNet8ApplicationSample.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNet8ApplicationSample.dll"]