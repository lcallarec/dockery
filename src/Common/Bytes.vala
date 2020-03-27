namespace Dockery.Common.Unit {

    const string[] BYTES_SIZE_UNITS = {"B", "KB", "MB", "GB", "TB"};
    const int BYTES_KFACTOR = 1000;
    
    public struct Bytes {
        int64 value;
        public Bytes(int64 bytes) {
           value = bytes;
        }
        public string to_human() {
   
            double current_size = value;
            string current_size_formatted = current_size.to_string() + BYTES_SIZE_UNITS[0];  

            for (int i = 0; i<= BYTES_SIZE_UNITS.length; i++) {
                if (current_size < BYTES_KFACTOR) {
                        return GLib.Math.round(current_size).to_string() + BYTES_SIZE_UNITS[i];
                }                
                current_size = current_size / BYTES_KFACTOR;
            }

            return current_size_formatted;
        }
    }
}
