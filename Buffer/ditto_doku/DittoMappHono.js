function mapToDittoProtocolMsg(
    headers,
    textPayload,
    bytePayload,
    contentType
) {

    if (contentType !== "application/octet-stream") {
        return null;                            // nur mit octet-stream nachrichten arbeiten
    }

    var jsonData = JSON.parse(textPayload);
    var elbow_joint = jsonData.elbow_joint_position_controller;
    var shoulder_lift_joint = jsonData.shoulder_lift_joint_position_controller;
    var shoulder_pan_joint = jsonData.shoulder_pan_joint_position_controller;
    var wrist_1_joint = jsonData.wrist_1_joint_position_controller;
    var wrist_2_joint = jsonData.wrist_2_joint_position_controller;
    var wrist_3_joint = jsonData.wrist_3_joint_position_controller;
    
    var path;
    var value;
    if (elbow_joint != null && shoulder_lift_joint != null && shoulder_lift_joint != null && wrist_1_joint != null && wrist_2_joint != null && wrist_3_joint != null) {
        path = "/features";
        value = {
            shoulder_pan_joint: {
                properties: {
                    value: shoulder_pan_joint
                }
            },
            shoulder_lift_joint: {
                properties: {
                    value: shoulder_lift_joint
                }
            },
            elbow_joint: {
                properties: {
                    value: elbow_joint
                }
            },
            wrist_1_joint: {
                properties: {
                    value: wrist_1_joint
                }
            },
            wrist_2_joint: {
                properties: {
                    value: wrist_2_joint
                }
            },
            wrist_3_joint: {
                properties: {
                    value: wrist_3_joint
                }
            }
        };
    } else if (shoulder_pan_joint != null) {
        path = "/features/shoulder_pan_joint/properties/value";
        value = shoulder_pan_joint;
    } else if (shoulder_lift_joint != null) {
        path = "/features/shoulder_lift_joint/properties/value";
        value = shoulder_lift_joint;
    } else if (elbow_joint != null) {
        path = "/features/elbow_joint/properties/value";
        value = elbow_joint;
    } else if (wrist_1_joint != null) {
        path = "/features/wrist_1_joint/properties/value";
        value = wrist_1_joint;
    } else if (wrist_2_joint != null) {
        path = "/features/wrist_2_joint/properties/value";
        value = wrist_2_joint;
    } else if (wrist_3_joint != null) {
        path = "/features/wrist_3_joint/properties/value";
        value = wrist_3_joint;
    }
    
    if (!path || !value) {
        return null;
    }

    return Ditto.buildDittoProtocolMsg(
        "org.steve.ditto",     // the namespace we use
        headers["device_id"],    // Hono sets the authenticated device-id in this header
        "things",                // it is a Thing entity we want to update
        "twin",                  // we want to update the twin
        "commands",
        "modify",                // command = modify
        path,
        headers,                 // copy all headers as Ditto headers
        value
    );
}