namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

    public class RegistryHubEndpoint : Endpoint {

        private ImageTagDeserializerInterface image_tag_deserializer;

        public RegistryHubEndpoint(Client.HttpClient client, ImageTagDeserializerInterface image_tag_deserializer) {
            base(client);
            this.image_tag_deserializer = image_tag_deserializer;
        }

        public Model.ImageTagCollection list(string image_name) throws Io.RequestError {

            try {
                return deserializeImageTags(this.client.send("GET", "/repositories/%s/tags".printf(image_name)).payload);
            } catch (Io.RequestError e) {
                 throw new Io.RequestError.FATAL("Error while fetching image tags from Docker registry hub : %s".printf(e.message));
            }
        }

        private Model.ImageTagCollection deserializeImageTags(string payload) {
            try {
                return this.image_tag_deserializer.deserializeList(payload);
            } catch (Error e) {
                return new Model.ImageTagCollection();
            }
        }
    }
}
