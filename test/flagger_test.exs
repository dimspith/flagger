defmodule FlaggerTest do
  use ExUnit.Case
  doctest Flagger

  test "greets the world" do
    assert Flagger.hello() == :world
  end
end
