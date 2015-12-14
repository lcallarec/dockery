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
			
			var id_column = new Gtk.CellRendererText();
			
			var created_at_column = new Gtk.CellRendererText();
			
			this.insert_column_with_attributes (0, "Id", id_column, "text", 0);
			this.insert_column_with_attributes (1, "Created At", created_at_column, "text", 1);
		}
	}
}
