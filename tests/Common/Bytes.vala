using Dockery.Common;

private void register_unit_bytes_test() {

    Test.add_func("/Dockery/Common/Bytes#to_human_with_two_digits(MB)", () => {

        // Given
        var bytes = 1750000;
        // When
        var result = Unit.Bytes(bytes);
        // Then
        assert(result.to_human(2).to_string() == "1,75MB");
    });

    Test.add_func("/Dockery/Common/Bytes#to_human_with_two_digits(GB)", () => {

        // Given
        var bytes = 5050000000;
        // When
        var result = Unit.Bytes(bytes);
        stdout.printf("R %s", result.to_human(2).to_string());
        // Then
        assert(result.to_human(2).to_string()  == "5,05GB");
    });

    Test.add_func("/Dockery/Common/Bytes#to_human_with_no_digits(GB)", () => {

        // Given
        var bytes = 5800000000;
        // When
        var result = Unit.Bytes(bytes);
        // Then
        assert(result.to_human(0).to_string()  == "6GB");
    });        
}
