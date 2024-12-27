# test_schema.exs
defmodule TestSchema do
#   use Ecto.Schema
#   import Ecto.Changeset

  def run do
    # Define a mock schema
    schema = %{
      module: MyApp.MySchema,
      prefix: nil,
      binary_id: false,
      table: "my_table",
      attrs: [name: :string, age: :integer],
      uniques: [:name],
      assocs: [ {:has_many, :comments, MyApp.Comment, []} ]
    }

    # <%= Mix.Phoenix.Schema.format_fields_for_schema(schema) %>

    #IO.inspect(Mix.Phoenix.Schema.format_fields_for_schema(schema))
    IO.inspect(schema)

    schema.attrs
    |> Enum.each(fn attrs ->
                    IO.inspect(attrs)
                    
                end)

    # Define the template
    template = """
    <%= for {_, k, _, _} <- schema.attrs do %>    field <%= inspect k %>, <%= if schema.binary_id do %>:binary_id<% else %>:id<% end %>
    <% end %>
    """

    # Render the template
    result = EEx.eval_string(template, schema: schema)

    # Print the result
    IO.puts(result)
  end
end

# Run the test
TestSchema.run()