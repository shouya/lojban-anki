defmodule Gismu.Anki do
  def generate_deck(%{index: index} = db, template) do
    # header = template.generate_header()

    rest =
      index
      |> Enum.map(fn word ->
        detail = db.detail[word]
        template.generate_line(word, detail, db)
      end)
      |> Enum.reject(&is_nil/1)

    Enum.join(rest, "\n")
  end
end
