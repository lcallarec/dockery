namespace Dockery.DockerSdk {

    public interface Serializable : GLib.Object {
        public abstract string serialize();
    }
}
