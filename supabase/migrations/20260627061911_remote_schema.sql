create type "public"."resolution" as enum ('walkover', 'retired');

alter table "public"."games" add column "resolution" public.resolution;


