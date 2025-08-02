-- ========================================
-- SEPARATE USERS (STAFF) AND CUSTOMERS (PET OWNERS)
-- ========================================

-- STEP 1: CREATE CUSTOMERS TABLE
-- ========================================

CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT,
    picture_url TEXT,
    -- Customer specific fields
    merchant_id UUID,
    experience_level TEXT DEFAULT 'beginner',
    total_orders INTEGER DEFAULT 0,
    total_spent NUMERIC DEFAULT 0,
    loyalty_points INTEGER DEFAULT 0,
    last_order_date TIMESTAMP WITH TIME ZONE,
    customer_type TEXT DEFAULT 'retail',
    address TEXT,
    city_id UUID,
    province_id UUID,
    country_id UUID,
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (city_id) REFERENCES public.cities(id),
    FOREIGN KEY (province_id) REFERENCES public.provinces(id),
    FOREIGN KEY (country_id) REFERENCES public.countries(id)
);

-- STEP 2: ADD UNIQUE CONSTRAINT FOR CUSTOMERS (BEFORE INSERT)
-- ========================================

-- Add unique constraint for customer phone
ALTER TABLE public.customers ADD CONSTRAINT IF NOT EXISTS customers_phone_unique UNIQUE (phone);

-- STEP 2.5: MIGRATE CUSTOMER DATA FROM USERS
-- ========================================

-- Insert customer data from users who have customer fields
INSERT INTO public.customers (
    id, created_at, created_by, updated_at, updated_by, deleted_at,
    name, phone, email, picture_url,
    merchant_id, experience_level, total_orders, total_spent, loyalty_points,
    last_order_date, customer_type, address, city_id, province_id, country_id
)
SELECT 
    id, created_at, created_by, updated_at, updated_by, deleted_at,
    name, phone, email, picture_url,
    merchant_id, experience_level, total_orders, total_spent, loyalty_points,
    last_order_date, customer_type, address, city_id, province_id, country_id
FROM public.users 
WHERE merchant_id IS NOT NULL 
   OR experience_level IS NOT NULL 
   OR total_orders > 0 
   OR total_spent > 0 
   OR loyalty_points > 0
   OR customer_type IS NOT NULL
   OR address IS NOT NULL
ON CONFLICT (phone) DO NOTHING;

-- STEP 3: CLEAN UP USERS TABLE (REMOVE CUSTOMER FIELDS)
-- ========================================

-- Remove customer-specific columns from users table
ALTER TABLE public.users DROP COLUMN IF EXISTS merchant_id;
ALTER TABLE public.users DROP COLUMN IF EXISTS experience_level;
ALTER TABLE public.users DROP COLUMN IF EXISTS total_orders;
ALTER TABLE public.users DROP COLUMN IF EXISTS total_spent;
ALTER TABLE public.users DROP COLUMN IF EXISTS loyalty_points;
ALTER TABLE public.users DROP COLUMN IF EXISTS last_order_date;
ALTER TABLE public.users DROP COLUMN IF EXISTS customer_type;
ALTER TABLE public.users DROP COLUMN IF EXISTS address;
ALTER TABLE public.users DROP COLUMN IF EXISTS city_id;
ALTER TABLE public.users DROP COLUMN IF EXISTS province_id;
ALTER TABLE public.users DROP COLUMN IF EXISTS country_id;

-- Add staff-specific fields to users
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS role_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS store_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS staff_type TEXT DEFAULT 'cashier'; -- 'owner', 'admin', 'cashier', 'vet', 'groomer'

-- STEP 4: UPDATE PETS TABLE TO REFERENCE CUSTOMERS
-- ========================================

-- First, create a mapping of user_id to customer_id for pets
CREATE TEMP TABLE pet_owner_mapping AS
SELECT 
    p.id as pet_id,
    p.owner_id as old_owner_id,
    c.id as new_owner_id
FROM public.pets p
JOIN public.users u ON p.owner_id = u.id
JOIN public.customers c ON u.phone = c.phone
WHERE c.phone IS NOT NULL;

-- Update pets table to reference customers instead of users
UPDATE public.pets 
SET owner_id = mapping.new_owner_id
FROM pet_owner_mapping mapping
WHERE public.pets.id = mapping.pet_id;

-- Update foreign key constraint
ALTER TABLE public.pets DROP CONSTRAINT IF EXISTS pets_owner_id_fkey;
ALTER TABLE public.pets ADD CONSTRAINT pets_owner_id_fkey 
    FOREIGN KEY (owner_id) REFERENCES public.customers(id);

-- STEP 5: UPDATE CUSTOMER_LOYALTY_MEMBERSHIPS
-- ========================================

-- Update customer_loyalty_memberships to reference customers
-- UPDATE public.customer_loyalty_memberships 
-- SET user_id = c.id
-- FROM public.customers c
-- JOIN public.users u ON c.phone = u.phone
-- WHERE public.customer_loyalty_memberships.user_id = u.id;

-- Update foreign key constraint
-- ALTER TABLE public.customer_loyalty_memberships DROP CONSTRAINT IF EXISTS customer_loyalty_memberships_user_id_fkey;
-- ALTER TABLE public.customer_loyalty_memberships ADD CONSTRAINT customer_loyalty_memberships_user_id_fkey 
--     FOREIGN KEY (user_id) REFERENCES public.customers(id);

-- STEP 6: UPDATE SALES TABLE (if exists)
-- ========================================

-- Update sales table to reference customers
-- UPDATE public.sales 
-- SET customer_id = c.id
-- FROM public.customers c
-- JOIN public.users u ON c.phone = u.phone
-- WHERE public.sales.customer_id = u.id;

-- STEP 7: UPDATE RECEIVABLES TABLE (if exists)
-- ========================================

-- Update receivables table to reference customers
-- UPDATE public.receivables 
-- SET customer_id = c.id
-- FROM public.customers c
-- JOIN public.users u ON c.phone = u.phone
-- WHERE public.receivables.customer_id = u.id;

-- STEP 8: UPDATE INDEXES
-- ========================================

-- Drop old indexes
DROP INDEX IF EXISTS idx_users_merchant_id;
-- DROP INDEX IF EXISTS idx_sales_user_id;
-- DROP INDEX IF EXISTS idx_receivables_user_id;

-- Create new indexes for customers
CREATE INDEX IF NOT EXISTS idx_customers_merchant_id ON public.customers(merchant_id);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_email ON public.customers(email);

-- Update sales indexes (if sales table exists)
-- CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON public.sales(customer_id);

-- Update receivables indexes (if receivables table exists)
-- CREATE INDEX IF NOT EXISTS idx_receivables_customer_id ON public.receivables(customer_id);

-- STEP 10: VERIFICATION
-- ========================================

-- Check migration results
SELECT 'users' as table_name, count(*) as staff_count FROM public.users
UNION ALL
SELECT 'customers', count(*) FROM public.customers
UNION ALL
SELECT 'pets', count(*) FROM public.pets;
-- UNION ALL
-- SELECT 'customer_loyalty_memberships', count(*) FROM public.customer_loyalty_memberships;

-- Check pets owner mapping
SELECT 
    'pets_with_customer_owners' as check_type,
    count(*) as count
FROM public.pets p
JOIN public.customers c ON p.owner_id = c.id
UNION ALL
SELECT 
    'pets_with_user_owners' as check_type,
    count(*) as count
FROM public.pets p
JOIN public.users u ON p.owner_id = u.id;

-- Clean up temp table
DROP TABLE IF EXISTS pet_owner_mapping;

COMMIT; 