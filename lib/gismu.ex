defmodule Gismu do
  alias Gismu.Database
  alias Gismu.Anki
  alias Gismu.Anki.Template

  def main do
    db = Database.create()
    content = Anki.generate_deck(db, Template.Default)
    File.write!("anki-deck-lojban.tsv", content)
  end
end
