namespace View {
    
    public interface ViewInterface : GLib.Object {
        public abstract void flush();
    }
    
    public abstract class ListBoxView : Gtk.ListBox, ViewInterface {
        protected int size = 0;
        /**
		 * Remove all child widgets from the view
		 */ 
		public virtual void flush() {
			this.@foreach((widget) => {
				this.remove(widget);
			});
		}
    }
    
	/*
	 * ImagesView.vala
	 * 
	 * Laurent Callarec <l.callarec@gmail.com>
	 * 
	 */
	public class ImagesView : ListBoxView {

		/**
		 * Add new rows from images array
		 */ 
		public int hydrate(Docker.Model.Image[] images) {
			
  			foreach(Docker.Model.Image image in images) {
											
				Gtk.ListBoxRow row = new Gtk.ListBoxRow();
				//For Gtk 3.14+ only				
				//row.set_selectable(false);

				Gtk.Grid row_layout = new Gtk.Grid();
                row.add(row_layout);
				
				StringBuilder sb = new StringBuilder();
				sb.printf("%s:%s", image.repository, image.tag);

				var label_repotag = new Gtk.Label(sb.str);
                label_repotag.attributes = Fonts.get_em();
				label_repotag.halign = Gtk.Align.START;
                label_repotag.valign = Gtk.Align.START;
				label_repotag.set_selectable(true);
				label_repotag.set_hexpand(true);

                row_layout.attach(label_repotag, 0, 0, 1, 1);

				var label_id = new Gtk.Label(image.id);
				label_id.halign = Gtk.Align.START;
				label_id.set_selectable(true);
				
				var label_creation_date = new Gtk.Label(image.created_at.to_string());
				label_creation_date.attributes = Fonts.get_minor();
				label_creation_date.halign = Gtk.Align.START;
				label_creation_date.set_selectable(true);
				
				var label_size = new Gtk.Label(image.size);
				label_size.halign = Gtk.Align.START;

                //attach (Widget child, int left, int top, int width = 1, int height = 1)
                row_layout.attach(label_id, 0, 1, 1, 1);
				row_layout.attach(label_size, 1, 0, 1, 1);
                row_layout.attach(label_creation_date, 1, 1, 1, 1);
				
                Gtk.Separator separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
 				row_layout.attach(separator, 0, 3, 4, 2);
				
				size += 1;

				this.insert(row, size);
			}

			return size;
		}

		/**
		 * Flush all child widgets from the view
		 * Add new rows from images array
		 */
		public int refresh(Docker.Model.Image[] images, bool show_after_refresh = false) {
			this.flush();
			int images_count = this.hydrate(images);
			
			if (true == show_after_refresh) {
				this.show_all();				
			}
		
			return images_count;
		}
	}
    
    /*
	 * ContainersView.vala
	 * 
	 * Laurent Callarec <l.callarec@gmail.com>
	 * 
	 */
	public class ContainersView : ListBoxView {

		/**
		 * Add new rows from containers array list
		 */ 
		public int hydrate(Docker.Model.ContainerStatus status, Gee.ArrayList<Docker.Model.Container> containers) {
			
            Gtk.ListBoxRow _row = new Gtk.ListBoxRow();
    
            var status_label = new Gtk.Label(Docker.Model.ContainerStatusConverter.convert_from_enum(status));
            status_label.attributes = Fonts.get_em();
            status_label.halign = Gtk.Align.START;
            _row.add(status_label);
            this.insert(_row, size);

			foreach(Docker.Model.Container container in containers) {
		
        		size++;
                											
				Gtk.ListBoxRow row = new Gtk.ListBoxRow();
				//For Gtk 3.14+ only				
				//row.set_selectable(false);
				Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
				row.add(box);
				
				Gtk.Box rbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_start(rbox, false, true, 1);
				
				var label_id = new Gtk.Label(container.id);
				label_id.halign = Gtk.Align.START;
				label_id.set_selectable(true);
				
				var label_creation_date = new Gtk.Label(container.created_at.to_string());
				label_creation_date.attributes = Fonts.get_minor();
				label_creation_date.halign = Gtk.Align.START;
				label_creation_date.set_selectable(true);
				
				rbox.pack_start(label_id, false, true, 1); 
				rbox.pack_start(label_creation_date, false, true, 1);

				Gtk.Box mbox1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_end(mbox1, true, true, 0);
				
				var label_command = new Gtk.Label(container.command);
				label_command.halign = Gtk.Align.START;
				label_command.set_selectable(true);
				
				mbox1.pack_start(label_command, true, true, 0);

				this.insert(row, size);
			}
            
			size++;
            
			return size;
		}

		/**
		 * Flush all child widgets from the view
		 * Add new rows from containers list
		 */
		public int refresh(Docker.Model.Containers containers, bool show_after_refresh = false) {
			this.flush();
            this.size = 0;
            int containers_count = 0;
            foreach(Docker.Model.ContainerStatus status in Docker.Model.ContainerStatus.all()) {
                var c = containers.get_by_status(status);
                if (c.is_empty == false) {
                    containers_count = this.hydrate(status, c);
                }
            }
			
			if (true == show_after_refresh) {
				this.show_all();				
			}
		
			return containers_count;
		}

        private Gtk.Switch addSwitch(Docker.Model.ContainerStatus status, Docker.Model.Container container) {
            Gtk.Switch _switch = new Gtk.Switch();

		    _switch.notify["active"].connect (() => {
			    if (_switch.active) {
			    	stdout.printf ("The switch is on!\n");
			    } else {
				    stdout.printf ("The switch is off!\n");
			    }
		    });

            return _switch; 
        } 
	}

    internal class Fonts {

        public static Pango.AttrList get_minor() {
            Pango.AttrList minor = create_attr_list();
			minor.insert(Pango.attr_scale_new(Pango.Scale.SMALL));
           
            return minor;
        }

        public static Pango.AttrList get_em() {
            Pango.AttrList em = create_attr_list();
			em.insert(Pango.attr_weight_new(Pango.Weight.BOLD));

            return em;            
        }

        private static Pango.AttrList create_attr_list() {
            return new Pango.AttrList();        
        }
 
    }
}
