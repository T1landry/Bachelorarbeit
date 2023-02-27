#!/bin/bash

output_file="datenbank.csv"
#utput_file="datenbank_für_vcsode.csv"

# Check if output file exists, if not create it
if [ ! -f "$output_file" ]; then
  echo "Time,Location,Type,Name,Manufacturer,Shoulder_Pan_Joint,Shoulder_Lift_Joint,Elbow_Joint,Wrist_1_Joint,Wrist_2_Joint,Wrist_3_Joint" > "$output_file"
fi

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
    echo "$(date +'%Y-%m-%d %T'),$location,$type,$name,$manufacturer,$shoulder_pan_joint,$shoulder_lift_joint,$elbow_joint,$wrist_1_joint,$wrist_2_joint,$wrist_3_joint" >> "$output_file" 
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