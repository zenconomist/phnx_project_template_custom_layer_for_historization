defmodule PhnxProjectTemplateHistory.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhnxProjectTemplateHistory.User` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password",
        username: "some username"
      })
      |> PhnxProjectTemplateHistory.User.create_users()

    users
  end
end
