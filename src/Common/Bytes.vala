namespace Dockery.Common.Unit {

    public enum BytesUnit {
        B,
        KB,
        MB,
        GB,
        TB;

        public string to_string() {
            switch (this) {
                case B:
                    return "B";
                case KB:
                    return "KB";
                case MB:
                    return "MB";
                case GB:
                    return "GB";
                case TB:
                    return "TB";
                default:
                    assert_not_reached();
            }
       }

       public static string[] to_string_array() {
           return {"B", "KB", "MB", "GB", "TB"};
       }

       public static BytesUnit[] to_array() {
           return {B, KB, MB, GB, TB};
       }
    }

    const int BYTES_KFACTOR = 1000;
    
    public struct Bytes {
        int64 bytes;
        float unit_value;
        BytesUnit unit;

        public Bytes(int64 bytes) {
           this.bytes = bytes;
           this.unit_value = bytes;
           this.unit = BytesUnit.B;
        }

        public string to_string() {
            return unit_value.to_string().replace(",", ".") + unit.to_string();
        }

        public Bytes to_human(int decimal_precision = 2) {
            var bytes_size_units = BytesUnit.to_array();
            double current_size = this.bytes;
            for (int i = 0; i<= bytes_size_units.length; i++) {
                if (current_size < BYTES_KFACTOR) {
                    var k = decimal_precision == 0 ? 1 : Math.pow(10, (double) decimal_precision);
                    return Bytes(this.bytes) {
                        bytes = this.bytes,
                        unit_value = (float) ((double) Math.round(current_size * k) / k),
                        unit = bytes_size_units[i]
                    };
                }                
                current_size = current_size / BYTES_KFACTOR;
            }

            return this.clone();
        }

        public Bytes to(BytesUnit wanted_unit) {
            var diff = (double) ((int) BytesUnit.B - (int) wanted_unit);
            if (diff > 0) {
                return Bytes(this.bytes) {
                    bytes = this.bytes,
                    unit_value = (float) (this.unit_value * Math.pow(BYTES_KFACTOR, diff)),
                    unit = wanted_unit
                };
            } else if (diff < 0) {
                return Bytes(this.bytes) {
                    bytes = this.bytes,
                    unit_value = (float) (this.bytes / Math.pow(BYTES_KFACTOR, -diff)),
                    unit = wanted_unit
                };
            }

            return Bytes(this.bytes) {
                bytes = this.bytes,
                unit_value = this.bytes,
                unit = BytesUnit.B
            };
        }

        public Bytes clone() {
            return Bytes(bytes) {
                bytes = this.bytes,
                unit_value = this.unit_value,
                unit = this.unit
            };
        }
    }
}
