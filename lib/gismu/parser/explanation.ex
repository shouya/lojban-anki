defmodule Gismu.Parser.Explanation do
  @explanation "resources/eng-gimste.tsv"

  def parse() do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@explanation)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.map(fn xs -> Enum.map(xs, &String.trim/1) end)
    |> Enum.flat_map(&parse_gismu/1)
    |> Map.new()
  end

  def parse_gismu([gismu, "gismu", _, _, _, explanation]) do
    [{gismu, %{explanation: escape_subscript(explanation)}}]
  end

  def parse_gismu([gismu, "gismu", _, _, _, explanation, notes]) do
    [{gismu, %{explanation: escape_subscript(explanation), notes: notes}}]
  end

  def parse_gismu(_), do: []

  def escape_subscript(text) do
    text
    |> String.replace("_1", "<sub>1</sub>")
    |> String.replace("_2", "<sub>2</sub>")
    |> String.replace("_3", "<sub>3</sub>")
    |> String.replace("_4", "<sub>4</sub>")
    |> String.replace("_5", "<sub>5</sub>")
  end
end
