defmodule ScramjetTest do
  use ExUnit.Case
  doctest Scramjet

  test "greets the world" do
    assert Scramjet.hello() == :world
  end
end
