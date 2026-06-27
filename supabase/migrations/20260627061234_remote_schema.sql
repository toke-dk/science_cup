create type "public"."game_slot" as enum ('home', 'away');

create type "public"."game_status" as enum ('pending', 'ready', 'playing', 'completed');

alter table "public"."games" add column "next_game_id" bigint;

alter table "public"."games" add column "next_game_slot" public.game_slot;

alter table "public"."games" add column "round_number" smallint;

alter table "public"."games" add column "status" public.game_status;

alter table "public"."teams" add column "group_id" bigint;

alter table "public"."games" add constraint "games_next_game_id_fkey" FOREIGN KEY (next_game_id) REFERENCES public.games(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."games" validate constraint "games_next_game_id_fkey";

alter table "public"."teams" add constraint "teams_group_id_fkey" FOREIGN KEY (group_id) REFERENCES public.groups(id) ON UPDATE CASCADE ON DELETE SET DEFAULT not valid;

alter table "public"."teams" validate constraint "teams_group_id_fkey";


