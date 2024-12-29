
  alias <%= inspect schema.module %>
  alias <%= inspect schema.module %>FieldLog
  alias <%= inspect schema.module %>History

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
        old_record = %<%= inspect schema.alias %>{}

        %<%= inspect schema.alias %>{}
        |> <%= inspect schema.alias %>.changeset(attrs)
        |> Repo.insert!()
        |> log_changes(old_record, :create)
        |> scd2_historize(:create)
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
    %<%= inspect schema.alias %>{id: id} = <%= schema.singular %>
    old_record = get_<%= schema.singular %>!(id)

    <%= schema.singular %>
    |> <%= inspect schema.alias %>.changeset(attrs)
    |> Repo.update()
    |> log_changes(old_record, :update)
    |> scd2_historize(:update)
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
    old_record = %<%= inspect schema.alias %>{}

    # repo update the record's deleted_at field to the current time
    <%= schema.singular %>
    |> <%= inspect schema.alias %>.changeset(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
    |> log_changes(old_record, :delete)
    |> scd2_historize(:delete)

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
  defp log_changes(record, old_record, action) do
    case action do
      :create ->
        old_record = %<%= inspect schema.alias %>{}
        record
        |> track_record_changes(old_record)
        |> create_change_log(record, action)
        # |> Logger.info("Created <%= schema.singular %>: #{inspect record}")
      :update ->
        record
        |> track_record_changes(old_record)
        |> create_change_log(record, action)
        # |> Logger.info("Updated <%= schema.singular %>: #{inspect record}")
      :delete ->
        %{}
        |> create_change_log(record, action)
        # Logger.info("Deleted <%= schema.singular %>: #{inspect record}")
    end
    record
  end

    defp track_record_changes(record, old_record, changes \\ %{}) do
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
      changes
    end


    defp create_change_log(changes, record, action) do
      cond do
        changes == %{} ->
          IO.puts("No changes to log")
        true ->
          attrs =
            case action do
              :create ->
                Enum.map(changes, fn {key, value} ->
                  {old_val, new_val} = value
                  %{
                    table_name: "<%= schema.table %>",
                    row_id: Map.get(record, :id),
                    action: Atom.to_string(action),
                    field_name: key,
                    old_value: old_val,
                    new_value: new_val,
                    time_of_change: DateTime.utc_now(),
                    changed_by: "system"
                  }
                end) |> log_changes_in_repo()
              :update ->
                {:ok, new_record} = record
                Enum.map(changes, fn {key, value} ->
                  {old_val, new_val} = value
                  %{
                    table_name: "<%= schema.table %>",
                    row_id: Map.get(new_record, :id),
                    action: Atom.to_string(action),
                    field_name: key,
                    old_value: old_val,
                    new_value: new_val,
                    time_of_change: DateTime.utc_now(),
                    changed_by: "system"
                  }
                end) |> log_changes_in_repo()
              :delete ->
                {:ok, new_record} = record
                %{
                  table_name: "<%= schema.table %>",
                  row_id: Map.get(new_record, :id),
                  action: Atom.to_string(action),
                  field_name: nil,
                  old_value: nil,
                  new_value: nil,
                  time_of_change: DateTime.utc_now(),
                  changed_by: "system"
                } |> log_changes_in_repo()
            end # end of case action
      end # end of cond
          record
    end

    defp log_changes_in_repo(attrs) do
      %<%= inspect schema.alias %>FieldLog{}
      |> <%= inspect schema.alias %>FieldLog.changeset(attrs)
      |> Repo.insert()
    end

  defp scd2_historize(record, action) do
    # Implement logic to insert into SCD2 history table
    record
  end
