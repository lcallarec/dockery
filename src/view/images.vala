namespace View {
	
	/*
	 * Images.ImagesTreeView.vala
	 * 
	 * Laurent Callarec <l.callarec@gmail.com>
	 * 
	 */
	public class ImagesTreeView : Gtk.TreeView {

		public ImagesTreeView(Gtk.ListStore list_store) {
			
			this.set_model(list_store);

			this.insert_column_with_attributes (0, "Id", new Gtk.CellRendererText(), "text", 0);
			this.insert_column_with_attributes (1, "Repo", new Gtk.CellRendererText(), "text", 1);
			this.insert_column_with_attributes (2, "Tag", new Gtk.CellRendererText(), "text", 2);
			this.insert_column_with_attributes (3, "Created At", new Gtk.CellRendererText(), "text", 2);
		}
	}
}
