defmodule Gismu.Database do
  @output "output/database.json"
  @parsers [
    Gismu.Parser.Etymology,
    Gismu.Parser.Explanation
  ]

  def from_parsers do
    @parsers
    |> Enum.map(fn mod -> mod.parse() end)
    |> Enum.reduce(&Map.merge(&1, &2, fn _, x, y -> Map.merge(x, y) end))
  end

  def save(db) do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@output)
    |> File.write(Jason.encode_to_iodata!(db))
  end
end
