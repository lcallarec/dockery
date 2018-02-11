namespace Dockery.DockerSdk.Model.Remote {

    public class PullStepProgress : GLib.Object {

        public int64 current {get; construct set;}
        public int64 total {get; construct set;}

        public PullStepProgress(int64 current, int64 total) {
            this.current = current;
            this.total = total;
        }
    }
}    