namespace Ui {
    
    public class ContainerMenuFactory {
        public static ContainerMenu? create(Docker.Model.Container container) {
            
            switch(container.status) {
                case Docker.Model.ContainerStatus.RUNNING:
                    return new RunningContainerMenu(container);
                case Docker.Model.ContainerStatus.PAUSED:
                    return new PausedContainerMenu(container);
                case Docker.Model.ContainerStatus.CREATED:
                    return null;
                case Docker.Model.ContainerStatus.RESTARTING:
                    return null;
                case Docker.Model.ContainerStatus.EXITED:
                    return null;
                default:
                    return null;
            }
        }
    }
    
    internal interface IPauseableContainerMenu : IDockerContainerActionable, Gtk.Menu {
       
        protected void append_play_pause_menu_item(Docker.Model.Container container) {
           
            Gtk.ImageMenuItem menu_item;
            var menu_image = new Gtk.Image();
           
            if (container.status == Docker.Model.ContainerStatus.PAUSED) {
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
       
       protected void add_play_pause_menu_item_listener(Gtk.MenuItem menu_item, Docker.Model.Container container) {
            menu_item.activate.connect(() => {
                if (container.status == Docker.Model.ContainerStatus.PAUSED) {
                    this.container_status_change_request(Docker.Model.ContainerStatus.RUNNING, container);
                } else if (container.status == Docker.Model.ContainerStatus.RUNNING) {
                    this.container_status_change_request(Docker.Model.ContainerStatus.PAUSED, container);
                }
            });
       }
    }
  
    public interface IRemoveableContainerMenu : IDockerContainerActionable, Gtk.Menu {
        
        protected void append_remove_menu_item(Docker.Model.Container container) {
            var menu_item  = new Gtk.ImageMenuItem.with_mnemonic("_Remove");
            var menu_image = new Gtk.Image();
            menu_image.set_from_icon_name("user-trash-symbolic", Gtk.IconSize.MENU);
            menu_item.always_show_image = true;
            menu_item.set_image(menu_image);
                
            menu_item.activate.connect(() => {
                this.container_remove_request(container);
            });
            
            this.add(menu_item);
        }
    }    
    
    public class ContainerMenu : IDockerContainerActionable, IRemoveableContainerMenu, Gtk.Menu {
       
        protected Docker.Model.Container container;
        
        public ContainerMenu(Docker.Model.Container container) {
            this.container = container;
        }
 
        protected void append_separator_menu_item() {
            this.add(new Gtk.SeparatorMenuItem());
        }
    }
    
    internal class RunningContainerMenu : IPauseableContainerMenu, ContainerMenu {
        
        public RunningContainerMenu(Docker.Model.Container container) {
            
            base(container);
            
            this.append_play_pause_menu_item(container);
            this.append_separator_menu_item();
            this.append_remove_menu_item(container);
        }
    }
    
    internal class PausedContainerMenu : IPauseableContainerMenu, ContainerMenu {

        public PausedContainerMenu(Docker.Model.Container container) {
            base(container);
            
            this.append_play_pause_menu_item(container);
            this.append_separator_menu_item();
            this.append_remove_menu_item(container);
        }
    }
}
