alter table "public"."contacts" drop column "fallback_name";

alter table "public"."contacts" drop column "fallback_phone";

alter table "public"."contacts" add column "name" text not null;

alter table "public"."contacts" add column "phone" text;


