namespace Ui {
    
    internal class Fonts {

        public static Pango.AttrList get_minor() {
            Pango.AttrList minor = create_attr_list();
            minor.insert(Pango.attr_scale_new(Pango.Scale.SMALL));
           
            return minor;
        }

        public static Pango.AttrList get_em() {
            Pango.AttrList em = create_attr_list();
            em.insert(Pango.attr_weight_new(Pango.Weight.BOLD));

            return em;            
        }

        public static Pango.AttrList get_panel_empty_major(float font_scale = 2) {
            Pango.AttrList ma = create_attr_list();
            ma.insert(Pango.attr_scale_new(font_scale));
            ma.insert(Pango.attr_foreground_new (48000, 48000, 48000));
            
            return ma;            
        }

        private static Pango.AttrList create_attr_list() {
            return new Pango.AttrList();
        }
 
    }
}
