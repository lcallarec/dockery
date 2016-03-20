namespace Sdk.Docker.Model {

   /**
    * Static helper class for size formatting     
    */
    public class SizeFormatter {
        
        const string[] SIZE_UNITS   = {"B", "KB", "MB", "GB", "TB"};
        const double KFACTOR = 1000;

       /**
        * format a string of bytes to an human readable format with units
        */
        public static string string_bytes_to_human(string bytes) {
            double current_size = double.parse(bytes);
            string current_size_formatted = bytes.to_string() + SizeFormatter.SIZE_UNITS[0];  

            for (int i = 0; i<= SizeFormatter.SIZE_UNITS.length; i++) {
                if (current_size < SizeFormatter.KFACTOR) {
                     return GLib.Math.round(current_size).to_string() + SizeFormatter.SIZE_UNITS[i];
                }                
                current_size = current_size / SizeFormatter.KFACTOR;
            }

            return current_size_formatted;
        }
    }
}
