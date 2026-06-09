-- 1. Fjern identity-låsen fuldstændig fra kolonnen
ALTER TABLE groups ALTER COLUMN id DROP IDENTITY IF EXISTS;

-- 2. Tving kolonnen til at blive til en UUID
ALTER TABLE groups ALTER COLUMN id TYPE uuid USING gen_random_uuid();

-- 3. Sæt standardværdien, så Supabase også kan generere UUIDs automatisk
ALTER TABLE groups ALTER COLUMN id SET DEFAULT gen_random_uuid();