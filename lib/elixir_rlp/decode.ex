defmodule ElixirRlp.Decode do

    @moduledoc """
       Elixir implementation of RLP decoding with the help of some code reference from @girishramnani implementation,
       Check out this medium article for reference
       https://medium.com/coinmonks/ethereum-under-the-hood-part-ii-i-933411deebe1

    """
   #defined by RLP
    @list 0xc0
    @long_list 0xf7
    @string 0x80
    @long_string 0xb7
    @int_zero 0x80
    @reconstruct ""
    @decoded_list []

    #Empty defs
    def decode(0xc0)  do
         []
    end

    def decode(0x80)  do
       @string
    end

    def decode(0)  do
       <<@int_zero>>
    end

    def decode([])  do
       <<@list>>
    end

   # <<147, 65, 32, 115, 109, 97, 108, 108, 32, 115, 116, 114, 105, 110, 103, 32,
   # 104, 101, 114, 101>>
   # "A small string here"

   #<<203, 131, 97, 98, 99, 1, 130, 3, 219, 100, 111, 103>>
   #["abc", 1, 987, "d", "o", "g"]

   def decode(payload) when is_binary(payload) do

      # Convert to list
        payload_list = payload |> :binary.bin_to_list

        [ h | t] = payload_list
                     |> Enum.map(fn(p) -> decode( <<p>>, payload) end )

        to_char_list(Enum.join(t))


   end


    def decode( <<first_byte, _::binary>> = payload,encoded_payload) when is_binary(payload) do

        next_data =
          
            cond do

              Enum.member?(0..127, first_byte)   ->  <<first_byte>>

              Enum.member?(128..183, first_byte) ->   len = first_byte - 80
                                                      decoded_data = Enum.take(:binary.bin_to_list(payload),-len)

              Enum.member?(184..191, first_byte) ->   len = first_byte - 184
                                                      decoded_data = Enum.take(:binary.bin_to_list(payload),-len)

              Enum.member?(192..247, first_byte) ->   len = first_byte - 192
                                                      decoded_data = Enum.take(:binary.bin_to_list(payload), -len)

              Enum.member?(248..255, first_byte) ->   len = first_byte - 248
                                                      decoded_data = Enum.take(:binary.bin_to_list(payload), -len)

           end

    end


end
