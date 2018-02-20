using Dockery.DockerSdk;
using Dockery.View;

private void register_dockery_view_objectlist_volumes_test() {

    Test.add_func("/Dockery/View/ObjectList/Volumes#WithVolumes", () => {

        var view = new ObjectList.Volumes();

        var volumes = new Model.VolumeCollection();

        volumes.add(new Model.Volume.from("/volume1", "nfs1", "/", new Gee.HashMap<string, string>(), new Gee.HashMap<string, string>()));
        volumes.add(new Model.Volume.from("/volume2", "nfs2", "/", new Gee.HashMap<string, string>(), new Gee.HashMap<string, string>()));
        volumes.add(new Model.Volume.from("/volume3", "nfs3", "/", new Gee.HashMap<string, string>(), new Gee.HashMap<string, string>()));
                
        view.init(volumes);

        Gtk.TreeView treeview = (Gtk.TreeView) ChildWidgetFinder.find_by_name(view, "volumes-treeview");

        Gtk.TreeModel tree_model = treeview.get_model();

        uint nb_columns = treeview.get_n_columns();

        assert(nb_columns == 3);
        
        Gtk.TreeIter iter;
        tree_model.get_iter_from_string (out iter, "0");

        Value vname1;
        tree_model.get_value(iter, 0, out vname1);
        string name1 = vname1 as string;

        assert(name1 == "/volume1");

        tree_model.iter_next(ref iter);

        Value vname2;
        tree_model.get_value(iter, 0, out vname2);
        string name2 = vname2 as string;

        assert(name2 == "/volume2");

        tree_model.iter_next(ref iter);

        Value vname3;
        tree_model.get_value(iter, 0, out vname3);
        string name3 = vname3 as string;

        assert(name3 == "/volume3");

        assert(tree_model.iter_next(ref iter) == false);
    });

    Test.add_func("/Dockery/View/ObjectList/Volumes#WithoutVolumes", () => {

        var view = new ObjectList.Volumes();

        var volumes = new Model.VolumeCollection();
                
        view.init(volumes);

        assert(ChildWidgetFinder.find_by_name(view, "volumes-treeview") == null);
        
        var empty_box = ChildWidgetFinder.find_by_name(view, "empty-box");
        assert(empty_box != null);
    });
}