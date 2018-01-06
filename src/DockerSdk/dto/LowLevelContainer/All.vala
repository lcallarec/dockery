namespace Dockery.Dockery.DockerSdk.Dto.LowLevelContainer {
    
    class All : Object {
        
        public string Id {get;set;}
        public string Created {get;set;}
        public string Path {get;set;}
        public string[] Args {get;set;}
        public string State {get;set;}
        public string Image {get;set;}
        public string ResolvConfPath {get;set;}
        public string HostnamePath {get;set;}
        public string HostsPath {get;set;}
        public string LogPath {get;set;}
        public string Name {get;set;}
        public string RestartCount {get;set;}
        public string Driver {get;set;}
        public string Platform {get;set;}
        public string MountLabel {get;set;}
        public string ProcessLabel {get;set;}
        public string AppArmorProfile {get;set;}
        public string? ExecIDs {get;set;}
        public HostConfig HostConfig {get;set;}
        public GraphDriver GraphDriver {get;set;}
        public Mounts Mounts {get;set;}
        public Config Config {get;set;}
        public NetworkSettings NetworkSettings {get;set;}

        public All() {
            
        }
        
    }
    
}
