namespace Dockery.DockerSdk.Model.Remote {

    public interface ProgressAware : GLib.Object {
        public abstract int current {get; set;}
        public abstract int total {get; construct set;}
    }
}