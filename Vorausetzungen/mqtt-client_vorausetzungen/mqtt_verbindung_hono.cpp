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
