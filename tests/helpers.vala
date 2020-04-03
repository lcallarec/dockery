using Dockery.DockerSdk.Model;

Container create_container_from(string status, string id) {
    var names = new Array<string>();
    names.append_val("Container name");
    return new Container.from(
        id,
        1543876818,
        "/bin/bash",
        "ImageID",
        names,
        ContainerStatusConverter.convert_to_enum(status)
    );
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