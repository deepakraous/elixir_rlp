defmodule ElixirRlpTest do
  use ExUnit.Case
  doctest ElixirRlp


    test "encode empty items" do
        assert ElixirRlp.Encode.encode("") == <<0x80>>
        assert ElixirRlp.Encode.encode([]) == <<0xc0>>
        assert ElixirRlp.Encode.encode(0) == <<0x80>>
    end


    test "encode a single byte alphabet" do
           assert ElixirRlp.Encode.encode("a") == "a"
    end

    test "encode a single byte number" do
         assert ElixirRlp.Encode.encode(2) == <<2>>
    end

    test "encode a number" do
         assert ElixirRlp.Encode.encode(978) == <<130, 3, 210>>
    end

    test "encode small arrays " do
         assert ElixirRlp.Encode.encode( ["cat", "dog"] ) == <<200, 131, 99, 97, 116, 131, 100, 111, 103>>
    end

    test "encode large arrays " do

         large_array =  ["this is a very long list", "you never guess how long it is", "indeed, how did you know it was this long", "good job, that I can tell you in honestlyyyyy"]
         encoded_array = <<248, 144, 152, 116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 32, 108, 105, 115, 116, 158, 121, 111, 117, 32,
                           110, 101, 118, 101, 114, 32, 103, 117, 101, 115, 115, 32, 104, 111, 119, 32, 108, 111, 110,
                           103, 32, 105, 116, 32, 105, 115, 169, 105, 110, 100, 101, 101, 100, 44, 32, 104, 111, 119, 32,
                           100, 105, 100, 32, 121, 111, 117, 32, 107, 110, 111, 119, 32, 105, 116, 32, 119, 97, 115, 32, 116, 104,
                           105, 115, 32, 108, 111, 110, 103, 173, 103, 111, 111, 100, 32, 106, 111, 98, 44, 32, 116, 104, 97, 116, 32,
                           73, 32, 99, 97, 110, 32, 116, 101, 108, 108, 32, 121, 111, 117, 32, 105, 110, 32, 104, 111, 110, 101, 115, 116,
                           108, 121, 121, 121, 121, 121>>

         assert ElixirRlp.Encode.encode(large_array) == encoded_array

    end

    test "mixer of items in list" do

      mix_list = [123, ["cat", "dog"], 'd', [ [ ] ] , 1024, 0 ]
      assert ElixirRlp.Encode.encode(mix_list) == <<210, 123, 200, 131, 99, 97, 116, 131, 100, 111, 103, 193, 100, 193, 192, 130,
                                                 4, 0, 128>>

    end

end
