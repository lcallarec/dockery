namespace Dockery.Common.Unit {

    const string[] BYTES_SIZE_UNITS = {"B", "KB", "MB", "GB", "TB"};
    const int BYTES_KFACTOR = 1000;
    
    public struct Bytes {
        int64 bytes;
        float unit_value;
        string unit;

        public Bytes(int64 bytes) {
           this.bytes = bytes;
           this.unit_value = bytes;
           this.unit = "B";
        }

        public string to_string() {
            return unit_value.to_string() + unit;
        }

        public Bytes to_human(int decimal_precision = 2) {
            double current_size = this.bytes;
            for (int i = 0; i<= BYTES_SIZE_UNITS.length; i++) {
                if (current_size < BYTES_KFACTOR) {
                    var k = decimal_precision == 0 ? 1 : Math.pow(10, (double) decimal_precision);
                    return Bytes(this.bytes) {
                        bytes = this.bytes,
                        unit_value = (float) ((double) Math.round(current_size * k) / k),
                        unit = BYTES_SIZE_UNITS[i]
                    };
                }                
                current_size = current_size / BYTES_KFACTOR;
            }

            return Bytes(bytes) {
                bytes = this.bytes,
                unit_value = this.unit_value,
                unit = this.unit
            };
        }
    }
}
