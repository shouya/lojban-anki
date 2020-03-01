defmodule Gismu.Database do
  @output "output/database.json"

  @index Gismu.Parser.Explanation
  @parsers [
    Gismu.Parser.Etymology,
    Gismu.Parser.SutysiskuExamples,
    Gismu.Parser.SutysiskuDefinition
  ]

  defstruct [:index, :detail]

  def create do
    index = Map.keys(@index.parse())

    %{
      index: index,
      detail: parse_detail(index)
    }
  end

  def parse_detail(index) do
    detail =
      @parsers
      |> Enum.map(fn mod -> mod.parse() end)
      |> Enum.reduce(&Map.merge(&1, &2, fn _, x, y -> Map.merge(x, y) end))

    Map.take(detail, index)
  end

  def save(db) do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@output)
    |> File.write(Jason.encode_to_iodata!(db))
  end
end
