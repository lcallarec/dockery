using Dockery.DockerSdk;

private void register_container_event_deserializer_test() {
    Test.add_func("/Dockery/DockerSdk/Serializer/EventDeserializer/Container#NominalCase", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            var event = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
    
            //Then
            assert(event.status == "restart");
            assert(event.event_type == "container");
            assert(event.action == "restart");
            assert(event.scope == "local");
            assert(event.time == 1561197749);
            assert(event.actor.attributes.get("image") == "sha256:b6353");
            assert(event.actor.attributes.get("name") == "musing_varahamihira");
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/EventDeserializer/Container#Rename", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            var event = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_rename());
    
            //Then
            assert(event.status == "rename");
            assert(event.event_type == "container");
            assert(event.action == "rename");
            assert(event.scope == "local");
            assert(event.time == 1561197749);
            stdout.printf("fgdgfdgfd => %s", event.actor.attributes.get("image"));
            assert(event.actor.attributes.get("image") == "dockery-build");
            assert(event.actor.attributes.get("name") == "awesome_vala");
            assert(event.actor.attributes.get("oldName") == "/awesome_neumann");
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/EventDeserializer/Network#WithContainer", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            deserializer.deserialize(one_event_network_with_container());
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/EventDeserializer/Volume#UnmountWithContainer", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            var event = (Dto.Events.VolumeEvent) deserializer.deserialize(one_event_volume_unmount_with_container());
    
            //Then
            assert(event.event_type == "volume");
            assert(event.action == "unmount");
            assert(event.scope == "local");
            assert(event.time == 1561217240);
            assert(event.actor.attributes.get("container") == "cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e");
            assert(event.actor.attributes.get("driver") == "local");
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/EventDeserializer/Volume#MountWithContainer", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            var event = (Dto.Events.VolumeEvent) deserializer.deserialize(one_event_volume_mount_with_container());
    
            //Then
            assert(event.event_type == "volume");
            assert(event.action == "mount");
            assert(event.scope == "local");
            assert(event.time == 1561217961);
            assert(event.actor.attributes.get("container") == "cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e");
            assert(event.actor.attributes.get("driver") == "local");
            assert(event.actor.attributes.get("destination") == "/data");
            assert(event.actor.attributes.get("propagation") == "");
            assert(event.actor.attributes.get("read/write") == "true");
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/EventDeserializer/Image#Delete", () => {

        //Given
        var deserializer = new Serializer.EventDeserializer();

        try {
            //When
            var event = (Dto.Events.ImageEvent) deserializer.deserialize(one_event_image_delete());
    
            //Then
            assert(event.event_type == "image");
            assert(event.id == "sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2");
            assert(event.action == "delete");
            assert(event.scope == "local");
            assert(event.time == 1561219084);
            assert(event.actor.attributes.get("name") == "sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2");
            assert(event.actor.ID == "sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2");
        } catch (Error e) {
            assert_not_reached();
        }
    });    
}

string one_event_container_nominal_case() {
  return """
        {
            "status":"restart",
            "id":"cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e",
            "from":"sha256:b6353",
            "Type":"container",
            "Action":"restart",
            "Actor":{
                "ID":"cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e",
                "Attributes":{
                    "image":"sha256:b6353",
                    "name":"musing_varahamihira"
                }
            },
            "scope":"local",
            "time":1561197749,
            "timeNano":1561197749850964639
        }
        """;
}

internal string one_event_container_rename() {
  return """
        {
            "status":"rename",
            "id":"02f2cca84acb9c225bd78e4df9c464dcddfd8533d9c209abdcf9acc8b0491ff2",
            "from":"sha256:b6353",
            "Type":"container",
            "Action":"rename",
            "Actor":{
                "ID":"02f2cca84acb9c225bd78e4df9c464dcddfd8533d9c209abdcf9acc8b0491ff2",
                "Attributes":{
                    "image":"dockery-build",
                    "name":"awesome_vala",
                    "oldName":"/awesome_neumann"
                }
            },
            "scope":"local",
            "time":1561197749,
            "timeNano":1561197749850964639
        }
        """;
}

internal string one_event_network_with_container() {
  return """
        {
            "Type":"network",
            "Action":"disconnect",
            "Actor":{
                "ID":"2d78658da2b70e5e46be0185fbb1bde4c8a4f0b2a16532949e53d073e3d68ef6",
                "Attributes":{
                    "container":"cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e",
                    "name":"bridge",
                    "type":"bridge"
                }
            },
            "scope":"local",
            "time":1561214664,
            "timeNano":1561214664164245919
        }
        """;
}

internal string one_event_volume_unmount_with_container() {
  return """
        {
            "Type":"volume",
            "Action":"unmount",
            "Actor": {
                "ID":"2cfd9decd9840dcd79adf78d62836152118461093f5e0bd11dbe8fddc3d5cf3b",
                "Attributes":{
                    "container":"cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e",
                    "driver":"local"
                }
            },
            "scope":"local",
            "time":1561217240,
            "timeNano":1561217240421371408
        }
        """;
}

internal string one_event_volume_mount_with_container() {
  return """
        {
            "Type":"volume",
            "Action":"mount",
            "Actor":{
                "ID":"2cfd9decd9840dcd79adf78d62836152118461093f5e0bd11dbe8fddc3d5cf3b",
                "Attributes":{
                    "container":"cc8d9a0b9a28666880eed28907f86cb07ef769b738e76a14cc610f407fa30e2e",
                    "destination":"/data",
                    "driver":"local",
                    "propagation":"",
                    "read/write":"true"
                }
            },"scope":"local",
            "time":1561217961,
            "timeNano":1561217961956362106
        }
        """;
}

internal string one_event_image_delete() {
  return """
        {
            "status":"delete",
            "id":"sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2",
            "Type":"image",
            "Action":"delete",
            "Actor":{
                "ID":"sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2",
                "Attributes":{"name":"sha256:992c435ae08c77a01308054ec4d2397bdee7d29eed4a3036aab1b71e9f43fde2"}
            },"scope":"local",
            "time":1561219084,
            "timeNano":1561219084238262061
        }
        """;
}
