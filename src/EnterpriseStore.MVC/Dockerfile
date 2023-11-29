#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["src/EnterpriseStore.MVC/EnterpriseStore.MVC.csproj", "src/EnterpriseStore.MVC/"]
COPY ["src/EnterpriseStore.Data/EnterpriseStore.Data.csproj", "src/EnterpriseStore.Data/"]
COPY ["src/EnterpriseStore.Service/EnterpriseStore.Service.csproj", "src/EnterpriseStore.Service/"]
COPY ["src/EnterpriseStore.Domain/EnterpriseStore.Domain.csproj", "src/EnterpriseStore.Domain/"]
RUN dotnet restore "src/EnterpriseStore.MVC/EnterpriseStore.MVC.csproj"
COPY . .
WORKDIR "/src/src/EnterpriseStore.MVC"
RUN dotnet build "EnterpriseStore.MVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EnterpriseStore.MVC.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EnterpriseStore.MVC.dll"]