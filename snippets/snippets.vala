//Mouse Events 
Gtk.ListBoxRow row = new Gtk.ListBoxRow();
Gtk.EventBox eb = new Gtk.EventBox();
eb.add(row);

Gtk.Popover popover = new Gtk.Popover(row);
popover.position = Gtk.PositionType.BOTTOM;
var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

popover.add(box);

eb.button_press_event.connect((e) => {
    if (3 == e.button) {
        Gdk.Rectangle t = {
            (int) e.x, (int) e.y, 10, 10
        };
        popover.pointing_to = t;
        popover.show_all();
        return true;    
    }
    
    return false;
    
});
