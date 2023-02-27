# Vorausetzungen für die Nutzung von Influxdb.


<p>InfluxDB ist eine Open-Source-Datenbank, die speziell für Zeitreihendaten optimiert ist. Zeitreihendaten sind Daten, die sich im Laufe der Zeit ändern und häufig in der Überwachung von IoT-Geräten, Sensoren und Anwendungen gesammelt werden. InfluxDB ermöglicht die Speicherung, Abfrage und Analyse von großen Mengen von Zeitreihendaten in Echtzeit.</p>

<p>Wir benutzen Influxdb in dieser Arbeit, um die Historischen Daten, des Roboters zu speichern, die an dem Thing geschickt wurden. </p>

dafür wurde der folgende Script gebaut:

```bash
#!/bin/bash

# output_file="datenbank.csv"
#utput_file="datenbank_für_vcsode.csv"

# Check if output file exists, if not create it
# if [ ! -f "$output_file" ]; then
#  echo "Time,Location,Type,Name,Manufacturer,Shoulder_Pan_Joint,Shoulder_Lift_Joint,Elbow_Joint,Wrist_1_Joint,Wrist_2_Joint,Wrist_3_Joint" > "$output_file"
# fi

while true; do
    # Make API call and parse JSON output
    response=$(curl -u ditto:ditto http://100.110.201.78:66/api/2/things/tchamabe.landry.org:my-ur5-arm)
    location=$(echo "$response" | jq -r '.attributes.location')
    TwinsID=$(echo "$response" | jq -r '.thingId')
    type=$(echo "$response" | jq -r '.attributes.type')
    name=$(echo "$response" | jq -r '.attributes.name')
    manufacturer=$(echo "$response" | jq -r '.attributes.manufacturer')
    shoulder_pan_joint=$(echo "$response" | jq -r '.features.shoulder_pan_joint.properties.value')
    shoulder_lift_joint=$(echo "$response" | jq -r '.features.shoulder_lift_joint.properties.value')
    elbow_joint=$(echo "$response" | jq -r '.features.elbow_joint.properties.value')
    wrist_1_joint=$(echo "$response" | jq -r '.features.wrist_1_joint.properties.value')
    wrist_2_joint=$(echo "$response" | jq -r '.features.wrist_2_joint.properties.value')
    wrist_3_joint=$(echo "$response" | jq -r '.features.wrist_3_joint.properties.value')

    # Check if the values have changed
    # if ! grep -q "$shoulder_pan_joint,$shoulder_lift_joint,$elbow_joint,$wrist_1_joint,$wrist_2_joint,$wrist_3_joint" "$output_file"; then
        # If the values have changed, append the new values to the output file
    # echo "$(date +'%Y-%m-%d %T'),$location,$type,$name,$manufacturer,$shoulder_pan_joint,$shoulder_lift_joint,$elbow_joint,$wrist_1_joint,$wrist_2_joint,$wrist_3_joint" >> "$output_file" 
        zeit=$(echo "$(date +'%Y-%m-%d-%T')")
    # fi

    # Sleep for a set amount of time before making the next API call
    data="Daten_twins,änderungsdatum=$zeit,host=Ditto,TwinsID=$TwinsID,location=$location,type=$type,name=$name,manufacturer=Universal_Robot shoulder_pan_joint=$shoulder_pan_joint,shoulder_lift_joint=$shoulder_lift_joint,elbow_joint=$elbow_joint,wrist_1_joint=$wrist_1_joint,wrist_2_joint=$wrist_2_joint,wrist_3_joint=$wrist_3_joint "

    curl --request POST \
    "http://100.110.201.78:8086/api/v2/write?org=steve_organisation&bucket=daten_robot_Twins&precision=s" \
    --header "Authorization: Token p4n7m89XgC3KkyWrzHD2HoKBTM4dFLdVXIGki0idPJesqIVyM0ArqZl7qPnRV9E-4UL0VDE1I5o3Wk_a2PgWnw==" \
    --header "Content-Type: text/plain; charset=utf-8" \
    --header "Accept: application/json" \
    --data-binary "$data"
        
done

```

Dieses Skript ist eine Bash-Datei, die Daten von einem bestimmten Gerät mithilfe **der Eclipse Ditto API** sammelt und sie in unsere InfluxDB-Datenbank schreibt. Es umfasst die folgenden Schritte:</br>

1. Verwendung der Ditto-API zum Abrufen von JSON-Daten ( Status des Things ) über das Gerät. 
2. Parsen der JSON-Daten, um bestimmte Datenpunkte wie Standort, Typ, Name und Gelenkwinkel zu extrahieren.
4. Formatierung der Daten als Line-Protokoll für InfluxDB, einschließlich Tags für Geräteinformationen und Felder für Gelenkwinkel.
5. Verwendung der InfluxDB-API zum Schreiben der Daten in eine angegebene Datenbank.
6. Warten einer bestimmten Zeit, bevor der nächste API-Aufruf erfolgt.

Der Skript ist auch hier ---> [datenbank.sh](../Influxdb/datenbank.sh) verfügbar. </br>

- **Hinweis:** Dieser Skript funktioniert nur wenn alle Shritte in die Datei [ Voraussetzungen für die Nützung von Eclipse Ditto ](../Vorausetzungen/Ditto_Vorausetzungen/README.md) duchgeführt wurden und Influxdb instaliert ist. die ausführliche Schritte zur Installation findet man hier ---> [ influxDB ](https://docs.influxdata.com/influxdb/v2.6/install/).  </br>

um den Skript auszufuhren:

```bash
chmod +x /path/von/datenbank.sh
./path/von/datenbank.sh
```

## Ergebnis

so sehen die Daten in der Datenbank aus: </br></br>
![](../Fotos/data_influxdb.png)