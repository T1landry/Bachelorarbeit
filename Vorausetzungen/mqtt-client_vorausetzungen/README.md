# Erläuterung der C++ Funktion für die Verbindung zwischen den Roboter und Hono.

- **Hinweis**: Damit das programme fonctioniert muss einiges angepasst werden, aber wichtig ist es, dass [die Voraussentzungen für die Nützung des Roboters](../Roboter_Voraussetzungen/README.md) erfüllt werden.

1. Eklärung des Codes.

Der gesammte Code sieht dann so aus(auch vorhanden in die datei [mqtt_verbindung_hono.cpp](mqtt_verbindung_hono.cpp)):

```c++
#include <iostream>
#include <jsoncpp/json/json.h>			// jsoncpp bibliothek
#include <fstream>
#include <cstdlib>
#include "mqtt/client.h"
#include <sstream>
#include <memory>
#include <chrono>
#include <thread>
#include "mqtt/async_client.h"			// C++ Mqtt paho bibliothek
#include <jsoncpp/json/writer.h>		// jsoncpp bibliothek


const int PUBLISH_FREQUENCY = 10;
const int WAIT_TIME = 3;
std::string prev_payload;

using namespace std;

void publish_callback(const mqtt::delivery_token& tok) {
    std::cout << "Message published." << std::endl;
}

int main() {
    	//einstellungen der mqtt-hono-adapetr
		string host = "tcp://100.120.169.61:30364";
    	string CliendId = "tchamabethesisID@tchamabe.landry.org";
    	string username = "tchamabethesisID@tchamabe.landry.org";
    	string Password = "tchamabelandry6.";
    	string topic = "telemetry";
    	//Mqtt-Client erstellen

    	mqtt::async_client client(host, username, Password);

		bool continueRunning = true;
	
    	//verbindungseinstellungen festlegen

    	mqtt::connect_options connOpts;
    	connOpts.set_keep_alive_interval(20);
    	connOpts.set_clean_session(true);
    	connOpts.set_user_name(username);
    	connOpts.set_password(Password);
	
    	// verbindung herstellen 
    	cout << "verbindung zu den hono wird hergestellt..." << endl;
    	client.connect(connOpts)->wait();
    	cout << "Connected." << endl;

    	// nachrichten herstellen.
    	Json::Value json_msg;
		std::string file_string;
		std::string json_data;
		std::stringstream ss_file;
		Json::Value json_data1;
		Json::Value json_list(Json::arrayValue);
		double value1;
		double value[6];

	while (continueRunning){
		ifstream file("/home/steve-tchamabe/catkin_ws/src/value.txt");
		
		if(file.good()){
			for(int i = 0; i < 6; i++){
			file >> file_string;
			value[i] = std::stod(file_string);	//um den string in double zu convertieren 
			}
			file.close();
		

		std::stringstream ss_file(file_string);

		
    	for (int i = 0; i < json_data1.size(); i++) {
        	json_list.append(json_data1[i]);
    	}	
		json_msg["shoulder_pan_joint_position_controller"] = value[0];
		json_msg["shoulder_lift_joint_position_controller"] = value[1];
			json_msg["elbow_joint_position_controller"] = value[2];
		json_msg["wrist_1_joint_position_controller"] = value[3];
		json_msg["wrist_2_joint_position_controller"] = value[4];
			json_msg["wrist_3_joint_position_controller"] = value[5];
    	//Nachrichten publizieren
		json_data = json_msg.toStyledString();
			if (json_data != prev_payload) {

				auto pubmsg = mqtt::make_message(topic, json_data);
				pubmsg->set_qos(1);
				client.publish(pubmsg);

				prev_payload = json_data;
			}

		}
		else{
			cout << "Die Datei ist leer, es wird also nicht publiziert." << endl;
		}
	}
	cout << "verbindung zu hono wird abgebrochen..." << endl;
	//client.disconnect()->wait();
	cout << "beendet." << endl;
	
	return 0;

}
```
</br>
<p>Dies ist ein C++-Programm, das eine Verbindung zu einem MQTT-Broker(in unserem Fall **der Mqtt-adapter von Hono**) herstellt und eine JSON-Nachricht an ein bestimmtes Topic veröffentlicht. Das Programm liest Daten aus einer Datei mit dem Namen **value.txt** und erstellt eine JSON-Nachricht mit den Daten. Anschließend wird die Nachricht mit dem MQTT-Client auf das Thema "telemetry" veröffentlicht.</p>
<p>Das Programm definiert zunächst die MQTT-Verbindungseinstellungen, einschließlich des Hostnamens, der Client-ID, des Benutzernamens, des Passworts und des Topics. Es erstellt dann einen asynchronen MQTT-Client mit diesen Einstellungen und verbindet sich mit dem Broker.</p>
<p>Das Programm liest Daten aus der Datei "value.txt" mithilfe eines ifstream-Objekts und konvertiert die Daten von String in Double. Anschließend erstellt es eine JSON-Nachricht mit den Daten und veröffentlicht sie über den MQTT-Client an den Broker. Das Programm verwendet die Funktion **toStyledString**, um die JSON-Nachricht in einen String umzuwandeln, bevor sie veröffentlicht wird.</p>
<p>Das Programm verwendet eine while-Schleife, um kontinuierlich Daten aus der Datei zu lesen und sie an den Broker zu senden. Die Schleife läuft, bis das Programm manuell gestoppt wird.</p>
<p>Das Programm verwendet die Paho C++ MQTT-Bibliothek, um eine Verbindung zum MQTT-Broker herzustellen und Nachrichten zu veröffentlichen. Es verwendet auch die JsonCpp-Bibliothek, um JSON-Objekte zu erstellen und zu manipulieren.</p>

Um mehr über Eclipse Paho c++ Mqtt-Client zu erfahren ---> [PAHO_C++](https://github.com/eclipse/paho.mqtt.cpp).

2. Befehl um das Programm auszuführen.

```bash
g++ -o steve mqtt_verbindung_hono.cpp -L/usr/local/lib -I/usr/local/include -lpaho-mqttpp3 -lpaho-mqtt3c -ljsoncpp
```
die mqttpaho Bibliothek und die Jsoncpp Bibliothek müsse vorhanden sein. </br>
    1. Mqtt_paho ---> [PAHO_C++](https://github.com/eclipse/paho.mqtt.cpp) </br>
    2. jsoncpp   ---> [jsoncpp](https://github.com/open-source-parsers/jsoncpp) 

# Nächter Schritt

die [Voraussetzungen für die Nützung Eclipse Ditto](../Ditto_Vorausetzungen/README.md), und die [Voraussetzungen für die Nützung von Hono](../Hono_Vorausetungen/README.md) **müssen** erst duchgeführt werden bevor man wieder die Schritte in [README.md](../../README.md) weiterführen kann.