using Dockery.Common;

private void register_unit_bytes_test() {

    Test.add_func("/Dockery/Common/Bytes#to_human(MB)", () => {

        // Given
        var bytes = 1750000;
        // When
        var result = Unit.Bytes(bytes);

        // Then
        assert(result.to_human() == "2MB");
    });

    Test.add_func("/Dockery/Common/Bytes#to_human(GB)", () => {

        // Given
        var bytes = 5050000000;
        // When
        var result = Unit.Bytes(bytes);

        // Then
        assert(result.to_human()  == "5GB");
    });    
}
