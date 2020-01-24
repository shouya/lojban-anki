# Gismu

Generate an Anki deck for Lojban gismu.

A sample shared deck (gismu with etymology) can be found here: <https://ankiweb.net/shared/info/792471711>.

## How it works

The way it works is to integrate various resources (`Parser.*`) to build a
database indexed by gismu words (`Database`). The next thing is to generate anki
deck using these words. Each card is generated through a template
(`Anki.Template`) which contains EEx templates for the front and the back of the
card. The generated content will be stored in a ".tsv" file, which can be then
imported via Anki desktop client.

## Installation and Usage

You need to have Elixir installed, then run the following command under the project's directory.

    mix run -e "Gismu.generate_anki(:with_etymology)"

`:with_etymology` is a predefined tempalate. If you want to customize the front and back of the cards, you can write your own preset like `lib/gismu.ex:5`.

## Copyright

Copyright 2020 Shou Ya

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
