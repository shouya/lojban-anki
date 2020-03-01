defmodule Gismu.Parser.SutysiskuDefinition do
  @moduledoc false

  @data_file "resources/parsed-en.js"

  def parse do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@data_file)
    |> File.read()
    |> elem(1)
    |> String.trim_leading("sorcu[\"en\"] = ")
    |> String.trim_trailing(";\n")
    |> Jason.decode!()
    |> Map.new(&parse/1)
  end

  def parse({gismu, attrs}) do
    attrs =
      attrs
      |> Enum.map(&parse_attr/1)
      |> Enum.reject(&is_nil/1)

    {gismu, Map.new(attrs)}
  end

  def parse_attr({"d", d}) do
    {:defn, unescape(d)}
  end

  def parse_attr({"g", gloss}) do
    {:gloss, gloss}
  end

  def parse_attr({"t", selmaho}) do
    {:selmaho, selmaho}
  end

  def parse_attr({"r", rafsi}) do
    {:rafsi, rafsi}
  end

  def parse_attr({_, _}) do
    nil
  end

  def unescape(str) do
    str
    |> String.replace("_{1}", "<sub>1</sub>")
    |> String.replace("_{2}", "<sub>2</sub>")
    |> String.replace("_{3}", "<sub>3</sub>")
    |> String.replace("_{4}", "<sub>4</sub>")
    |> String.replace("_{5}", "<sub>5</sub>")
    |> String.replace("_1", "<sub>1</sub>")
    |> String.replace("_2", "<sub>2</sub>")
    |> String.replace("_3", "<sub>3</sub>")
    |> String.replace("_4", "<sub>4</sub>")
    |> String.replace("_5", "<sub>5</sub>")
    |> String.replace(~r/\bx1\b/, "x<sub>1</sub>")
    |> String.replace(~r/\bx2\b/, "x<sub>2</sub>")
    |> String.replace(~r/\bx3\b/, "x<sub>3</sub>")
    |> String.replace(~r/\bx4\b/, "x<sub>4</sub>")
    |> String.replace(~r/\bx5\b/, "x<sub>5</sub>")
    |> String.replace(~r/\(([^\)]+)\)/, "<span class=\"word-kind\">(\\g{1})</font>")
    |> String.replace("$", "")
  end
end
