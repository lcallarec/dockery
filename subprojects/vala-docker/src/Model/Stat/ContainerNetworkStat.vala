using Dockery.Common;

namespace Dockery.DockerSdk.Model.Stat {

    public struct Transfers {
        Unit.Bytes rx;
        Unit.Bytes tx;
    }
    public class ContainerNetworkStat : Object {
        public Gee.HashMap<string, Transfers?> interfaces {get; private set; default = new Gee.HashMap<string, Transfers?>();}
        public Unit.Bytes rx {get; private set; }
        public Unit.Bytes tx {get; private set; }
        public ContainerNetworkStat.from(Gee.HashMap<string, Transfers?> interfaces) {
            this.interfaces = interfaces;
            
            int64 tx = 0;
            int64 rx = 0;
            foreach (Transfers transfer in interfaces.values) {
                tx += transfer.tx.bytes;
                rx += transfer.rx.bytes;
            }

            this.rx = Unit.Bytes(rx);
            this.tx = Unit.Bytes(tx);
        }
    }
}
