drop extension if exists "pg_net";

alter table "public"."contacts" alter column "profile_id" drop default;

alter table "public"."contacts" alter column "profile_id" drop not null;


