alter table "public"."programs" add column "nickname" text;

alter table "public"."seasons" enable row level security;


  create policy "Alle kan læse sæsoner"
  on "public"."seasons"
  as permissive
  for select
  to public
using (true);



  create policy "Kun admins kan ændre sæsoner"
  on "public"."seasons"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.role = 'admin'::public.user_role)))));



