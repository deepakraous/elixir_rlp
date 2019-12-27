defmodule ElixirRlp.Encode do

    @moduledoc """
       Elixir implementation of RLP encoding with the help of some code reference from @girishramnani implementation,
       Check out this medium article for reference
       https://medium.com/coinmonks/ethereum-under-the-hood-part-ii-i-933411deebe1

    """

   #As defined by RLP
    @list 0xc0
    @long_list 0xf7
    @string 0x80
    @long_string 0xb8
    @int_zero 0x80

    #Empty defs
    def encode("")  do
       <<@string>>
    end

    def encode([])  do
       <<@list>>
    end

    def encode(0)  do
       <<@int_zero>>
    end

    #Max List
    def encode(payload) when is_list(payload) and length(payload) > 1024 do
        "Payload size maxed out, size should <=1024"
    end

    @doc """
       Encode for small and big list function

       ## Examples

      iex> mixer_list = ["abc", 1, 987, "d", "o", "g" ]
      ["abc", 1, 987, "d", "o", "g"]
      iex> mixer_list |> ElixirRlp.Encode.encode
      <<203, 131, 97, 98, 99, 1, 130, 3, 219, 100, 111, 103>>
    """
    def encode( payload ) when is_list(payload) do

        bytes = payload |> Enum.map(fn p->encode(p) end)
                        |> Enum.reverse
                        |> (Enum.reduce (fn (l,r) -> l <> r end))

       #Finaly call list
       list_encode(bytes,payload)

    end

    @doc """
       #Code snipppet from @girishramnani

       Encode for payload within the string and various conditons

       ## Examples

       iex> s_string = "A small string here"
       "A small string here"
       iex> s_string |> ElixirRlp.Encode.encode
       <<147, 65, 32, 115, 109, 97, 108, 108, 32, 115, 116, 114, 105, 110, 103, 32,
        104, 101, 114, 101>>

    """
    def encode(<<byte, _::binary>> = payload) when is_binary(payload) do

        cond do

            ( byte_size(payload ) == 1  ) && Enum.member?(0x00..0x7f,byte) -> <<byte>>
            ( byte_size(payload ) <= 55 ) ->  << @string + byte_size(payload) >> <> payload
            ( byte_size(payload ) > 55  ) ->
                                       first_byte = payload
                                                    |> int_to_binary
                                                    |> byte_size
                                    <<@long_string + byte_size(first_byte) >> <> payload
         end

    end

    #Encode for Number
    def encode(payload) when is_number(payload) do

        encoded_number = int_to_binary(payload)
        cond do
         (byte_size(encoded_number) == 1)  -> encoded_number
         (byte_size(encoded_number) > 1 )  -> <<@int_zero + byte_size(encoded_number)>> <> encoded_number

        end

    end

      #Encode for Number
      #Code snipppet from @girishramnani
      defp int_to_binary(number) do

          number
              |> Integer.digits(256)
              |> Enum.reduce(<<>>,
                fn (number,binary) -> binary <> <<number>> end
               )

      end

      #Short list
      defp list_encode(encoded_string, _payload) when byte_size(encoded_string) <= 55 do
          <<@list + byte_size(encoded_string ) >> <> encoded_string
      end

      #Long list
      defp list_encode(encoded_string, payload) when byte_size(encoded_string) >55 do

          bytes_size = payload
                  |>length
                  |>int_to_binary
                  |>byte_size

          <<@long_list + bytes_size >> <> encoded_string

      end
      
       # Binary to Base16
      def binary_to_Base16(binary) do
        binary |> Base.encode16
      end

end
