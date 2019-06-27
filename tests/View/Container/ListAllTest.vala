using Dockery.View;
using Dockery.DockerSdk;

private void register_view_container_listall_test() {

    Test.add_func("/Dockery/View/Container/ListAll#NoContainers", () => {
        //given
        var view = new Container.ListAll();
        var containers = new Model.ContainerCollection();

        //When
        view.init(containers);
        
        //Then
        var empty = ChildWidgetFinder.find_by_name(view, "empty-box-docker-symbolic");
        assert(empty != null);
    });

    Test.add_func("/Dockery/View/Container/ListAll#WithContainers", () => {
        //given
        var view = new Container.ListAll();
        var containers = new Model.ContainerCollection();
        containers.add(create_container_from("running", "1"));
        containers.add(create_container_from("running", "2"));
        containers.add(create_container_from("paused", "3"));
        containers.add(create_container_from("created", "4"));

        //When
        view.init(containers);
        
        //Then
        assert(ChildWidgetFinder.find_by_name(view, "empty-box-docker-symbolic") == null);

        var found_notebook = ChildWidgetFinder.find_by_name(view, "notebook");
        assert(found_notebook != null);

        var notebook = (Gtk.Notebook) found_notebook;

        assert(notebook.get_n_pages() == 3);

        var page1 = notebook.get_nth_page(0);
        assert(notebook.get_tab_label_text(page1) == "running");
         
        var page2 = notebook.get_nth_page(1);
        assert(notebook.get_tab_label_text(page2) == "paused");
         
        var page3 = notebook.get_nth_page(2);
        assert(notebook.get_tab_label_text(page3) == "created");

    });    
}