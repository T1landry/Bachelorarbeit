# Vorausetzungen für die Nutzung von Eclipse Ditto.

1. Docker Instalieren

- **hinweiß** :nur fals die Voraussetzungen in Hono noch nicht durchgefuhrt wurden (bei der Instalation von Minikube werden schon docker Erstellt.).

```sql
sudo apt install docker.io
sudo service docker start
sudo usermod -a -G docker <your-username>
```

2. Installation von der Docker-compose

```sql
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

3. Ditto Klonen.

```bash
git clone --depth 1 https://github.com/eclipse-ditto/ditto.git
```

4. Ditto Starten und den Port fuer die API-Interfaces festlegen:

```bash
cd ditto/deployment/docker/
export DITTO_EXTERNAL_PORT=66
docker-compose up -d
```

## Ergebnis vorstellen.

```bash
cd ditto/deployement/docker/
docker-compose ps
```
Das Egebnis sieht folgendermaßend aus:

```bash
docker-compose ps

         Name                       Command                  State                          Ports                    
---------------------------------------------------------------------------------------------------------------------
docker_connectivity_1    /usr/bin/tini -- sh -c exe ...   Up (healthy)   8080/tcp                                    
docker_gateway_1         /usr/bin/tini -- sh -c exe ...   Up (healthy)   0.0.0.0:8081->8080/tcp,:::8081->8080/tcp    
docker_mongodb_1         docker-entrypoint.sh mongo ...   Up             0.0.0.0:27017->27017/tcp,:::27017->27017/tcp
docker_nginx_1           /docker-entrypoint.sh ngin ...   Up             0.0.0.0:66->80/tcp,:::66->80/tcp            
docker_policies_1        /usr/bin/tini -- sh -c exe ...   Up (healthy)   8080/tcp                                    
docker_swagger-ui_1      /docker-entrypoint.sh ngin ...   Up             80/tcp, 8080/tcp                            
docker_things-search_1   /usr/bin/tini -- sh -c exe ...   Up (healthy)   8080/tcp                                    
docker_things_1          /usr/bin/tini -- sh -c exe ...   Up (healthy)   8080/tcp                                    
```

# Nächster Schritt.

die [Voraussetzungen für die Nützung der Roboter-Simulation](../Roboter_Voraussetzungen/), und die [Voraussetzungen für die Nützung von Hono](../Hono_Vorausetungen/README.md) **müssen** erst duchgeführt werden bevor man wieder die Schritte in [README.md](../../README.md) weiterführen kann.