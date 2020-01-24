defmodule GismuTest do
  use ExUnit.Case
  doctest Gismu

  test "greets the world" do
    assert Gismu.hello() == :world
  end
end
