-- ========================================
-- CLEAN DATABASE - KEEP MASTER TABLES
-- ========================================

-- STEP 1: BACKUP MASTER DATA
-- ========================================

-- Backup master tables data
CREATE TEMP TABLE backup_characters AS SELECT * FROM public.characters;
CREATE TEMP TABLE backup_pet_categories AS SELECT * FROM public.pet_categories;
CREATE TEMP TABLE backup_schedule_types AS SELECT * FROM public.schedule_types;
CREATE TEMP TABLE backup_payment_types AS SELECT * FROM public.payment_types;
CREATE TEMP TABLE backup_payment_methods AS SELECT * FROM public.payment_methods;
CREATE TEMP TABLE backup_products_categories AS SELECT * FROM public.products_categories;
CREATE TEMP TABLE backup_countries AS SELECT * FROM public.countries;
CREATE TEMP TABLE backup_provinces AS SELECT * FROM public.provinces;
CREATE TEMP TABLE backup_cities AS SELECT * FROM public.cities;

-- STEP 2: DROP ALL TABLES (EXCEPT MASTER)
-- ========================================

-- Drop tables that will be recreated
DROP TABLE IF EXISTS public.pets CASCADE;
DROP TABLE IF EXISTS public.pet_characters CASCADE;
DROP TABLE IF EXISTS public.pet_healths CASCADE;
DROP TABLE IF EXISTS public.products CASCADE;
DROP TABLE IF EXISTS public.inventory_transactions CASCADE;
DROP TABLE IF EXISTS public.stock_opname_sessions CASCADE;
DROP TABLE IF EXISTS public.stock_opname_items CASCADE;
DROP TABLE IF EXISTS public.store_payment_methods CASCADE;
DROP TABLE IF EXISTS public.suppliers CASCADE;
DROP TABLE IF EXISTS public.store_carts CASCADE;
DROP TABLE IF EXISTS public.sales CASCADE;
DROP TABLE IF EXISTS public.sales_items CASCADE;
DROP TABLE IF EXISTS public.purchases CASCADE;
DROP TABLE IF EXISTS public.purchases_items CASCADE;
DROP TABLE IF EXISTS public.financial_transactions CASCADE;
DROP TABLE IF EXISTS public.receivables CASCADE;
DROP TABLE IF EXISTS public.payables CASCADE;
DROP TABLE IF EXISTS public.discounts CASCADE;
DROP TABLE IF EXISTS public.expenses CASCADE;
DROP TABLE IF EXISTS public.loyalty_programs CASCADE;
DROP TABLE IF EXISTS public.customer_loyalty_memberships CASCADE;
DROP TABLE IF EXISTS public.pet_schedules CASCADE;
DROP TABLE IF EXISTS public.schedule_recurring_patterns CASCADE;
DROP TABLE IF EXISTS public.posts CASCADE;
DROP TABLE IF EXISTS public.post_likes CASCADE;
DROP TABLE IF EXISTS public.post_comments CASCADE;
DROP TABLE IF EXISTS public.options CASCADE;

-- Drop user management tables
DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS public.customers CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;
DROP TABLE IF EXISTS public.role_assignments CASCADE;

-- Drop business tables
DROP TABLE IF EXISTS public.merchants CASCADE;
DROP TABLE IF EXISTS public.stores CASCADE;

-- STEP 3: RECREATE MASTER TABLES (IF NEEDED)
-- ========================================

-- Recreate master tables with clean structure
CREATE TABLE IF NOT EXISTS public.characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    character_en TEXT NOT NULL,
    character_id TEXT NOT NULL,
    good_character BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS public.pet_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name_en TEXT NOT NULL,
    name_id TEXT NOT NULL,
    picture_url TEXT,
    icon_url TEXT
);

CREATE TABLE IF NOT EXISTS public.schedule_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name_en TEXT NOT NULL,
    name_id TEXT NOT NULL,
    description TEXT,
    color TEXT,
    icon_url TEXT
);

CREATE TABLE IF NOT EXISTS public.payment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS public.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    description TEXT,
    payment_type_id UUID,
    FOREIGN KEY (payment_type_id) REFERENCES public.payment_types(id)
);

CREATE TABLE IF NOT EXISTS public.products_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    description TEXT,
    picture_url TEXT
);

CREATE TABLE IF NOT EXISTS public.countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name_en TEXT NOT NULL,
    name_id TEXT NOT NULL,
    code TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS public.provinces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name_en TEXT NOT NULL,
    name_id TEXT NOT NULL,
    country_id UUID NOT NULL,
    FOREIGN KEY (country_id) REFERENCES public.countries(id)
);

CREATE TABLE IF NOT EXISTS public.cities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name_en TEXT NOT NULL,
    name_id TEXT NOT NULL,
    province_id UUID NOT NULL,
    FOREIGN KEY (province_id) REFERENCES public.provinces(id)
);

-- STEP 4: RESTORE MASTER DATA
-- ========================================

-- Restore master data
INSERT INTO public.characters SELECT * FROM backup_characters ON CONFLICT DO NOTHING;
INSERT INTO public.pet_categories SELECT * FROM backup_pet_categories ON CONFLICT DO NOTHING;
INSERT INTO public.schedule_types SELECT * FROM backup_schedule_types ON CONFLICT DO NOTHING;
INSERT INTO public.payment_types SELECT * FROM backup_payment_types ON CONFLICT DO NOTHING;
INSERT INTO public.payment_methods SELECT * FROM backup_payment_methods ON CONFLICT DO NOTHING;
INSERT INTO public.products_categories SELECT * FROM backup_products_categories ON CONFLICT DO NOTHING;
INSERT INTO public.countries SELECT * FROM backup_countries ON CONFLICT DO NOTHING;
INSERT INTO public.provinces SELECT * FROM backup_provinces ON CONFLICT DO NOTHING;
INSERT INTO public.cities SELECT * FROM backup_cities ON CONFLICT DO NOTHING;

-- STEP 5: CLEAN UP BACKUP TABLES
-- ========================================

DROP TABLE IF EXISTS backup_characters;
DROP TABLE IF EXISTS backup_pet_categories;
DROP TABLE IF EXISTS backup_schedule_types;
DROP TABLE IF EXISTS backup_payment_types;
DROP TABLE IF EXISTS backup_payment_methods;
DROP TABLE IF EXISTS backup_products_categories;
DROP TABLE IF EXISTS backup_countries;
DROP TABLE IF EXISTS backup_provinces;
DROP TABLE IF EXISTS backup_cities;

-- STEP 6: VERIFICATION
-- ========================================

-- Check what tables remain
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;

-- Check master data count
SELECT 'characters' as table_name, count(*) as count FROM public.characters
UNION ALL
SELECT 'pet_categories', count(*) FROM public.pet_categories
UNION ALL
SELECT 'schedule_types', count(*) FROM public.schedule_types
UNION ALL
SELECT 'payment_types', count(*) FROM public.payment_types
UNION ALL
SELECT 'payment_methods', count(*) FROM public.payment_methods
UNION ALL
SELECT 'products_categories', count(*) FROM public.products_categories
UNION ALL
SELECT 'countries', count(*) FROM public.countries
UNION ALL
SELECT 'provinces', count(*) FROM public.provinces
UNION ALL
SELECT 'cities', count(*) FROM public.cities;

COMMIT; 