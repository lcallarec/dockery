namespace Dockery.View {

    public class ChildWidgetFinder : GLib.Object {

        public static Gtk.Widget? find_by_name(Gtk.Widget widget, string name) {

            if (ChildWidgetFinder.get_widget_name(widget) == name) {
                return widget;
            }

            if (widget is Gtk.Container) {
                Gtk.Container container = (Gtk.Container) widget;
                foreach(Gtk.Widget child in container.get_children()) {
                    if (child is Gtk.Container) {
                        return ChildWidgetFinder.find_by_name(child, name);
                    } else if (ChildWidgetFinder.get_widget_name(child) == name) {
                        return child;
                    }
                }
            }

            return null;
        }

        private static string? get_widget_name(Gtk.Widget widget) {
            if (widget is Gtk.Buildable) {
                return widget.get_name();
            }
            return null;
        }
    }
}