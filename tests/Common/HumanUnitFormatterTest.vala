using Dockery.Common;

private void register_common_human_unit_formatter_test () {

    Test.add_func("/Dockery/Common/HumanUnitFormatter#ToMB", () => {

        // Given
        var bytes = "1750000";
        // When
        var result = HumanUnitFormatter.string_bytes_to_human(bytes);

        // Then
        assert(result == "2MB");
    });

    Test.add_func("/Dockery/Common/HumanUnitFormatter#ToGB", () => {

        // Given
        var bytes = "5050000000";
        // When
        var result = HumanUnitFormatter.string_bytes_to_human(bytes);

        // Then
        assert(result == "5GB");
    });    
}
