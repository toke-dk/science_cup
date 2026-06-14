create type "public"."user_role" as enum ('admin', 'group_contact');

alter table "public"."teams" drop constraint "team_registrations_primary_contact_id_fkey";

alter table "public"."teams" drop constraint "team_registrations_secondary_contact_id_fkey";

alter table "public"."contacts" drop constraint "contact_persons_pkey";

drop index if exists "public"."contact_persons_pkey";


  create table "public"."profiles" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "email" text,
    "phone" text,
    "role" public.user_role,
    "name" text
      );


alter table "public"."contacts" drop column "name";

alter table "public"."contacts" drop column "phone_number";

alter table "public"."contacts" add column "group_id" bigint not null;

alter table "public"."contacts" add column "is_primary" boolean;

alter table "public"."contacts" add column "profile_id" uuid not null default gen_random_uuid();

alter table "public"."teams" drop column "primary_contact_id";

alter table "public"."teams" drop column "secondary_contact_id";

CREATE UNIQUE INDEX group_contact_pkey ON public.contacts USING btree (id);

CREATE UNIQUE INDEX users_pkey ON public.profiles USING btree (id);

alter table "public"."contacts" add constraint "group_contact_pkey" PRIMARY KEY using index "group_contact_pkey";

alter table "public"."profiles" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."contacts" add constraint "contacts_profile_id_fkey" FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."contacts" validate constraint "contacts_profile_id_fkey";

alter table "public"."contacts" add constraint "group_contact_group_id_fkey" FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."contacts" validate constraint "group_contact_group_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (
    new.id,
    new.email
  );
  RETURN NEW;
END;$function$
;

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_profile();


