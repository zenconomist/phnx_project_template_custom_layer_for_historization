create table(:<%= schema.table %>) do
  <%= for {k, v} <- schema.types do %>add :<%= k %>, :<%= v %><%= schema.defaults[k] %>
  <% end %>
  timestamps_with_deleted_at()
end
