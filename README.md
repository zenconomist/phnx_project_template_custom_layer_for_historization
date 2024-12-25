# phnx_project_template_custom_layer_for_historization
Modifying the default phoenix project with different Repo handling - adding default historization features and wrapping in a service layer

modifying the generators with following features:
	- modify table generation, with adding the deleted_at timestamp field to every table for soft deletes
	- modify get and get_all repo functions to exclude soft-deleted records
	- add field_log and history tables automatically for every table
	- within a transaction, handle the historization and the field change log as well for a given change for updates, inserts, and deletes as well
	- create a service layer, that hides the repo implementation details from the controllers, and instead of using repo in the changeset handling, the project should use the service layer, that handles every historization step within a transaction, with the above constraints.
	- I want my phnx.gen generators to use the service layer by default at every step.
