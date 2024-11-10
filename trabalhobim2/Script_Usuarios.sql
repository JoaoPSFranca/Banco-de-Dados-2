create role us_endereco with password 'usend123';
alter role us_endereco login;

create role us_venda with password 'usvend123';
alter role us_venda login;

create role us_admin with password 'usadmin123';
alter role us_admin login;

grant connect on database pe3021114 to us_endereco;
grant connect on database pe3021114 to us_venda;
grant connect on database pe3021114 to us_admin;

grant usage on schema trabalhobim2 to us_endereco;
grant usage on schema trabalhobim2 to us_venda;
grant usage on schema trabalhobim2 to us_admin;

grant select, insert, update on bairro to us_endereco;
grant select, insert, update on cidade to us_endereco;
grant select, insert, update on endereco to us_endereco;
grant select, insert, update on estado to us_endereco;

grant select, insert, update on venda to us_venda;
grant select, insert, update on itemvenda to us_venda;
grant select, insert, update on cliente to us_venda;
grant select, insert, update on produto to us_venda;

grant select, insert, update, delete on all tables in schema trabalhobim2 to us_admin;