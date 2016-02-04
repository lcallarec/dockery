namespace Ui.Docker.Menu {
    
    using global::Docker.Model;
    
    public class ContainerMenuFactory {
        public static ContainerMenu? create(Container container) {

            switch(container.status) {
                case ContainerStatus.RUNNING:
                    return new RunningContainerMenu(container);
                case ContainerStatus.PAUSED:
                    return new PausedContainerMenu(container);
                case ContainerStatus.EXITED:
                    return null;
                case ContainerStatus.CREATED:
                    return null;
                case ContainerStatus.RESTARTING:
                    return null;
                default:
                    return null;
            }
        }
    }

    public class ContainerMenu : Ui.Docker.ContainerActionable, Gtk.Menu {

        protected Container container;

        public ContainerMenu(Container container) {
            this.container = container;
            
            this.append_rename_menu_item();
        }
        
        protected void append_separator_menu_item() {
            this.add(new Gtk.SeparatorMenuItem());
        }
        
        protected void append_play_pause_menu_item() {

            Gtk.ImageMenuItem menu_item;
            var menu_image = new Gtk.Image();

            if (container.status == ContainerStatus.PAUSED) {
                menu_item  = new Gtk.ImageMenuItem.with_mnemonic("_Unpause container");
                menu_image.set_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.MENU);
                menu_item.always_show_image = true;
                menu_item.set_image(menu_image);
            } else {
                menu_item  = new Gtk.ImageMenuItem.with_mnemonic("_Pause container");
                menu_image.set_from_icon_name("media-playback-pause-symbolic", Gtk.IconSize.MENU);
                menu_item.always_show_image = true;
                menu_item.set_image(menu_image);
            }

            this.add_play_pause_menu_item_listener(menu_item, container);

            this.add(menu_item);
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
            this.append_menu_item("Re_name container", "view-more-horizontal-symbolic", () => {
                this.container_rename_request(container);
            });
        }
        
        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove container", "user-trash-symbolic", () => {
                this.container_remove_request(container);
            });
        }
        
        protected void append_kill_menu_item() {
            this.append_menu_item("_Kill container", "process-stop-symbolic", () => {
                this.container_kill_request(container);
            });
        }
        
        protected void append_menu_item(string mnemonic_label, string icon_name, MenuActivateAction action) {
            
            var menu_item  = new Gtk.ImageMenuItem.with_mnemonic(mnemonic_label);
            var menu_image = new Gtk.Image();
            
            menu_image.set_from_icon_name(icon_name, Gtk.IconSize.MENU);
            menu_item.always_show_image = true;
            menu_item.set_image(menu_image);

            menu_item.activate.connect(() => action());

            this.add(menu_item);
        }        
        
        /**
         * Delegate for menu activate signal 
         */ 
        public delegate void MenuActivateAction ();
    }

    internal class RunningContainerMenu : ContainerMenu {

        public RunningContainerMenu(Container container) {

            base(container);
            
            this.append_play_pause_menu_item();
            this.append_separator_menu_item();
            this.append_kill_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
        }
    }

    internal class PausedContainerMenu : ContainerMenu {
        
        public PausedContainerMenu(Container container) {
            base(container);

            this.append_play_pause_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
        }
    }

}
