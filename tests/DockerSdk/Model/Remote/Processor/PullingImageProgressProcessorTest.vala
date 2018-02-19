using global::Dockery.DockerSdk;
using global::Dockery.DockerSdk.Model.Remote;

private void register_docekrsdk_remote_processor_pulling_image_progress_processor_test() {

    Test.add_func("/Dockery/DockerSdk/Remote/Processor#OneTag,OneLayer", () => {

        Processor.PullingImageProgressProcessor processor = new Processor.PullingImageProgressProcessor(new Model.ImageTag.from("php/php7:7.2", "a"));       

        processor.process(new PullStep.from(PullStepStatus.PULLING_FS_LAYER, "5161d2a139e2"));
        assert(processor.progress.current == 0);
        assert(processor.progress.total == 0);
        
        processor.process(new PullStep.from(PullStepStatus.WAITING, "5161d2a139e2"));
        assert(processor.progress.current == 0);
        assert(processor.progress.total == 0);
 
        processor.process(new PullStep.from(PullStepStatus.DOWNLOADING, "5161d2a139e2", new Progress(0, 1000)));
        assert(processor.progress.current == 0);
        assert(processor.progress.total == 1000);

        processor.process(new PullStep.from(PullStepStatus.PULLING_FS_LAYER, "7659b327f9ec"));
        assert(processor.progress.current == 0);
        assert(processor.progress.total == 1000);        

        processor.process(new PullStep.from(PullStepStatus.DOWNLOADING, "5161d2a139e2", new Progress(500, 1000)));
        assert(processor.progress.current == 500);
        assert(processor.progress.total == 1000);

        processor.process(new PullStep.from(PullStepStatus.DOWNLOADING, "7659b327f9ec", new Progress(0, 1000)));
        assert(processor.progress.current == 500);
        assert(processor.progress.total == 2000);

    });
 
}
