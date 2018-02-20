using Dockery.View;

private void register_view_child_widget_finder_test() {

    Test.add_func("/Dockery/View/ChildWidgetFinder#NoDirectChild", () => {

        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

        var found_widget = ChildWidgetFinder.find_by_name(box, "dont-found-me");

        assert(found_widget == null);
    });    

    Test.add_func("/Dockery/View/ChildWidgetFinder#DirectChildExists", () => {

        string widget_name = "found-me";

        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

        var label = new Gtk.Label("I'm a test label");
        label.set_name(widget_name);

        box.pack_start(label);

        var found_widget = ChildWidgetFinder.find_by_name(box, widget_name);

        assert(found_widget.get_name() == widget_name);
    });

    Test.add_func("/Dockery/View/ChildWidgetFinder#DeepChildExists", () => {

        string widget_name = "found-me";

        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var box2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        
        var label = new Gtk.Label("I'm a test label");
        label.set_name(widget_name);

        box.pack_start(box2);
        box2.pack_start(label);

        var found_widget = ChildWidgetFinder.find_by_name(box, widget_name);

        assert(found_widget.get_name() == widget_name);
    });    
}