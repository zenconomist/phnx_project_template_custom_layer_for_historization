defmodule PhnxProjectTemplateHistory.UserTest do
  use PhnxProjectTemplateHistory.DataCase

  alias PhnxProjectTemplateHistory.User

  describe "users" do
    alias PhnxProjectTemplateHistory.User.Users

    import PhnxProjectTemplateHistory.UserFixtures

    @invalid_attrs %{username: nil, password: nil, email: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert User.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert User.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{username: "some username", password: "some password", email: "some email"}

      assert {:ok, %Users{} = users} = User.create_users(valid_attrs)
      assert users.username == "some username"
      assert users.password == "some password"
      assert users.email == "some email"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{username: "some updated username", password: "some updated password", email: "some updated email"}

      assert {:ok, %Users{} = users} = User.update_users(users, update_attrs)
      assert users.username == "some updated username"
      assert users.password == "some updated password"
      assert users.email == "some updated email"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_users(users, @invalid_attrs)
      assert users == User.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = User.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> User.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = User.change_users(users)
    end
  end
end
