-- ========================================
-- FIX PETS OWNERS - MOVE ALL TO CUSTOMERS
-- ========================================

-- STEP 1: CHECK CURRENT STATUS
-- ========================================

-- Check pets that still have user owners
SELECT 
    'pets_with_user_owners' as status,
    count(*) as count
FROM public.pets p
JOIN public.users u ON p.owner_id = u.id;

-- Check pets that have customer owners
SELECT 
    'pets_with_customer_owners' as status,
    count(*) as count
FROM public.pets p
JOIN public.customers c ON p.owner_id = c.id;

-- STEP 2: CREATE MAPPING FOR ALL PETS
-- ========================================

-- Create mapping for pets that still have user owners
CREATE TEMP TABLE pet_owner_fix AS
SELECT 
    p.id as pet_id,
    p.owner_id as old_owner_id,
    COALESCE(c.id, u.id) as new_owner_id
FROM public.pets p
JOIN public.users u ON p.owner_id = u.id
LEFT JOIN public.customers c ON u.phone = c.phone;

-- STEP 3: CREATE CUSTOMERS FOR USERS WHO DON'T HAVE CUSTOMER RECORD
-- ========================================

-- Insert users as customers if they don't exist in customers table
INSERT INTO public.customers (
    id, created_at, created_by, updated_at, updated_by, deleted_at,
    name, phone, email, picture_url
)
SELECT 
    u.id, u.created_at, u.created_by, u.updated_at, u.updated_by, u.deleted_at,
    u.name, u.phone, u.email, u.picture_url
FROM public.users u
LEFT JOIN public.customers c ON u.phone = c.phone
WHERE c.phone IS NULL
  AND u.phone IS NOT NULL
ON CONFLICT (phone) DO NOTHING;

-- STEP 4: UPDATE PETS TO USE CUSTOMER OWNERS
-- ========================================

-- Update all pets to reference customers
UPDATE public.pets 
SET owner_id = c.id
FROM public.customers c
JOIN public.users u ON c.phone = u.phone
WHERE public.pets.owner_id = u.id;

-- STEP 5: VERIFY FIX
-- ========================================

-- Check final status
SELECT 
    'pets_with_customer_owners' as status,
    count(*) as count
FROM public.pets p
JOIN public.customers c ON p.owner_id = c.id
UNION ALL
SELECT 
    'pets_with_user_owners' as status,
    count(*) as count
FROM public.pets p
JOIN public.users u ON p.owner_id = u.id;

-- STEP 6: CLEAN UP
-- ========================================

DROP TABLE IF EXISTS pet_owner_fix;

COMMIT; 