using Dockery.DockerSdk;

private void register_dockersdk_serializer_pull_step_deserializer_test() {
    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:PULLING_FROM", () => {

        var deserializer = new Serializer.PullStepDeserializer();
        
        try {
          var step = deserializer.deserialize(pull_step_pulling_from("dockery/dockery", "1.0.0"));

          assert(step.status == Model.Remote.PullStepStatus.PULLING_FROM);
          assert(step.id == "1.0.0");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:PULLING_FS_LAYER", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_pulling_fs_layer("b6f892c0043b"));
          
          assert(step.status == Model.Remote.PullStepStatus.PULLING_FS_LAYER);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }

    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:WAITING", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_waiting("b6f892c0043b"));
          
          assert(step.status == Model.Remote.PullStepStatus.WAITING);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:DOWNLOADING", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_downloading("b6f892c0043b", 50000, 200000));
  
          assert(step.status == Model.Remote.PullStepStatus.DOWNLOADING);
          assert(step.id == "b6f892c0043b");
          assert(step.progress.current == 50000);
          assert(step.progress.total == 200000);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:DOWNLOAD_COMPLETE", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_download_complete("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.DOWNLOAD_COMPLETE);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });
    
    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:VERIFYING_CHECKSUM", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_verifying_checksum("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.VERIFYING_CHECKSUM);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:EXTRACTING", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_extracting("b6f892c0043b", 50000, 200000));
  
          assert(step.status == Model.Remote.PullStepStatus.EXTRACTING);
          assert(step.id == "b6f892c0043b");
          assert(step.progress.current == 50000);
          assert(step.progress.total == 200000);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:UNKOWN", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_unkown("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.UNKOWN);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:ALREADY_EXISTS", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_already_exists("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.ALREADY_EXISTS);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }        
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:PULL_COMPLETE", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_complete("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.PULL_COMPLETE);
          assert(step.id == "b6f892c0043b");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:DIGEST", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_digest("b6f892c0043b"));
  
          assert(step.status == Model.Remote.PullStepStatus.DIGEST);
          assert(step.id == "");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Serializer/PullStepDeserializer/Deserialize#Step:DOWNLOADED_NEWER_IMAGE_FOR", () => {

        var deserializer = new Serializer.PullStepDeserializer();

        try {
          var step = deserializer.deserialize(pull_step_downloaded_newer_image("dockery/dockery"));

          assert(step.status == Model.Remote.PullStepStatus.DOWNLOADED_NEWER_IMAGE_FOR);
          assert(step.id == "");
          assert(step.progress == null);
        } catch (Error e) {
          assert_not_reached();
        }
    });    
}

private string pull_step_pulling_from(string from, string id) {
  return @"{\"status\":\"Pulling from $(from)\",\"id\":\"$id\"}";
}

private string pull_step_pulling_fs_layer(string id) {
  return @"{\"status\":\"Pulling fs layer\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_waiting(string id) {
  return @"{\"status\":\"Waiting\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_downloading(string id, int current, int total) {
  return @"{\"status\":\"Downloading\",\"progressDetail\":{\"current\":$current,\"total\":$total},\"progress\":\"[==\\u003e                                                ]    1.9MB/46.89MB\",\"id\":\"$id\"}";
}

private string pull_step_download_complete(string id) {
  return @"{\"status\":\"Download complete\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_verifying_checksum(string id) {
  return @"{\"status\":\"Verifying Checksum\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_extracting(string id, int current, int total) {
  return @"{\"status\":\"Extracting\",\"progressDetail\":{\"current\":$current,\"total\":$total},\"progress\":\"[\\u003e                                                  ]  491.5kB/46.89MB\",\"id\":\"$id\"}";
}

private string pull_step_unkown(string id) {
  return @"{\"status\":\"...\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_already_exists(string id) {
  return @"{\"status\":\"Already exists\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_complete(string id) {
  return @"{\"status\":\"Pull complete\",\"progressDetail\":{},\"id\":\"$id\"}";
}

private string pull_step_digest(string id) {
  return @"{\"status\":\"Digest: sha256:5b28d6d8ebff4404143e94da7a874b86fa667f1350fbace4a636671ddb52c6f2\"}";
}

private string pull_step_downloaded_newer_image(string name) {
  return @"{\"status\":\"Status: Downloaded newer image for $name\"}";
}