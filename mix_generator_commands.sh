mix phx.gen.schema Accounts User users name:string email:string:unique username:string:unique phone:string password:string
mix gen_field_logs Accounts User users name:string email:string:unique username:string:unique phone:string password:string
mix gen_scd2 Accounts User users name:string email:string username:string phone:string password:string
