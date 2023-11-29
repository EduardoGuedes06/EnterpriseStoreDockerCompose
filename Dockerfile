FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
RUN dotnet --info
COPY ["src/EnterpriseStore.MVC/EnterpriseStore.MVC.csproj", "EnterpriseStore.MVC/"]
COPY ["src/EnterpriseStore.Data/EnterpriseStore.Data.csproj", "EnterpriseStore.Data/"]
COPY ["src/EnterpriseStore.Service/EnterpriseStore.Service.csproj", "EnterpriseStore.Service/"]
COPY ["src/EnterpriseStore.Domain/EnterpriseStore.Domain.csproj", "EnterpriseStore.Domain/"]
RUN dotnet restore "EnterpriseStore.MVC/EnterpriseStore.MVC.csproj"
WORKDIR "/src/EnterpriseStore.MVC"
COPY . .
RUN dotnet build "EnterpriseStore.MVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EnterpriseStore.MVC.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EnterpriseStore.MVC.dll"]
