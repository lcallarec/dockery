namespace Dockery.View {

    public enum UserActionsTarget {
        CURRENT_CONTAINER_NOTEBOOK_PAGE;
    }

    public class UserActions : GLib.Object {

        private static UserActions instance = null;

        private Gee.HashMap<UserActionsTarget, string> feature_stack_value = new Gee.HashMap<UserActionsTarget, string>();

        public static UserActions get_instance() {
            if (instance == null) {
                instance = new UserActions();
            }

            return instance;
        }

        public void set_feature(UserActionsTarget target, string value) {
            feature_stack_value.set(target, value);
        }

        public bool has_feature(UserActionsTarget target) {
            return feature_stack_value.has_key(target);
        }

        public string? get_feature(UserActionsTarget target, string default_value = "0") {
            if (false == has_feature(target)) {
                return default_value;
            }

            return feature_stack_value.get(target);
        }

        public void if_hasnt_feature_set(UserActionsTarget target, string value) {
            if (false == has_feature(target)) {
                set_feature(target, value);
            }
        }

    }

}
