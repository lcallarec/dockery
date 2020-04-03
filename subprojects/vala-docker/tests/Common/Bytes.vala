using Dockery.Common;

private void register_unit_bytes_test() {

    Test.add_func("/Dockery/Common/Bytes#to_human_with_two_digits(MB)", () => {

        // Given
        var bytes = 1750000;
        // When
        var result = Unit.Bytes(bytes);
        // Then
        assert(result.to_human(2).to_string() == "1.75MB");
    });

    Test.add_func("/Dockery/Common/Bytes#to_human_with_two_digits(GB)", () => {

        // Given
        var bytes = 5050000000;
        // When
        var result = Unit.Bytes(bytes);
        // Then
        assert(result.to_human(2).to_string()  == "5.05GB");
    });

    Test.add_func("/Dockery/Common/Bytes#to_human_with_no_digits(GB)", () => {

        // Given
        var bytes = 5800000000;
        // When
        var result = Unit.Bytes(bytes);
        // Then
        assert(result.to_human(0).to_string()  == "6GB");
    });

    Test.add_func("/Dockery/Common/Bytes#To#units_back_and_forth", () => {

        // Given
        var bytes = 5800000000;
        // When
        var result = Unit.Bytes(bytes);

        // Then
        var gb = result.to_human(0);

        // When
        var b = gb.to(Unit.BytesUnit.B);
        
        // Then
        assert(b.bytes == bytes);
        assert(b.unit.to_string() == "B");
        assert(b.unit_value == bytes);
        
        // When
        var mb = b.to(Unit.BytesUnit.MB);
        
        // Then
        assert(mb.bytes == bytes);
        assert(mb.unit.to_string() == "MB");
        assert(mb.unit_value == 5800);

        // When
        var kb = mb.to(Unit.BytesUnit.KB);
        
        // Then
        assert(kb.bytes == bytes);
        assert(kb.unit.to_string() == "KB");
        assert(kb.unit_value == 5800000);

        // When
        var gb2 = kb.to(Unit.BytesUnit.GB);
        
        // Then
        assert(gb2.bytes == bytes);
        assert(gb2.unit.to_string() == "GB");
        assert(gb2.unit_value == 5.8f);
      }); 
}
