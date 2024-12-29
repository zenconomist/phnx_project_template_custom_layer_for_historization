cd phnx_project_template_history

mix phx.gen.html Accounts User users name:string email:string:unique username:string:unique phone:string password:string
sleep 1
mix gen_field_logs Accounts User users name:string email:string:unique username:string:unique phone:string password:string
sleep 1
mix gen_scd2 Accounts User users name:string email:string username:string phone:string password:string