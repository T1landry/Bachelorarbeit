# Voraustzungen für die Nutzung von Eclipse Hono.

1. **Curl befehlezeile Client**

```sql
sudo apt-get update
sudo apt-get install curl

# Danach kann man die Installation Überprüfen

curl --version
```
2. **Java >=17 installieren**

```sql
sudo add-apt-repository ppa:linuxuprising/java
sudo apt-get update
sudo apt-get install oracle-java17-installer
```

3. Hono-Befehlszeilenclient. (um später die Anwendung zu starten.)

Die Honobefehlszeileclient kann hier --> [hono-cli-*-exec.jar](https://www.eclipse.org/hono/downloads/) heruntergeladen werden.
fuer diese Arbeit wurde  **hono-cli-2.2.0-exec.jar aus der java archive**  heruntergeladen.

4. **Minikube**

Minikube ist die Alternative, die in dieser Arbeit benutzt wird um Eclipse Hono auszuführen.</br>
alle Schritte und Voraussetzungen sind hier --> [minikube](https://minikube.sigs.k8s.io/docs/start/) dokumentiert.</br> 

5. **Helm installieren**

```sql
curl -LO https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz
tar -zxvf helm-v3.7.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version
```

6. **eine Hono-Instanz** 

Der nachste Shritt besteht darin, die Hono-instanz,bereitzustellen, mit der man arbeiten kann.</br>
wir haben für diese Arbeit eine lokale hono-Instanz eingerichtet. es wurde als Messaging-Infrastruktur AMQP 1.0-basierten Infrastruktur gewählt.</br> 

```bash
kubectl  create namespace hono              #der Zielnamespace 

helm repo add eclipse-iot https://iot.eclipse.org/helm-repo/charts      #wir fügen erst das helm repo der eclipse-IoT hinzu
helm repo update

#jetzt starten wir die Service von eclipse-hono

helm install eclipse-hono eclipse-iot/hono -n hono --wait --set messagingNetworkTypes[0]=amqp --set kafkaMessagingClusterExample.enabled=false --set amqpMessagingNetworkExample.enabled=true --set prometheus.createInstance=true --set grafana.enabled=true
```

## Ergebniss Präsentation.

Werden alle punkte oben durchgeführt, werden die folgenden Services gestartet:

```sql
kubectl get services -n hono

NAME                                            TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
eclipse-hono-adapter-amqp                       LoadBalancer   10.97.211.161    <pending>     5672:30890/TCP,5671:30332/TCP     17d
eclipse-hono-adapter-http                       LoadBalancer   10.96.167.103    <pending>     8080:31312/TCP,8443:32466/TCP     17d
eclipse-hono-adapter-mqtt                       LoadBalancer   10.99.182.90     <pending>     1883:30364/TCP,8883:31911/TCP     17d
eclipse-hono-artemis                            ClusterIP      10.100.15.86     <none>        5671/TCP                          17d
eclipse-hono-dispatch-router                    ClusterIP      10.104.7.66      <none>        5673/TCP                          17d
eclipse-hono-dispatch-router-ext                LoadBalancer   10.98.145.19     <pending>     15671:30517/TCP,15672:32510/TCP   17d
eclipse-hono-grafana                            ClusterIP      10.111.77.68     <none>        3000/TCP                          17d
eclipse-hono-prometheus-server                  ClusterIP      10.109.35.18     <none>        9090/TCP                          17d
eclipse-hono-service-auth                       ClusterIP      10.99.186.71     <none>        5671/TCP,8088/TCP                 17d
eclipse-hono-service-command-router             ClusterIP      10.102.79.237    <none>        5671/TCP                          17d
eclipse-hono-service-device-registry            ClusterIP      10.109.233.179   <none>        5671/TCP,8080/TCP,8443/TCP        17d
eclipse-hono-service-device-registry-ext        LoadBalancer   10.102.191.48    <pending>     28080:31148/TCP,28443:32027/TCP   17d
eclipse-hono-service-device-registry-headless   ClusterIP      None             <none>        <none>                            17d

```

- **Hinveiß**:

1. wir haben hier: 

    1. **eine Hono-Instanz** (Eine HTTP-Adapterinstanz, Eine MQTT-Adapterinstanz, Eine AMQP-Adapterinstanz, Eine Command Router-Instanz, Eine Geräteregistrierungsinstanz, Eine Auth-Server- Instanz).
    2. **AMQP-Netzwerk** (eine Dispach Router-Instanz, eine Artemis-Instanz).
    3. **service für die Überwachung der Infrastruktur** (eine Promoteus-Instanz, eine Grafana-Instanz). siehe dazu den Ordner --> [Monitoring](Monitoring/)

2. wir expotieren die Services in unseren Fall mit Nodeport, aber es gibt auch die Möglichkeit mit Loadbalancer zu zu expotieren. dafur startet man einfach in einem anderen Terminal den Befehl `minikube tunnel`. das Ergebenis wurde dann so aussehen:

```sql
kubectl get services -n hono

NAME                                            TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                           AGE
eclipse-hono-adapter-amqp                       LoadBalancer   10.97.211.161    10.97.211.161   5672:30890/TCP,5671:30332/TCP     17d
eclipse-hono-adapter-http                       LoadBalancer   10.96.167.103    10.96.167.103   8080:31312/TCP,8443:32466/TCP     17d
eclipse-hono-adapter-mqtt                       LoadBalancer   10.99.182.90     10.99.182.90    1883:30364/TCP,8883:31911/TCP     17d
eclipse-hono-artemis                            ClusterIP      10.100.15.86     <none>          5671/TCP                          17d
eclipse-hono-dispatch-router                    ClusterIP      10.104.7.66      <none>          5673/TCP                          17d
eclipse-hono-dispatch-router-ext                LoadBalancer   10.98.145.19     10.98.145.19    15671:30517/TCP,15672:32510/TCP   17d
eclipse-hono-grafana                            ClusterIP      10.111.77.68     <none>          3000/TCP                          17d
eclipse-hono-prometheus-server                  ClusterIP      10.109.35.18     <none>          9090/TCP                          17d
eclipse-hono-service-auth                       ClusterIP      10.99.186.71     <none>          5671/TCP,8088/TCP                 17d
eclipse-hono-service-command-router             ClusterIP      10.102.79.237    <none>          5671/TCP                          17d
eclipse-hono-service-device-registry            ClusterIP      10.109.233.179   <none>          5671/TCP,8080/TCP,8443/TCP        17d
eclipse-hono-service-device-registry-ext        LoadBalancer   10.102.191.48    10.102.191.48   28080:31148/TCP,28443:32027/TCP   17d
eclipse-hono-service-device-registry-headless   ClusterIP      None             <none>          <none>                            17d

```

## Environement Variabale herausfinden.

1. Exportieren mit NodePort

mit dem Befehl `minikube service --all -n hono` erhaltet man die IP adresse(die IP von Minikube) und der port, mit dem man die Services auch außer minikube erreichen kann.(***besonders wichtig um die Verbindung zwischen hono und Ditto zu ermöglichen***).

so sieht unsere environement variable:
```sql
export REGISTRY_IP=100.120.169.61
export HTTP_ADAPTER_IP=100.120.169.61
export MQTT_ADAPTER_IP=100.120.169.61
export AMQP_NETWORK_IP=100.120.169.61
export APP_OPTIONS='--amqp -H 100.120.169.61 -P 32510 -u consumer@HONO -p verysecret'
```
diese findet man auch in die Datei [envi.env](../../Buffer/envi.env).

2. Mit Loabalencer exportieren

mit den Befehlen extrahiert man die umgebungsvariable:
```bash
echo "export REGISTRY_IP=$(kubectl get service eclipse-hono-service-device-registry-ext --output="jsonpath={.status.loadBalancer.ingress[0]['hostname','ip']}" -n hono)" > hono.env
echo "export HTTP_ADAPTER_IP=$(kubectl get service eclipse-hono-adapter-http --output="jsonpath={.status.loadBalancer.ingress[0]['hostname','ip']}" -n hono)" >> hono.env
echo "export MQTT_ADAPTER_IP=$(kubectl get service eclipse-hono-adapter-mqtt --output="jsonpath={.status.loadBalancer.ingress[0]['hostname','ip']}" -n hono)" >> hono.env
AMQP_NETWORK_IP=$(kubectl get service eclipse-hono-dispatch-router-ext --output="jsonpath={.status.loadBalancer.ingress[0]['hostname','ip']}" -n hono)
echo "export APP_OPTIONS='--amqp -H ${AMQP_NETWORK_IP} -P 15672 -u consumer@HONO -p verysecret'" >> hono.env
```

# Nächter Schritt:

die [Voraussetzungen für die Nützung von Ditto](../Ditto_Vorausetzungen/), und die [Voraussetzungen für die Nützung der Roboter-Simmulation](../Roboter_Voraussetzungen/) **müssen** erst duchgeführt werden bevor man wieder die Schritte in [README.md](../../README.md) weiterführen kann. 
