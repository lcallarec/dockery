namespace View.Docker.Menu {

    using global::Dockery.DockerSdk.Model;

    /**
     * Factory to create Container list item menu
     */
    public class ContainerMenuFactory {

        /**
         * Create a {@ContainerMenu} from a given {@link Dockery.DockerSdk.Model.Container} (status))
         */
        public static ContainerMenu? create(Container container) {

            switch(container.status) {
                case ContainerStatus.RUNNING:
                    return new RunningContainerMenu(container);
                case ContainerStatus.PAUSED:
                    return new PausedContainerMenu(container);
                case ContainerStatus.EXITED:
                    return new ExitedContainerMenu(container);
                case ContainerStatus.CREATED:
                    return new CreatedContainerMenu(container);
                case ContainerStatus.RESTARTING:
                    return null;
                default:
                    return null;
            }
        }
    }

    /**
     * Base Container list item menu
     */
    public abstract class ContainerMenu : Signals.ContainerRequestAction, Menu {

        protected Container container;

        public ContainerMenu(Container container) {
            this.container = container;
        }

        protected void append_play_pause_menu_item() {

            Gtk.ImageMenuItem menu_item;
            if (container.status == ContainerStatus.PAUSED) {
                menu_item  = new Gtk.ImageMenuItem.with_mnemonic("_Unpause container");
            } else {
                menu_item  = new Gtk.ImageMenuItem.with_mnemonic("_Pause container");
            }

            this.add_play_pause_menu_item_listener(menu_item, container);

            this.add(menu_item);
        }

        protected void append_start_menu_item() {

            this.append_menu_item("_Start container", null, () => {
                this.container_start_request(container);
            });
        }

        protected void append_stop_menu_item() {
            this.append_menu_item("_Stop container", null, () => {
                this.container_stop_request(container);
            });
        }

        protected void add_play_pause_menu_item_listener(Gtk.MenuItem menu_item, Container container) {
            menu_item.activate.connect(() => {
                if (container.status == ContainerStatus.PAUSED) {
                    this.container_status_change_request(ContainerStatus.RUNNING, container);
                } else if (container.status == ContainerStatus.RUNNING) {
                    this.container_status_change_request(ContainerStatus.PAUSED, container);
                }
            });
        }

        protected void append_rename_menu_item() {
            this.append_menu_item("Re_name container", null, () => {
                this.container_rename_request(container, null, null);
            });
        }

        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove container", null, () => {
                this.container_remove_request(container);
            });
        }

        protected void append_kill_menu_item() {
            this.append_menu_item("_Kill container", null, () => {
                this.container_kill_request(container);
            });
        }

        protected void append_restart_menu_item() {
            this.append_menu_item("Re_start container", null, () => {
                this.container_restart_request(container);
            });
        }

        protected void append_bash_in_menu_item() {
            this.append_menu_item("Bash-in", null, () => {
                this.container_bash_in_request(container);
            });
        }
        
        protected void append_inspect_menu_item() {
            this.append_menu_item("Inspect", null, () => {
                this.container_inspect_request(container);
            });
        }

        protected void append_stats_menu_item() {
            this.append_menu_item("Stats", null, () => {
                stdout.printf("Menu clicked source\n");
                this.container_stats_request(container);
            });
        }
    }

    internal class RunningContainerMenu : ContainerMenu {

        public RunningContainerMenu(Container container) {

            base(container);

            this.append_play_pause_menu_item();
            this.append_restart_menu_item();
            this.append_stop_menu_item();
            this.append_separator_menu_item();
            this.append_rename_menu_item();
            this.append_separator_menu_item();
            this.append_bash_in_menu_item();
            this.append_separator_menu_item();
            this.append_kill_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
            this.append_separator_menu_item();
            this.append_inspect_menu_item();
            this.append_separator_menu_item();
            this.append_stats_menu_item();  
        }
    }

    internal class PausedContainerMenu : ContainerMenu {

        public PausedContainerMenu(Container container) {
            base(container);

            this.append_play_pause_menu_item();
            this.append_restart_menu_item();
            this.append_separator_menu_item();
            this.append_rename_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
            this.append_separator_menu_item();
            this.append_inspect_menu_item();
        }
    }

    /**
     * NonRunningContainerMenu should only be associated, as base class,
     * to container that have been running once, or were just created.
     */
    internal abstract class NonRunningContainerMenu : ContainerMenu {

        public NonRunningContainerMenu(Container container) {

            base(container);

            this.append_start_menu_item();
            this.append_separator_menu_item();
            this.append_rename_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
            this.append_separator_menu_item();
            this.append_inspect_menu_item();
        }
    }

    /**
     * ExitedContainerMenu should only be associated to exited containers
     */
    internal class ExitedContainerMenu : NonRunningContainerMenu {

        public ExitedContainerMenu(Container container) {
            base(container);
        }
    }

    /**
     * CreatedContainerMenu should only be associated to created containers
     */
    internal class CreatedContainerMenu : NonRunningContainerMenu {

        public CreatedContainerMenu(Container container) {
            base(container);
        }
    }
}
