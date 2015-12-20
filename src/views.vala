namespace View {
	
    
    public interface ViewInterface : GLib.Object {
        public abstract void flush();
    }
    
    public abstract class ListBoxView : Gtk.ListBox, ViewInterface {
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
			
			int i = 0;
			foreach(Docker.Model.Image image in images) {
											
				Gtk.ListBoxRow row = new Gtk.ListBoxRow();
				row.set_selectable(false);
				Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
				row.add(box);
				
				Gtk.Box rbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_start(rbox, false, true, 1);
				
				Pango.AttrList attrs = new Pango.AttrList ();
				attrs.insert(Pango.attr_scale_new(Pango.Scale.SMALL));
				
				var label_id = new Gtk.Label(image.id);
				label_id.halign = Gtk.Align.START;
				label_id.set_selectable(true);
				
				var label_creation_date = new Gtk.Label(image.created_at.to_string());
				label_creation_date.attributes = attrs;
				label_creation_date.halign = Gtk.Align.START;
				label_creation_date.set_selectable(true);
				
				rbox.pack_start(label_id, false, true, 1); 
				rbox.pack_start(label_creation_date, false, true, 1);

				Gtk.Box mbox1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_start(mbox1, true, true, 0);
				
				StringBuilder sb = new StringBuilder();
				sb.printf("%s:%s", image.repository, image.tag);
				
				var label_repotag = new Gtk.Label(sb.str);
				label_repotag.halign = Gtk.Align.START;
				label_repotag.set_selectable(true);
				
				mbox1.pack_start(label_repotag, false, true, 0);
				
				this.insert(row, i);
				
				i++;
			}
			
			return i;
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
		 * Add new rows from containers array
		 */ 
		public int hydrate(Docker.Model.Container[] containers) {
			
			int i = 0;
			foreach(Docker.Model.Container container in containers) {
											
				Gtk.ListBoxRow row = new Gtk.ListBoxRow();
				row.set_selectable(false);
				Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
				row.add(box);
				
				Gtk.Box rbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_start(rbox, false, true, 1);
				
				Pango.AttrList attrs = new Pango.AttrList ();
				attrs.insert(Pango.attr_scale_new(Pango.Scale.SMALL));
				
				var label_id = new Gtk.Label(container.id);
				label_id.halign = Gtk.Align.START;
				label_id.set_selectable(true);
				
				var label_creation_date = new Gtk.Label(container.created_at.to_string());
				label_creation_date.attributes = attrs;
				label_creation_date.halign = Gtk.Align.START;
				label_creation_date.set_selectable(true);
				
				rbox.pack_start(label_id, false, true, 1); 
				rbox.pack_start(label_creation_date, false, true, 1);

				Gtk.Box mbox1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 1); 
				box.pack_start(mbox1, true, true, 0);
				
				var label_command = new Gtk.Label(container.command);
				label_command.halign = Gtk.Align.START;
				label_command.set_selectable(true);
				
				mbox1.pack_start(label_command, false, true, 0);
				
				this.insert(row, i);
				
				i++;
			}
			
			return i;
		}

		/**
		 * Flush all child widgets from the view
		 * Add new rows from containers array
		 */
		public int refresh(Docker.Model.Container[] containers, bool show_after_refresh = false) {
			this.flush();
			int containers_count = this.hydrate(containers);
			
			if (true == show_after_refresh) {
				this.show_all();				
			}
		
			return containers_count;
		}
	}
}
