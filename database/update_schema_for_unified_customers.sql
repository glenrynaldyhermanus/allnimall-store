-- ========================================
-- MIGRATION SCRIPT: Unified Customer Architecture
-- Update database schema for Allnimall unified customer concept
-- ========================================

-- ========================================
-- STEP 1: Add authentication fields to existing tables
-- ========================================

-- Add auth_id and username to users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS auth_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS username TEXT UNIQUE;

-- Add auth_id to customers table
ALTER TABLE public.customers ADD COLUMN IF NOT EXISTS auth_id UUID;

-- ========================================
-- STEP 2: Create merchant_customers mapping table
-- ========================================

CREATE TABLE IF NOT EXISTS public.merchant_customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    merchant_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    store_id UUID NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    is_active BOOLEAN DEFAULT true,
    customer_code TEXT, -- kode customer di merchant tersebut
    notes TEXT,
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- ========================================
-- STEP 3: Create indexes for performance
-- ========================================

-- Indexes for merchant_customers
CREATE INDEX IF NOT EXISTS idx_merchant_customers_merchant_id ON public.merchant_customers(merchant_id);
CREATE INDEX IF NOT EXISTS idx_merchant_customers_customer_id ON public.merchant_customers(customer_id);
CREATE INDEX IF NOT EXISTS idx_merchant_customers_store_id ON public.merchant_customers(store_id);
CREATE INDEX IF NOT EXISTS idx_merchant_customers_is_active ON public.merchant_customers(is_active);

-- Indexes for auth fields
CREATE INDEX IF NOT EXISTS idx_users_auth_id ON public.users(auth_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON public.users(username);
CREATE INDEX IF NOT EXISTS idx_customers_auth_id ON public.customers(auth_id);

-- ========================================
-- STEP 4: Migrate existing data (if needed)
-- ========================================

-- If you have existing customer data that needs to be migrated
-- This section can be customized based on your current data structure

-- Example: If you need to create merchant_customers records from existing customer data
-- INSERT INTO public.merchant_customers (merchant_id, customer_id, store_id, joined_at)
-- SELECT 
--     c.merchant_id,
--     c.id,
--     (SELECT id FROM public.stores WHERE merchant_id = c.merchant_id LIMIT 1),
--     c.created_at
-- FROM public.customers c
-- WHERE c.merchant_id IS NOT NULL;

-- ========================================
-- STEP 5: Update foreign key constraints
-- ========================================

-- Remove the old merchant_id foreign key from customers table if it exists
-- (This depends on your current schema - uncomment if needed)
-- ALTER TABLE public.customers DROP CONSTRAINT IF EXISTS customers_merchant_id_fkey;
-- ALTER TABLE public.customers DROP COLUMN IF EXISTS merchant_id;

-- ========================================
-- STEP 6: Add comments for documentation
-- ========================================

COMMENT ON TABLE public.merchant_customers IS 'Mapping table between merchants and customers. One customer can be registered with multiple merchants.';
COMMENT ON COLUMN public.customers.auth_id IS 'Supabase auth ID. NULL = customer not logged in to Allnimall, NOT NULL = customer logged in to Allnimall';
COMMENT ON COLUMN public.users.auth_id IS 'Supabase auth ID for staff authentication';
COMMENT ON COLUMN public.users.username IS 'Username for staff login (used to find email for Supabase auth)';

-- ========================================
-- STEP 7: Create helper functions (optional)
-- ========================================

-- Function to get all merchants for a customer
CREATE OR REPLACE FUNCTION get_customer_merchants(customer_uuid UUID)
RETURNS TABLE (
    merchant_id UUID,
    merchant_name TEXT,
    store_id UUID,
    store_name TEXT,
    joined_at TIMESTAMP WITH TIME ZONE,
    customer_code TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mc.merchant_id,
        m.name as merchant_name,
        mc.store_id,
        s.name as store_name,
        mc.joined_at,
        mc.customer_code
    FROM public.merchant_customers mc
    JOIN public.merchants m ON m.id = mc.merchant_id
    JOIN public.stores s ON s.id = mc.store_id
    WHERE mc.customer_id = customer_uuid
    AND mc.is_active = true
    AND mc.deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to get all customers for a merchant
CREATE OR REPLACE FUNCTION get_merchant_customers(merchant_uuid UUID)
RETURNS TABLE (
    customer_id UUID,
    customer_name TEXT,
    customer_phone TEXT,
    store_id UUID,
    store_name TEXT,
    joined_at TIMESTAMP WITH TIME ZONE,
    customer_code TEXT,
    has_allnimall_account BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mc.customer_id,
        c.name as customer_name,
        c.phone as customer_phone,
        mc.store_id,
        s.name as store_name,
        mc.joined_at,
        mc.customer_code,
        (c.auth_id IS NOT NULL) as has_allnimall_account
    FROM public.merchant_customers mc
    JOIN public.customers c ON c.id = mc.customer_id
    JOIN public.stores s ON s.id = mc.store_id
    WHERE mc.merchant_id = merchant_uuid
    AND mc.is_active = true
    AND mc.deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- MIGRATION COMPLETION MESSAGE
-- ========================================

-- Migration completed successfully!
-- 
-- New architecture:
-- 1. customers table: Universal customer data (auth_id determines Allnimall login status)
-- 2. merchant_customers table: Mapping between merchants and customers
-- 3. users table: Staff with auth_id and username for Supabase authentication
-- 4. pets table: Linked to customers, accessible across all merchants when customer logs in
--
-- Benefits:
-- - No customer duplication across merchants
-- - Unified pet data when customer logs in to Allnimall
-- - Clean separation of customer data vs merchant relationships
-- - Support for both authenticated (Allnimall) and non-authenticated (merchant-only) customers 