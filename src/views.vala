namespace View {
    
    public interface ViewInterface : Gtk.Container {
        /**
		 * Remove all child widgets from the container
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
	public class ImagesView : ViewInterface, Gtk.ListBox {
        
        protected int size = 0;
		
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
				
				var label_repotag       = create_repotag_label(image);			
                var label_id            = create_id_label(image);
                var label_creation_date = create_creation_date_label(image);
				var label_size          = create_virtual_size_label(image);

                //attach (Widget child, int left, int top, int width = 1, int height = 1)
             	row_layout.attach(label_repotag,       0, 0, 1, 1);
                row_layout.attach(label_id,            0, 1, 1, 1);
				row_layout.attach(label_size,          1, 0, 1, 1);
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

		/**
		 * Create a repo:tab label
		 */	
		private Gtk.Label create_repotag_label(Docker.Model.Image image) {

			StringBuilder sb = new StringBuilder();
			sb.printf("from: <b>%s:%s</b>", GLib.Markup.escape_text(image.repository), GLib.Markup.escape_text(image.tag));

			var label = new Gtk.Label(null);
			label.set_markup(sb.str);
			label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.START;
			label.set_selectable(true);
			label.set_hexpand(true);

			return label;
		}

		/**
		 * Create a id label
		 */	
		private Gtk.Label create_id_label(Docker.Model.Image image) {

			var label = new Gtk.Label(image.id);
			label.halign = Gtk.Align.START;
			label.set_selectable(true);

			return label;
		}

		/**
		 * Create a creation date label
		 */	
		private Gtk.Label create_creation_date_label(Docker.Model.Image image) {

			var label = new Gtk.Label("%s: %s".printf("created at", image.created_at.to_string()));
			label.attributes = Fonts.get_minor();
			label.halign = Gtk.Align.START;
			label.set_selectable(true);

			return label;
		}

		/**
		 * Create a virtual size label
		 */	
		private Gtk.Label create_virtual_size_label(Docker.Model.Image image) {

			var label = new Gtk.Label(image.size);
			label.halign = Gtk.Align.START;

			return label;
		}		
	}
    
    /*
	 * ContainersView.vala
	 * 
	 * Laurent Callarec <l.callarec@gmail.com>
	 * 
	 */
	public class ContainersView : ViewInterface, Gtk.Box {
        
        protected Gtk.Notebook notebook = new Gtk.Notebook();
        
        public void flush() {
			notebook.@foreach((widget) => {
                notebook.detach_tab(widget);                    
			});
		}

        public ContainersView() {
            notebook.name = "notebook";
            pack_start(notebook, true, true, 0);
        }
        
		/**
		 * Add new rows from containers array list
		 */ 
		public int hydrate(Docker.Model.ContainerStatus status, Gee.ArrayList<Docker.Model.Container> containers) {
    
            int containers_count = 0;
            Gtk.ListBox list_box = new Gtk.ListBox();
            
 			foreach(Docker.Model.Container container in containers) {
                
                containers_count++;
                                                                        
				Gtk.ListBoxRow row = new Gtk.ListBoxRow();
                //For Gtk 3.14+ only				
				//row.set_selectable(false);

				Gtk.Grid row_layout = new Gtk.Grid();
                row_layout.column_spacing = 5;
                row_layout.row_spacing = 5;
                
                row.add(row_layout);
				
                var label_name          = create_name_label(container);
                var label_id            = create_id_label(container);
                var label_creation_date = create_creation_date_label(container);
                var label_command       = create_command_label(container);

                //attach (Widget child, int left, int top, int width = 1, int height = 1)
                row_layout.attach(label_name,          0, 0, 1, 1);
                row_layout.attach(label_id,            0, 1, 1, 1);
				row_layout.attach(label_command,       1, 0, 1, 1);
                row_layout.attach(label_creation_date, 1, 1, 1, 1);
                				
                Gtk.Separator separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
 				row_layout.attach(separator, 0, 3, 4, 2);
    
				list_box.insert(row, containers_count);
			}
      
            notebook.append_page(list_box, new Gtk.Label(Docker.Model.ContainerStatusConverter.convert_from_enum(status)));

			return containers_count;
		}

		/**
		 * Flush all child widgets from the view
		 * Add new rows from containers list
		 */
		public int refresh(Docker.Model.Containers containers, bool show_after_refresh = false) {
			this.flush();
            int containers_count = 0;
            foreach(Docker.Model.ContainerStatus status in Docker.Model.ContainerStatus.all()) {
                var c = containers.get_by_status(status);
                if (c.is_empty == false) {
                    containers_count = this.hydrate(status, c);
                }
            }
			this.show_all();
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
        
        /**
		 * Create an id label
		 */	
		private Gtk.Label create_id_label(Docker.Model.Container container) {

			var label = new Gtk.Label(container.id);
			label.halign = Gtk.Align.START;
			label.set_selectable(true);

			return label;
		}
        
        /**
		 * Create a creation date label
		 */	
		private Gtk.Label create_creation_date_label(Docker.Model.Container container) {

			var label = new Gtk.Label("%s: %s".printf("created at", container.created_at.to_string()));
			label.attributes = Fonts.get_minor();
			label.halign = Gtk.Align.START;
			label.set_selectable(true);

			return label;
		}
        
        /**
		 * Create a command label
		 */	
		private Gtk.Label create_command_label(Docker.Model.Container container) {

			var label = new Gtk.Label(container.command);
			label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.START;
            label.set_hexpand(true);
			label.set_selectable(true);

			return label;
		}
        
        /**
		 * Create a names label
		 */	
		private Gtk.Label create_name_label(Docker.Model.Container container) {

			var label = new Gtk.Label(container.name);
			label.halign = Gtk.Align.START;
            label.attributes = Fonts.get_em();
			label.set_selectable(true);

			return label;
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
