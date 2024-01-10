defmodule MissionCommandTest do
  use ExUnit.Case
  doctest MissionCommand

  test "greets the world" do
    assert MissionCommand.hello() == :world
  end
end
