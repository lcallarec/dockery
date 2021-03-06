using Dockery.DockerSdk.Io;

namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

    public class RegistryHubEndpoint : Endpoint {

        protected DeserializerInterface<Model.ImageTagCollection> deserializer;

        public RegistryHubEndpoint(Client.Client client, DeserializerInterface<Model.ImageTagCollection> deserializer) {
            base(client);
            this.deserializer = deserializer;
        }

        public Model.ImageTagCollection list(string image_name) throws RequestError {

            try {
                return deserializeImageTags(this.client.send("GET", "/repositories/%s/tags".printf(image_name)).payload);
            } catch (RequestError e) {
                 throw new RequestError.FATAL("Error while fetching image tags from Docker registry hub : %s".printf(e.message));
            }
        }

        private Model.ImageTagCollection deserializeImageTags(string payload) {
            try {
                return this.deserializer.deserialize(payload);
            } catch (Error e) {
                return new Model.ImageTagCollection();
            }
        }
    }
}
