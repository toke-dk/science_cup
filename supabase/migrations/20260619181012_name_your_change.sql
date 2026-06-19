alter table "public"."contacts" drop constraint "group_contact_group_id_fkey";

alter table "public"."contacts" drop column "group_id";

alter table "public"."contacts" add column "team_id" bigint not null;

alter table "public"."contacts" add constraint "contacts_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."contacts" validate constraint "contacts_team_id_fkey";


