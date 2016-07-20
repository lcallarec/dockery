namespace View.Docker {

    using global::Sdk.Docker.Model;

    public class Terminal : Vte.Terminal {

        protected string[] command;

        public Terminal(string[] command) {
            this.command = command;
        }

        public Terminal.from_bash_in_container(Container container) {
            command = {"/usr/bin/docker", "exec", "-ti", container.id, "bash"};

            this.child_exited.connect((term) => {
                Gtk.Container c;
                if (null != parent_container_widget) {
                    c = parent_container_widget;
                } else {
                    c = this.get_parent();
                }
                c.destroy();
                this.destroy();
            });
        }

        public void start() {

            Pid pid;
            fork_command_full(
                Vte.PtyFlags.DEFAULT,
                Environment.get_variable("HOME"),
                command,
                new string[]{Environment.get_variable("HOME"), Environment.get_variable("PATH")},
                SpawnFlags.LEAVE_DESCRIPTORS_OPEN ,
                null,
                out pid
            );
        }

        public Gtk.Container? parent_container_widget {
            get; set; default = null;
        }
    }
}
