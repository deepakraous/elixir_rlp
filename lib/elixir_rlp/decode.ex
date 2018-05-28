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


   def decode( <<first_byte, _::binary>> = payload ) when is_binary(payload) do

        payload_list = payload |> :binary.bin_to_list
        decode_data = decode(payload_list);

   end

   # decode(binary) -> {parsed, binary = rest}
   #    if list => decode_list([], size, binary)

   # ##decode_list(list_so_far, size, binary = rest)
   # decode_list(list_so_far, size = 0, rest) -> {list_so_far, rest}

   # decode_list(list_so_far, size , binary) ->
   #    {res, rest} -> decode(binary)
   #    return decode_list(list_so_far ++ [res], size - 1,  rest)

   #<<203, 131, 97, 98, 99, 1, 130, 3, 219, 100, 111, 103>>
   #["abc", 1, 987, "d", "o", "g"]

  def decode( [first_byte | rest_of_list] = payload ) when is_list(payload) do

        decode_data =

            cond do

              Enum.member?(0..127, first_byte)   ->   first_byte

              Enum.member?(128..183, first_byte) ->   size = first_byte - 80
                                                      decoded_data = Enum.take(rest_of_list, -size)

              Enum.member?(184..191, first_byte) ->   size = first_byte - 184
                                                      decoded_data = Enum.take(rest_of_list, -size)

              Enum.member?(192..247, first_byte) ->   size = first_byte - 192
                                                      decoded_list = Enum.take(rest_of_list, -size)
                                                      nxt = decode_list(payload,
                                                                  first_byte, size, decoded_list)
                                                      decode(nxt)

              Enum.member?(248..255, first_byte) ->   size = first_byte - 248
                                                      decoded_list = Enum.take(rest_of_list, -size)
                                                      nxt = decode_list(payload,
                                                                  first_byte, size, decoded_list)
                                                      decode(nxt)

           end

  end


    defp decode_list( payload, first_byte, size, decoded_list ) when size != 0 do

      next_to_decode =  payload -- [first_byte]
      size = length(next_to_decode)
      @decoded_list ++ next_to_decode

    end

end
