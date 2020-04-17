using Dockery.View;
using Dockery.DockerSdk;

namespace View.Docker.Menu {
 
    /**
     * Factory to create Container list item menu
     */
    public class ContainerMenuFactory {

        /**
         * Create a {@ContainerMenu} from a given {@link Dockery.DockerSdk.Model.Container} (status))
         */
        public static ContainerMenu? create(Model.Container container) {

            switch(container.status) {
                case Model.ContainerStatus.RUNNING:
                    return new RunningContainerMenu(container);
                case Model.ContainerStatus.PAUSED:
                    return new PausedContainerMenu(container);
                case Model.ContainerStatus.EXITED:
                    return new ExitedContainerMenu(container);
                case Model.ContainerStatus.CREATED:
                    return new CreatedContainerMenu(container);
                case Model.ContainerStatus.RESTARTING:
                    return null;
                default:
                    return null;
            }
        }
    }

    /**
     * Base Container list item menu
     */
    public abstract class ContainerMenu : ContainerSignalDispatcher, Menu {

        protected Model.Container container;

        public ContainerMenu(Model.Container container) {
            this.container = container;
        }

        protected void append_play_pause_menu_item() {

            Gtk.MenuItem menu_item;
            if (container.status == Model.ContainerStatus.PAUSED) {
                menu_item  = new Gtk.MenuItem.with_mnemonic("_Unpause container");
            } else {
                menu_item  = new Gtk.MenuItem.with_mnemonic("_Pause container");
            }

            this.add_play_pause_menu_item_listener(menu_item, container);

            this.add(menu_item);
        }

        protected void append_start_menu_item() {

            this.append_menu_item("_Start container", () => {
                SignalDispatcher.dispatcher().container_start_request(container);
            });
        }

        protected void append_stop_menu_item() {
            this.append_menu_item("_Stop container", () => {
                SignalDispatcher.dispatcher().container_stop_request(container);
            });
        }

        protected void add_play_pause_menu_item_listener(Gtk.MenuItem menu_item, Model.Container container) {
            menu_item.activate.connect(() => {
                if (container.status == Model.ContainerStatus.PAUSED) {
                    SignalDispatcher.dispatcher().container_status_change_request(Model.ContainerStatus.RUNNING, container);
                } else if (container.status == Model.ContainerStatus.RUNNING) {
                    SignalDispatcher.dispatcher().container_status_change_request(Model.ContainerStatus.PAUSED, container);
                }
            });
        }

        protected void append_rename_menu_item() {
            this.append_menu_item("Re_name container", () => {
                this.container_rename_request(container, null, null);
            });
        }

        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove container", () => {
                SignalDispatcher.dispatcher().container_remove_request(container);
            });
        }

        protected void append_kill_menu_item() {
            this.append_menu_item("_Kill container", () => {
                SignalDispatcher.dispatcher().container_kill_request(container);
            });
        }

        protected void append_restart_menu_item() {
            this.append_menu_item("Re_start container", () => {
                SignalDispatcher.dispatcher().container_restart_request(container);
            });
        }

        protected void append_bash_in_menu_item() {
            this.append_menu_item("Bash-in", () => {
                SignalDispatcher.dispatcher().container_bash_in_request(container);
            });
        }
        
        protected void append_inspect_menu_item() {
            this.append_menu_item("Inspect", () => {
                SignalDispatcher.dispatcher().container_inspect_request(container);
            });
        }

        protected void append_stats_menu_item() {
            this.append_menu_item("Stats", () => {
                SignalDispatcher.dispatcher().container_stats_request(container);
            });
        }
    }

    internal class RunningContainerMenu : ContainerMenu {

        public RunningContainerMenu(Model.Container container) {

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

        public PausedContainerMenu(Model.Container container) {
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

        public NonRunningContainerMenu(Model.Container container) {

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

        public ExitedContainerMenu(Model.Container container) {
            base(container);
        }
    }

    /**
     * CreatedContainerMenu should only be associated to created containers
     */
    internal class CreatedContainerMenu : NonRunningContainerMenu {

        public CreatedContainerMenu(Model.Container container) {
            base(container);
        }
    }
}
