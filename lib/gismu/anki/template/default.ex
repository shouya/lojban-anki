defmodule Gismu.Anki.Template.Default do
  @moduledoc false

  @behaviour Gismu.Anki.Template

  @fields [
    :front,
    :gloss,
    :selmaho,
    :definition,
    :etymology,
    :example_1,
    :example_2,
    :related,
    :rafsi
  ]

  @impl true
  def generate_header do
    @fields
    |> Enum.map(fn k -> String.capitalize(to_string(k)) end)
    |> Enum.join("\t")
  end

  @impl true
  def generate_line(word, detail, db) do
    @fields
    |> Enum.map(fn f -> generate_field(f, word, detail, db) end)
    |> Enum.map(fn
      nil -> ""
      f -> f
    end)
    |> Enum.map(fn t -> String.replace(t, "\t", " ") end)
    |> Enum.join("\t")
  end

  def generate_field(:front, word, _, _), do: word
  def generate_field(:gloss, _, detail, _), do: detail[:gloss]
  def generate_field(:selmaho, _, detail, _), do: detail[:selmaho]
  def generate_field(:definition, _, detail, _), do: detail[:defn]

  def generate_field(:etymology, _, detail, _) do
    case detail[:etymology] do
      nil ->
        nil

      items ->
        items
        |> Enum.map(fn {lang, w} ->
          [
            "<span class=\"etymology-item\">",
            ["<span class=\"etymology-source-word\">", w, "</span>"],
            ["(<span class=\"etymology-lang\">", to_string(lang), "</span>)"],
            "</span>"
          ]
          |> :erlang.iolist_to_binary()
        end)
        |> Enum.join(", ")
    end
  end

  def generate_field(:example_1, _, detail, _), do: get_example_field(detail, 0)
  def generate_field(:example_2, _, detail, _), do: get_example_field(detail, 1)

  def generate_field(:related, _, %{related: related}, db) do
    related
    |> Enum.map(fn jbo ->
      case get_in(db, [Access.key(:detail), jbo, :gloss]) do
        nil ->
          "<span class=\"lojban-word\">#{jbo}</span>"

        gloss ->
          "<span class=\"lojban-word\">#{jbo}</span> (<span class=\"gloss\">#{gloss}</span>)"
      end
    end)
    |> Enum.join(", ")
  end

  def generate_field(:rafsi, _, %{rafsi: list}, _) do
    list
    |> Enum.map(fn r -> "<span class=\"rafsi\">#{r}</span>" end)
    |> Enum.join("/")
  end

  def generate_field(_, _, _, _), do: nil

  defp get_example_field(detail, n) do
    case Enum.drop(detail[:examples] || [], n) do
      [{jbo, eng}|_] ->
        [
          "<span class=\"example-jbo\">#{jbo}</span>",
          "<span class=\"example-eng\">#{eng}</span>"
        ]
        |> Enum.join(" - ")

      _ ->
        nil
    end
  end
end
