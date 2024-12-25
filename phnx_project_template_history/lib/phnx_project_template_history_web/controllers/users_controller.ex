defmodule PhnxProjectTemplateHistoryWeb.UsersController do
  use PhnxProjectTemplateHistoryWeb, :controller

  alias PhnxProjectTemplateHistory.User
  alias PhnxProjectTemplateHistory.User.Users

  def index(conn, _params) do
    users = User.list_users()
    render(conn, :index, users_collection: users)
  end

  def new(conn, _params) do
    changeset = User.change_users(%Users{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"users" => users_params}) do
    case User.create_users(users_params) do
      {:ok, users} ->
        conn
        |> put_flash(:info, "Users created successfully.")
        |> redirect(to: ~p"/users/#{users}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    users = User.get_users!(id)
    render(conn, :show, users: users)
  end

  def edit(conn, %{"id" => id}) do
    users = User.get_users!(id)
    changeset = User.change_users(users)
    render(conn, :edit, users: users, changeset: changeset)
  end

  def update(conn, %{"id" => id, "users" => users_params}) do
    users = User.get_users!(id)

    case User.update_users(users, users_params) do
      {:ok, users} ->
        conn
        |> put_flash(:info, "Users updated successfully.")
        |> redirect(to: ~p"/users/#{users}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, users: users, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    users = User.get_users!(id)
    {:ok, _users} = User.delete_users(users)

    conn
    |> put_flash(:info, "Users deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
