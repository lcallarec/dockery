using Dockery;
using Dockery.DockerSdk;
using Dockery.View;
using Dockery.Listener;
using View.Docker.Menu;

namespace Dockery.View.Container {

    public class ListAll : global::View.Docker.Flushable, global::View.Docker.ContainerViewable, Gtk.Box {

        private Gtk.Notebook notebook;
        private Gtk.Box empty_box;
        private Model.ContainerCollection containers = new Model.ContainerCollection();

        private UserActions user_actions = UserActions.get_instance();
        public Controls.ContainerButtonsRow header_controls = new Controls.ContainerButtonsRow();

        public ListAll() {
            Object(orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            user_actions.if_hasnt_feature_set(UserActionsTarget.CURRENT_CONTAINER_NOTEBOOK_PAGE, "0");
            this.header_controls.set_margin_end(8);
        }

        /**
         * Init the container list view from a given collection of containers and return it
         */
        public ListAll init(Model.ContainerCollection containers, bool show_after_refresh = true) {

            this.flush();
            this.containers = containers;
            if (containers.is_empty) {

                this.notebook = null;
                this.empty_box = global::View.Docker.IconMessageBoxBuilder.create_icon_message_box("No container found", "docker-symbolic");            
                
                this.pack_start(this.empty_box, true, true, 0);

                if (show_after_refresh == true) {
                    this.show_all();
                }

            } else {
            
                this.empty_box = null;
                this.notebook  = new Gtk.Notebook();

                if (global::Dockery.Feature.CONTAINER_BUTTON_ROW) {
                    this.pack_start(this.header_controls, false, false, 5);
                }
                this.pack_start(this.notebook, true, true, 0);

                foreach(Model.ContainerStatus status in Model.ContainerStatus.all()) {
                    var c = containers.get_by_status(status);
                    if (c.is_empty == false) {
                        this.hydrate(status, c);
                    }
                }

                notebook.switch_page.connect((page, page_num) => {
                    user_actions.set_feature(UserActionsTarget.CURRENT_CONTAINER_NOTEBOOK_PAGE, page_num.to_string());
                });

                if (true == show_after_refresh) {
                    this.show_all();

                    int current_page = int.parse(user_actions.get_feature(UserActionsTarget.CURRENT_CONTAINER_NOTEBOOK_PAGE));
                    if (current_page + 1 > notebook.get_n_pages()) {
                        //-1 = last page
                        current_page = -1;
                    }
                    //This code should remain after show_all() invokation
                    //because set_current_page will have no effets if the page was not shown yet
                    notebook.set_current_page(current_page);
                }
            }

            return this;
        }

        public void flush() {
            if (null != this.empty_box) {
                this.remove(this.empty_box);
            }

            if (null != this.notebook) {
                this.remove(this.notebook);
            }
        }

        private string get_row_id(Gtk.TreeSelection selection) {
            Gtk.TreeModel m;
            Gtk.TreeIter i;
            selection.get_selected(out m, out i);

            Value oid;
            m.get_value(i, 1, out oid);

            return oid as string;
        }

        private Gtk.TreePath select_path(Gdk.EventButton e, Gtk.TreeView tv, Gtk.TreeSelection selection) {
            Gtk.TreePath tp;
            tv.get_path_at_pos((int) e.x, (int) e.y, out tp, null, null, null);
            selection.select_path(tp);

            return tp;
        }

        private int hydrate(Model.ContainerStatus current_status, Model.ContainerCollection containers) {

            int containers_count = 0;

            Gtk.TreeIter iter;

            Gtk.ListStore liststore = new Gtk.ListStore(4, typeof (string),  typeof (string), typeof (string), typeof (string));
            liststore.clear();

            foreach(Model.Container container in containers.values) {
                containers_count++;
                liststore.append(out iter);
                liststore.set(iter, 0, container.name, 1, container.id, 2, container.command, 3, container.created_at.to_string());
            }

            var tv = create_treeview(liststore);

            var selection = tv.get_selection();
            selection.set_mode(Gtk.SelectionMode.SINGLE);

            tv.button_press_event.connect((e) => {

                var tp = this.select_path(e, tv, selection);
                var id = this.get_row_id(selection);

                if (containers.has_id(id)) {
                    
                    if (e.button == 3) {
                        Model.Container container = containers.get_by_id(id);
                        var menu = global::View.Docker.Menu.ContainerMenuFactory.create(container);
                        if (null != menu) {
                            menu.show_all();
                            menu.popup_at_pointer(e);
                            menu.container_rename_request.connect(() => {
                                Gdk.Rectangle rect;
                                tv.get_cell_area (tp, tv.get_column(0), out rect);
                                rect.y = rect.y + rect.height;
                                SignalDispatcher.dispatcher().container_rename_request(container, tv, rect);
                            });
                        }
                    } else if (e.button == 1) {
                        Model.Container container = containers.get_by_id(id);
                        header_controls.select(container);
                    }
                }
                    
                return false;
            });

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow(null, null);
            scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add(tv);

            notebook.append_page(scrolled_window, new Gtk.Label(Model.ContainerStatusConverter.convert_from_enum(current_status)));

            return containers_count;
        }

        private Gtk.TreeView create_treeview(Gtk.ListStore liststore) {

            var treeview = new Gtk.TreeView();
            treeview.set_model(liststore);

            treeview.vexpand = true;
            treeview.hexpand = true;

            treeview.insert_column_with_attributes(-1, "Name",       new Gtk.CellRendererText(), "text", 0);
            treeview.insert_column_with_attributes(-1, "ID",         new Gtk.CellRendererText(), "text", 1);
            treeview.insert_column_with_attributes(-1, "Command",    new Gtk.CellRendererText(), "text", 2);
            treeview.insert_column_with_attributes(-1, "Created at", new Gtk.CellRendererText(), "text", 3);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            return treeview;
        }
    }
}
