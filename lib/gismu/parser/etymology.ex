defmodule Gismu.Parser.Etymology do
  @etymology_file "resources/etymology.icg"

  def parse do
    :gismu
    |> :code.priv_dir()
    |> Path.join(@etymology_file)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_every(8)
    |> Enum.map(&parse_gismu/1)
    |> Map.new()
  end

  def parse_gismu(["item" <> _, jbo, zh, en, hi, es, ru, ar]) do
    {jbo, %{etymology: %{zh: zh, en: en, hi: hi, es: es, ru: ru, ar: ar}}}
  end
end
