
  alias <%= inspect schema.module %>

  @doc """
  Returns the list of <%= schema.plural %>.

  ## Examples

      iex> list_<%= schema.plural %>()
      [%<%= inspect schema.alias %>{}, ...]

  """
  def list_<%= schema.plural %> do
    Repo.all(from s in <%= inspect schema.alias %>, where: is_nil(s.deleted_at))
  end

  @doc """
  Gets a single <%= schema.singular %>.

  Raises `Ecto.NoResultsError` if the <%= schema.human_singular %> does not exist.

  ## Examples

      iex> get_<%= schema.singular %>!(123)
      %<%= inspect schema.alias %>{}

      iex> get_<%= schema.singular %>!(456)
      ** (Ecto.NoResultsError)

  """
  def get_<%= schema.singular %>!(id) do
    Repo.one!(from s in <%= inspect schema.alias %>, where: s.id == ^id and is_nil(s.deleted_at))
  end

  @doc """
  Creates a <%= schema.singular %>.

  ## Examples

      iex> create_<%= schema.singular %>(%{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> create_<%= schema.singular %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
    def create_<%= schema.singular %>(attrs \\ %{}) do
        %<%= inspect schema.alias %>{}
        |> <%= inspect schema.alias %>.changeset(attrs)
        |> Repo.insert!()
        |> log_changes(attrs, :create)
        |> insert_scd2_version()
    end

  @doc """
  Updates a <%= schema.singular %>.

  ## Examples

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
    <%= schema.singular %>
    |> <%= inspect schema.alias %>.changeset(attrs)
    |> Repo.update()
    |> log_changes(attrs, :update)
    |> mark_scd2_inactive()
    |> insert_scd2_version()
  end

  @doc """
  Deletes a <%= schema.singular %>.

  ## Examples

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:error, %Ecto.Changeset{}}

  """
  def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
    # repo update the record's deleted_at field to the current time
    <%= schema.singular %>
    |> <%= inspect schema.alias %>.changeset(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
    |> mark_scd2_inactive()

  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> change_<%= schema.singular %>(<%= schema.singular %>)
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{}}

  """
  def change_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs \\ %{}) do
    <%= inspect schema.alias %>.changeset(<%= schema.singular %>, attrs)
  end

  ## this needs refactoring -> if create and delete, only log action, and on create, the new values, on delete, only log the action.
  defp log_changes(record, old_record, attrs, action) do
    cond do
      action == :create -> record = log_create(record, action)
      action == :update -> record = log_update(record, old_record, action)
      action == :delete -> record = log_delete(record, action)
    end
    record
  end

    defp record_changes(record, old_record, changes \\ []) do
      changes = %{}
        <%= for {field, _type} <- schema.attrs do %>
            old_value = Map.get(old_record, <%= inspect field %>)
            new_value = Map.get(record, <%= inspect field %>)
            # update changes if not equal, else no update
            changes =
              cond do
                old_value != new_value ->
                  Map.put(changes, {<%= inspect Atom.to_string(field) %>, {"old value: #{old_value}", "new_value: #{new_value}"}})
                true ->
                  changes
              end
        <% end %>
    end



  defp insert_scd2_version(record) do
    # Implement logic to insert into SCD2 history table
    record
  end

  defp mark_scd2_inactive(record) do
    # Implement logic to mark SCD2 record as inactive
    record
  end