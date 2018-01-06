namespace Dockery.Sdk.Docker.Dto.LowLevelContainer {
    
    class State : Object {
        
        public string Status {get;set;}
        public bool Running {get;set;}
        public bool Paused {get;set;}
        public bool Restarting {get;set;}
        public bool OOMKilled {get;set;}
        public bool Dead {get;set;}
        public int16 Pid {get;set;}
        public int8 ExitCode {get;set;}
        public string Error {get;set;}
        public string StartedAt {get;set;}
        public string FinishedAt {get;set;}        
        
        public State() {
            
        }
    }
}
