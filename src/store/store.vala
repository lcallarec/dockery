namespace Store {
	
	/*
	 * Store.Images.vala
	 *
	 * Laurent Callarec <l.callarec@gmail.com>
	 *
	 */
	public class Images : GLib.Object {
		public static Gtk.ListStore create_list_store() {
			return new Gtk.ListStore(2, typeof (string),  typeof (string));
		}
	}
}
