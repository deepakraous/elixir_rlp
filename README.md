# ElixirRlp

- Reference: https://github.com/ethereum/wiki/wiki/RLP
- Code Snippets for encode: @girishramnani

**Updates:**
- Updated Decode Skeleton
- Beautified Encode/Decode
- Updated Readme.md

**ToDos:**
- Wrap up decode
- Add unit tests for decode


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_rlp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_rlp, "~> 0.1.0"}
  ]
end
```
# Run it from iex
iex> mixer_list = ["abc", 1, 987, "d", "o", "g" ]
["abc", 1, 987, "d", "o", "g"]
iex> mixer_list |> ElixirRlp.Encode.encode
<<203, 131, 97, 98, 99, 1, 130, 3, 219, 100, 111, 103>>

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_rlp](https://hexdocs.pm/elixir_rlp).
