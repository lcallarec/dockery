using Dockery.DockerSdk.Serializer;

namespace Dockery.View.Hub {
    
    public class PullImageFeedbackDecorator : GLib.Object {

        private PullStepDeserializer deserializer = new PullStepDeserializer();
        public Gtk.Label decorated {get; construct set;}

        public PullImageFeedbackDecorator(Gtk.Label decorated) {
            this.decorated = decorated;
        }
      
        public void update(string line) throws Error {
            string text = "";
            if (line != "") {
                var step = deserializer.deserialize(line);
                
                string status = step.status.to_string();
                text += "Status: %s\n".printf(status);

                if (step.id != "") {
                    text += "ID: %s\n".printf(step.id);
                }

                if (step.progress != null) {
                    text += "%s: %d of %d\n".printf(status, (int) step.progress.current, (int) step.progress.total);
                }

                GLib.Idle.add(() => {
                    decorated.set_label(text);
                    return false;
                });
            }
        }
    }
}
