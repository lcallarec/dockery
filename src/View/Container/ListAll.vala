using Dockery;
using Dockery.DockerSdk;
using Dockery.View;
using Dockery.Listener;
using View.Docker.Menu;

namespace Dockery.View.Container {

    public class ListAll : Flushable, ContainerViewable, Gtk.Box {

        public Gtk.Notebook notebook;
        private Gtk.Box empty_box;
        private Model.ContainerCollection containers = new Model.ContainerCollection();

        private UserActions user_actions = UserActions.get_instance();
        public Controls.ContainerButtonsRow header_controls = new Controls.ContainerButtonsRow();

        public ListAll() {
            Object(orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            user_actions.if_hasnt_feature_set(UserActionsTarget.CURRENT_CONTAINER_NOTEBOOK_PAGE, "0");
            this.header_controls.set_margin_end(8);
            this.header_controls.name = "container-header-controls";
        }

        /**
         * Init the container list view from a given collection of containers and return it
         */
        public ListAll init(Model.ContainerCollection containers, bool show_after_refresh = true) {

            this.flush();
            this.containers = containers;
            if (containers.is_empty) {

                this.notebook = null;
                empty_box = IconMessageBoxBuilder.create_icon_message_box("No container found", "docker-symbolic");            
                
                this.pack_start(this.empty_box, true, true, 0);

                if (show_after_refresh == true) {
                    this.show_all();
                }

            } else {
            
                this.empty_box = null;
                this.notebook = new Gtk.Notebook();
                this.notebook.set_name("notebook");

                if (Feature.CONTAINER_BUTTON_ROW) {
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

        private int hydrate(Model.ContainerStatus current_status, Model.ContainerCollection containers) {

            var search = new Gtk.SearchEntry();
            search.set_name("search-container-" + Model.ContainerStatusConverter.convert_from_enum(current_status));
            search.width_chars = 30;

            var treeview = create_treeview_from_containers(containers, search);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow(null, null);
            scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add(treeview);

            var search_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            search_box.margin = 5;
            search_box.pack_end(search, false, false, 0);
            
            var treeview_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            treeview_container.pack_start(search_box, false, false, 2);
            treeview_container.pack_start(scrolled_window, true, true, 0);

            notebook.append_page(treeview_container, new Gtk.Label(Model.ContainerStatusConverter.convert_from_enum(current_status)));

            return containers.size;
        }

        private Gtk.TreeView create_treeview_from_containers(Model.ContainerCollection containers, Gtk.SearchEntry entry) {
            
            var model = create_model_from_containers(containers, entry);

            var treeview = new Gtk.TreeView();
            treeview.set_name("container-treeview");
            treeview.set_model(model);

            treeview.vexpand = true;
            treeview.hexpand = true;

            treeview.insert_column_with_attributes(-1, "Name",       new Gtk.CellRendererText(), "text", 0);
            treeview.insert_column_with_attributes(-1, "ID",         new Gtk.CellRendererText(), "text", 1);
            treeview.insert_column_with_attributes(-1, "Command",    new Gtk.CellRendererText(), "text", 2);
            treeview.insert_column_with_attributes(-1, "Created at", new Gtk.CellRendererText(), "text", 3);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            var selection = treeview.get_selection();
            selection.set_mode(Gtk.SelectionMode.SINGLE);

            treeview.button_press_event.connect((e) => {

                var tp = this.select_path(e, treeview, selection);
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
                                treeview.get_cell_area (tp, treeview.get_column(0), out rect);
                                rect.y = rect.y + rect.height;
                                SignalDispatcher.dispatcher().container_rename_request(container, treeview, rect);
                            });
                        }
                    } else if (e.button == 1) {
                        Model.Container container = containers.get_by_id(id);
                        header_controls.select(container);
                    }
                }
                    
                return false;
            });

            return treeview;
        }

        private Gtk.TreeModelFilter create_model_from_containers(Model.ContainerCollection containers, Gtk.SearchEntry entry) {
            
            Gtk.ListStore liststore = new Gtk.ListStore(4, typeof (string),  typeof (string), typeof (string), typeof (string));
            liststore.clear();

            Gtk.TreeIter iter;

            foreach(Model.Container container in containers.values) {
                liststore.append(out iter);
                liststore.set(iter, 0, container.name, 1, container.id, 2, container.command, 3, container.created_at.to_string());
            }

            int[] columns = { 0, 1, 2 };
            var filter = new Gtk.TreeModelFilter(liststore, null);
            filter.set_visible_func((model, iter) => {
                var search_pattern = entry.text.chomp();
                if (search_pattern == "") {
                    return true;
                }
                foreach (int column in columns) {
                    Value v;
                    model.get_value(iter, column, out v);
                    if ((v as string).contains(search_pattern)) {
                        return true;
                    }
                }

                return false;
            });

            entry.search_changed.connect(() => {
                filter.refilter();
            });

            return filter;
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
    }
}
