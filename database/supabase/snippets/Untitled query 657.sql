-- 1. Tillad ALLE (også folk der ikke er logget ind) at læse sæsoner
CREATE POLICY "Alle kan læse sæsoner" 
ON public.seasons 
FOR SELECT 
USING ( true ); -- 'true' betyder bare: giv adgang til alle uden betingelser

-- 2. Tillad KUN brugere med admin-rollen at indsætte, opdatere eller slette
CREATE POLICY "Kun admins kan ændre sæsoner" 
ON public.seasons 
FOR ALL -- Gælder INSERT, UPDATE og DELETE
TO authenticated -- Kræver at man i det mindste er logget ind
USING ( (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin' );