def list_<%= schema.plural %> do
  PhnxProjectTemplateHistory.ServiceLayer.get_all(<%= inspect schema.module %>)
end

def get_<%= schema.singular %>!(id) do
  PhnxProjectTemplateHistory.ServiceLayer.get!(<%= inspect schema.module %>, id)
end

def create_<%= schema.singular %>(attrs \\ %{}) do
  PhnxProjectTemplateHistory.ServiceLayer.create(<%= inspect schema.module %>, attrs)
end

def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
  PhnxProjectTemplateHistory.ServiceLayer.update(<%= schema.singular %>, attrs)
end

def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
  PhnxProjectTemplateHistory.ServiceLayer.delete(<%= schema.singular %>)
end