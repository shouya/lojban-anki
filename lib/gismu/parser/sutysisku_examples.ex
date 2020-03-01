defmodule Gismu.Parser.SutysiskuExamples do
  @moduledoc false

  @data_file "resources/parsed-jb.js"

  def parse do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@data_file)
    |> File.read()
    |> elem(1)
    |> String.trim_leading("sorcu[\"jb\"] = ")
    |> String.trim_trailing(";\n")
    |> Jason.decode!()
    |> Map.new(&parse_word/1)
  end

  def parse_word({gismu, attrs}) do
    attrs =
      attrs
      |> Enum.map(&parse_attr/1)
      |> Enum.reject(&is_nil/1)

    {gismu, Map.new(attrs)}
  end

  def parse_attr({"e", e}) do
    examples =
      e
      |> String.split("%")
      |> Enum.map(&String.split(&1, " — "))
      |> Enum.map(fn [loj, eng] -> {String.trim_leading(loj, "i "), eng}
      _ -> nil
    end)
      |> Enum.reject(&is_nil/1)

    {:examples, examples}
  end

  def parse_attr({"n", note}) do
    {:note, note}
  end

  def parse_attr({"k", related}) do
    words =
      ~r/{[^}]+}/
      |> Regex.scan(related)
      |> Enum.map(fn [x] -> String.trim(String.trim(x, "{"), "}") end)

    {:related, words}
  end

  def parse_attr({_, _}), do: nil

  def unescape(str) do
    str
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
    |> String.replace(~r/\(([^\)+])\)/, "<font color=\"#1e4034\">(\1)</font>")
    |> String.replace("$", "")
  end
end
