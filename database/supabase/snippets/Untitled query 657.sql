-- 1. Slet de gamle versioner helt, så vi er sikre på at starte på en frisk
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 2. Genopret funktionen med korrekte indstillinger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (
    new.id,
    new.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; -- <-- VIGTIGT: Kører funktionen med administrator-rettigheder

-- 3. Giv systemet lov til at eksekvere funktionen
ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

-- 4. Opret triggeren på ny
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();