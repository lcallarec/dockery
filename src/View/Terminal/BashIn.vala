/** @author Laurent Calalrec <l.callarec@gmail.com> **/
namespace Dockery.View.Terminal {

    using global::Dockery;

    public class BashIn : Vte.Terminal {

        protected DockerSdk.Model.Container container;

        public BashIn(DockerSdk.Model.Container container) {
            this.container = container;
            
            this.child_exited.connect((term) => {
                Gtk.Container c;
                if (null != parent_container_widget) {
                    c = parent_container_widget;
                } else {
                    c = (Gtk.Container) this.get_parent();
                }
                c.destroy();
                this.destroy();
            });
        }

        public void start() throws GLib.Error {

            string[] command = {"/usr/bin/docker", "exec", "-ti", container.id, "bash"};

            Pid pid;
            
            #if PPS_LIBVTE_2_91
            fork_command_full(
                Vte.PtyFlags.DEFAULT,
                Environment.get_variable("HOME"),
                command,
                new string[]{Environment.get_variable("HOME"), Environment.get_variable("PATH")},
                SpawnFlags.LEAVE_DESCRIPTORS_OPEN,
                null,
                out pid
            );    
            #endif
            
            #if PPS_LIBVTE_2_90
            spawn_sync(
                Vte.PtyFlags.DEFAULT,
                Environment.get_variable("HOME"),
                command,
                new string[]{Environment.get_variable("HOME"), Environment.get_variable("PATH")},
                SpawnFlags.LEAVE_DESCRIPTORS_OPEN,
                null,
                out pid,
                null
            );
            #endif
        }

        public Gtk.Container? parent_container_widget {
            get; set; default = null;
        }
    }
}
