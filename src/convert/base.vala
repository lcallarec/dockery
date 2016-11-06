//Proudly talken from github's tiliado/diorite project @ https://github.com/tiliado/diorite/blob/07af3ce59da4d40b268feee01be5b8ffedd76cd1/src/glib/Convert.vala
/*
 * Copyright 2015 Jiří Janoušek <janousek.jiri@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

namespace Dockery.Convert.Base
{

    /**
     * Convert int64 value to byte array
     *
     * @param val       value to convert
     * @param result    byte array representation (8 bytes)
     */
    public void int64_to_bin(int64 val, out uint8[] result)
    {
        var size = (int) sizeof(int64);
        result = new uint8[size];
        for (int i = size - 1; i >= 0; i--)
        {
            result[i] = (uint8)(val & 0xFF);
            val >>= 8;
        }
    }

    /**
     * Converts byte array to int64 value
     *
     * @param val       byte array to convert
     * @param result    converted value
     * @return          true on success, false on overflow
     */
    public bool bin_to_int64(uint8[] array, out int64 result)
    {
        result = 0;
        if (array.length > sizeof(int64))
            return false;

        for (int i = 0; i < array.length; i++)
        {
            result <<= 8;
            result |= (int64)(array[i] & 0xFF);
        }
        return true;
    }

    /**
     * Converts byte array to hexadecimal string.
     *
     * @param array        byte array to convert
     * @param result       converted value
     * @param separator    separator of hexadecimal pairs ('\0' for none)
     */
    public void bin_to_hex(uint8[] array, out string result, char separator='\0')
    {
        var size = separator == '\0' ? 2 * array.length : 3 * array.length - 1;
        var buffer = new StringBuilder.sized(size);
        bin_to_hex_buf(array, buffer, separator);
        result = buffer.str;
    }

    /**
     * Converts byte array to hexadecimal string and stores in buffer.
     *
     * @param array        byte array to convert
     * @param buffer       where to store converted value in
     * @param separator    separator of hexadecimal pairs ('\0' for none)
     */
    public void bin_to_hex_buf(uint8[] array, StringBuilder buffer, char separator='\0')
    {
        string hex_chars = "0123456789abcdef";
        for (var i = 0; i < array.length; i++)
        {
            if (i > 0 && separator != '\0')
                buffer.append_c(separator);
            buffer.append_c(hex_chars[(array[i] >> 4) & 0x0F]).append_c(hex_chars[array[i] & 0x0F]);
        }
    }

    public bool uint8v_equal(uint8[] array1, uint8[] array2)
    {
        if (array1.length != array2.length)
            return false;
        for (var i = 0; i < array1.length; i++)
            if (array1[i] != array2[i])
                return false;
        return true;
    }

    /**
     * Converts hexadecimal string to byte array
     *
     * @param array        hexadecimal string to convert
     * @param result       byte array
     * @param separator    separator of hexadecimal pairs ('\0' for none)
     * @return             true on success, false on failure (invalid input)
     */
    public bool hex_to_bin(string hex, out uint8[] result, char separator='\0')
    {
        result = null;
        unowned uint8[] hex_data = (uint8[]) hex;
        hex_data.length = hex.length;
        return_val_if_fail(hex != null && hex_data.length > 0, false);

        int size = hex_data.length;
        if (separator != '\0')
        {
            // "aa:bb:cc" -> 8 chars, 3 bytes
            size++;
            return_val_if_fail(size % 3 == 0, false);
            size /= 3;
        }
        else
        {
            // "aabbcc" -> 6 chars, 3 bytes
            return_val_if_fail(size % 2 == 0, false);
            size /= 2;
        }

        result = new uint8[size];
        uint8 c;
        uint8 j;
        for (int i = 0, pos = 0; (c = hex_data[pos++]) != 0 && i < 2 * size; i++)
        {
            if (c == separator)
            {
                i--;
                continue;
            }

            switch (c)
            {
                 case '0': j = 0; break;
                 case '1': j = 1; break;
                 case '2': j = 2; break;
                 case '3': j = 3; break;
                 case '4': j = 4; break;
                 case '5': j = 5; break;
                 case '6': j = 6; break;
                 case '7': j = 7; break;
                 case '8': j = 8; break;
                 case '9': j = 9; break;
                 case 'A': j = 10; break;
                 case 'B': j = 11; break;
                 case 'C': j = 12; break;
                 case 'D': j = 13; break;
                 case 'E': j = 14; break;
                 case 'F': j = 15; break;
                 case 'a': j = 10; break;
                 case 'b': j = 11; break;
                 case 'c': j = 12; break;
                 case 'd': j = 13; break;
                 case 'e': j = 14; break;
                 case 'f': j = 15; break;
                 default:
                    return false;
            }

            if (i % 2 == 0)
                result[i/2] += (j << 4);
            else
                result[i/2] += j;
        }
        return true;
    }

    /**
     * Converts hexadecimal string to int64 value
     *
     * @param array        hexadecimal string to convert
     * @param result       converted value
     * @param separator    separator of hexadecimal pairs ('\0' for none)
     * @return             true on success, false on failure (invalid input, overflow)
     */
    public bool hex_to_int64(string hex, out int64 result, char separator='\0')
    {
        uint8[] data;
        return_val_if_fail(hex_to_bin(hex, out data, separator), false);
        return_val_if_fail(bin_to_int64(data, out result), false);
        return true;
    }

    /**
     * Converts int64 value to hexadecimal string.
     *
     * @param array        value to convert
     * @param result       converted value
     * @param separator    separator of hexadecimal pairs ('\0' for none)
     */
    public void int64_to_hex(int64 val, out string result, char separator='\0')
    {
        uint8[] data;
        int64_to_bin(val, out data);
        bin_to_hex(data, out result, separator);
    }

    /**
     * Converts uint32 value to bytes
     *
     * @param buffer    buffer of size at least `sizeof(uint32)` where the result will be stored
     * @param data      uint32 value to convert
     * @param offset    offset of the buffer where the result will be stored
     */
    public void uint32_to_bytes(ref uint8[] buffer, uint32 data, uint offset=0)
    {
        var size = sizeof(uint32);
        assert(buffer.length >= offset + size);
        for (var i = 0; i < size; i ++)
            buffer[offset + i] = (uint8)((data >> ((size - 1 - i) * 8)) & 0xFF);
    }

    /**
     * Converts int32 value to bytes
     *
     * @param buffer    buffer of size at least `sizeof(int32)` where the result will be stored
     * @param data      int32 value to convert
     * @param offset    offset of the buffer where the result will be stored
     */
    public void int32_to_bytes(ref uint8[] buffer, int32 data, uint offset=0)
    {
        var size = sizeof(int32);
        assert(buffer.length >= offset + size);
        for (var i = 0; i < size; i ++)
            buffer[offset + i] = (uint8)((data >> ((size - 1 - i) * 8)) & 0xFF);
    }

    /**
     * Converts bytes to uint32 value
     *
     * @param buffer    buffer that contains the uint32 value
     * @param data      where the uint32 value will be stored
     * @param offset    offset of the buffer where the uint32 value is located
     */
    public void uint32_from_bytes(uint8[] buffer, out uint32 data, uint offset=0)
    {
        var size = sizeof(uint32);
        assert(buffer.length >= offset + size);
        data = 0;
        for (var i = 0; i < size; i ++)
            data += buffer[offset + i] * (1 << ((uint32)size - 1 - i) * 8);
    }

    /**
     * Converts bytes to int32 value
     *
     * @param buffer    buffer that contains the int32 value
     * @param data      where the int32 value will be stored
     * @param offset    offset of the buffer where the int32 value is located
     */
    public void int32_from_bytes(uint8[] buffer, out int32 data, uint offset=0)
    {
        var size = sizeof(int32);
        assert(buffer.length >= offset + size);
        data = 0;
        for (var i = 0; i < size; i ++)
            data += buffer[offset + i] * (1 << ((int32)size - 1 - i) * 8);
    }

}
