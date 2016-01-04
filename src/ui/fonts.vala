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

        private static Pango.AttrList create_attr_list() {
            return new Pango.AttrList();        
        }
 
    }
}
