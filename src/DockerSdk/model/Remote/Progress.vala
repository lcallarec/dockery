namespace Dockery.DockerSdk.Model.Remote {

    public class Progress : ProgressAware, GLib.Object {

        public int current {get; construct set;}
        public int total {get; construct set;}

        public Progress(int current, int total) {
            this.current = current;
            this.total = total;
        }
    }
}    