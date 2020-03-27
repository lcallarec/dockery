using Dockery.Common;

namespace Dockery.DockerSdk.Model {

    /**
     * Image model
     */
    public class Image : BaseModel {

        public string repository {get; private set;}
        public string tag {get; private set;}
        public string name {get; private set;}
        public Unit.Bytes size {get; private set;}

        public Image.from(string id, int64 created_at, string repotags, uint size) {

            string[] _repotags = repotags.split(":", 2);

            this.full_id    = id;
            this.name       = repotags;
            this.created_at = new DateTime.from_unix_local(created_at);
            this.repository = _repotags[0];
            this.tag        = _repotags[1];
            this.size       = Unit.Bytes(size);
        }
    }
}
