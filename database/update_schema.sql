-- ========================================
-- UPDATE SCHEMA EXISTING KE ALLNIMALL
-- Simple ALTER dan CREATE saja
-- ========================================

-- 1. CREATE TABLES YANG BELUM ADA
-- ========================================

-- Geography tables
CREATE TABLE IF NOT EXISTS public.countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.provinces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
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
    name TEXT NOT NULL,
    province_id UUID NOT NULL,
    FOREIGN KEY (province_id) REFERENCES public.provinces(id)
);

-- Pet-specific tables
CREATE TABLE IF NOT EXISTS public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    owner_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    address TEXT,
    phone TEXT,
    email TEXT,
    business_type TEXT DEFAULT 'pet_shop',
    description TEXT
);

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

CREATE TABLE IF NOT EXISTS public.pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    owner_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    story TEXT,
    weight DOUBLE PRECISION,
    sex TEXT,
    breed TEXT,
    type TEXT,
    favorite_food TEXT,
    is_diet BOOLEAN,
    current_meal TEXT,
    hydration_level TEXT,
    birthdate DATE,
    pet_category_id UUID,
    is_available_for_adoption BOOLEAN DEFAULT false,
    age INTEGER,
    tags TEXT[],
    microchip_id TEXT,
    vaccination_status TEXT DEFAULT 'unknown',
    FOREIGN KEY (pet_category_id) REFERENCES public.pet_categories(id),
    FOREIGN KEY (owner_id) REFERENCES public.users(id)
);

CREATE TABLE IF NOT EXISTS public.pet_characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    character_id UUID NOT NULL,
    FOREIGN KEY (character_id) REFERENCES public.characters(id),
    FOREIGN KEY (pet_id) REFERENCES public.pets(id)
);

CREATE TABLE IF NOT EXISTS public.pet_healths (
    pet_id UUID PRIMARY KEY,
    health TEXT,
    last_vet_visit_at TIMESTAMP,
    medication TEXT,
    allergies TEXT,
    vaccination TEXT,
    last_deworming_at TIMESTAMP,
    last_tick_treatment_at TIMESTAMP,
    last_grooming_at TIMESTAMP,
    coat_skin_condition TEXT,
    paw_nail_condition TEXT,
    eyes_condition TEXT,
    ears_condition TEXT,
    teeth_condition TEXT,
    weight_history JSONB,
    temperature_history JSONB,
    next_vaccination_due DATE,
    next_deworming_due DATE,
    vet_notes TEXT,
    FOREIGN KEY (pet_id) REFERENCES public.pets(id)
);

-- Payment system
CREATE TABLE IF NOT EXISTS public.payment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    code TEXT NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    payment_type_id UUID NOT NULL,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (payment_type_id) REFERENCES public.payment_types(id)
);

CREATE TABLE IF NOT EXISTS public.store_payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    payment_method_id UUID NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id)
);

-- Schedule system
CREATE TABLE IF NOT EXISTS public.schedule_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    color TEXT,
    is_recurring BOOLEAN DEFAULT false,
    default_duration_minutes INTEGER DEFAULT 60,
    category TEXT DEFAULT 'general'
);

CREATE TABLE IF NOT EXISTS public.pet_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    pet_id UUID NOT NULL,
    schedule_type_id UUID NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    is_completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    reminder_minutes_before INTEGER DEFAULT 15,
    is_recurring BOOLEAN DEFAULT false,
    recurring_pattern TEXT,
    recurring_interval INTEGER DEFAULT 1,
    recurring_end_date DATE,
    priority TEXT DEFAULT 'medium',
    assigned_staff_id UUID,
    service_fee NUMERIC DEFAULT 0,
    status TEXT DEFAULT 'scheduled',
    FOREIGN KEY (pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (schedule_type_id) REFERENCES public.schedule_types(id)
);

CREATE TABLE IF NOT EXISTS public.schedule_recurring_patterns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    schedule_id UUID NOT NULL,
    day_of_week INTEGER[],
    day_of_month INTEGER[],
    month_of_year INTEGER[],
    specific_dates DATE[],
    time_of_day TIME,
    end_date DATE,
    FOREIGN KEY (schedule_id) REFERENCES public.pet_schedules(id)
);

-- Social media
CREATE TABLE IF NOT EXISTS public.posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    user_id UUID NOT NULL,
    content TEXT NOT NULL,
    images TEXT[],
    featured_pet_id UUID,
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    post_type TEXT DEFAULT 'general',
    is_public BOOLEAN DEFAULT true,
    store_id UUID,
    FOREIGN KEY (user_id) REFERENCES public.users(id),
    FOREIGN KEY (featured_pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

CREATE TABLE IF NOT EXISTS public.post_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    post_id UUID NOT NULL,
    user_id UUID NOT NULL,
    UNIQUE(post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES public.posts(id),
    FOREIGN KEY (user_id) REFERENCES public.users(id)
);

CREATE TABLE IF NOT EXISTS public.post_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    updated_at TIMESTAMP WITH TIME ZONE,
    post_id UUID NOT NULL,
    user_id UUID NOT NULL,
    content TEXT NOT NULL,
    parent_comment_id UUID,
    FOREIGN KEY (post_id) REFERENCES public.posts(id),
    FOREIGN KEY (user_id) REFERENCES public.users(id),
    FOREIGN KEY (parent_comment_id) REFERENCES public.post_comments(id)
);

-- Business features
CREATE TABLE IF NOT EXISTS public.discounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    merchant_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    type TEXT NOT NULL DEFAULT 'percentage',
    value NUMERIC NOT NULL DEFAULT 0,
    min_purchase_amount NUMERIC DEFAULT 0,
    max_discount_amount NUMERIC,
    is_active BOOLEAN NOT NULL DEFAULT true,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    usage_limit INTEGER,
    used_count INTEGER DEFAULT 0,
    description TEXT,
    notes TEXT,
    applicable_pet_categories UUID[],
    applicable_product_categories UUID[],
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id)
);

CREATE TABLE IF NOT EXISTS public.loyalty_programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    merchant_id UUID NOT NULL,
    name TEXT NOT NULL,
    code TEXT UNIQUE,
    points_per_purchase NUMERIC NOT NULL DEFAULT 1,
    min_points INTEGER NOT NULL DEFAULT 0,
    discount_percentage NUMERIC NOT NULL DEFAULT 0,
    discount_amount NUMERIC DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    description TEXT,
    terms_conditions TEXT,
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id)
);

CREATE TABLE IF NOT EXISTS public.customer_loyalty_memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    user_id UUID NOT NULL,
    loyalty_program_id UUID NOT NULL,
    current_points INTEGER NOT NULL DEFAULT 0,
    total_points_earned INTEGER NOT NULL DEFAULT 0,
    total_points_redeemed INTEGER NOT NULL DEFAULT 0,
    joined_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    is_active BOOLEAN NOT NULL DEFAULT true,
    FOREIGN KEY (user_id) REFERENCES public.users(id),
    FOREIGN KEY (loyalty_program_id) REFERENCES public.loyalty_programs(id)
);

-- 2. ALTER TABLES EXISTING
-- ========================================

-- Alter users table
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS picture_url TEXT;
ALTER TABLE public.users ADD CONSTRAINT IF NOT EXISTS users_phone_unique UNIQUE (phone);

-- Alter stores table  
ALTER TABLE public.stores ADD COLUMN IF NOT EXISTS merchant_id UUID;
ALTER TABLE public.stores ADD COLUMN IF NOT EXISTS business_field TEXT DEFAULT 'pet_shop';
ALTER TABLE public.stores ADD COLUMN IF NOT EXISTS motto TEXT;

-- Alter users table (customers functionality merged into users)
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS merchant_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS experience_level TEXT DEFAULT 'beginner';
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS total_orders INTEGER DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS total_spent NUMERIC DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS loyalty_points INTEGER DEFAULT 0;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS last_order_date TIMESTAMP WITH TIME ZONE;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS customer_type TEXT DEFAULT 'retail';
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS city_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS province_id UUID;
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS country_id UUID;

-- Alter products table
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS expired_date DATE;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS ingredients TEXT;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS usage_instructions TEXT;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS age_recommendation TEXT;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS pet_size_recommendation TEXT;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS is_prescription_required BOOLEAN DEFAULT false;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS shelf_life_days INTEGER;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS storage_instructions TEXT;

-- Note: sales table will be created separately when needed
-- ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS pet_id UUID;
-- ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS service_type TEXT;
-- ALTER TABLE public.sales ADD COLUMN IF NOT EXISTS appointment_id UUID;

-- 3. INSERT SAMPLE DATA (Hanya untuk table baru)
-- ========================================

-- Payment types (hanya jika table baru)
INSERT INTO public.payment_types (code, name) 
SELECT 'cash', 'Tunai' WHERE NOT EXISTS (SELECT 1 FROM public.payment_types WHERE code = 'cash')
UNION ALL
SELECT 'edc', 'EDC/Debit' WHERE NOT EXISTS (SELECT 1 FROM public.payment_types WHERE code = 'edc')
UNION ALL
SELECT 'ewallet', 'E-Wallet' WHERE NOT EXISTS (SELECT 1 FROM public.payment_types WHERE code = 'ewallet')
UNION ALL
SELECT 'bank_transfer', 'Transfer Bank' WHERE NOT EXISTS (SELECT 1 FROM public.payment_types WHERE code = 'bank_transfer')
UNION ALL
SELECT 'credit', 'Kredit' WHERE NOT EXISTS (SELECT 1 FROM public.payment_types WHERE code = 'credit');

-- Payment methods (hanya jika table baru)
INSERT INTO public.payment_methods (payment_type_id, code, name)
SELECT pt.id, 'cash', 'Tunai' FROM public.payment_types pt WHERE pt.code = 'cash' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'cash')
UNION ALL
SELECT pt.id, 'bca', 'BCA' FROM public.payment_types pt WHERE pt.code = 'edc' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'bca')
UNION ALL
SELECT pt.id, 'mandiri', 'Mandiri' FROM public.payment_types pt WHERE pt.code = 'edc' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'mandiri')
UNION ALL
SELECT pt.id, 'gopay', 'GoPay' FROM public.payment_types pt WHERE pt.code = 'ewallet' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'gopay')
UNION ALL
SELECT pt.id, 'ovo', 'OVO' FROM public.payment_types pt WHERE pt.code = 'ewallet' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'ovo')
UNION ALL
SELECT pt.id, 'dana', 'DANA' FROM public.payment_types pt WHERE pt.code = 'ewallet' AND NOT EXISTS (SELECT 1 FROM public.payment_methods WHERE code = 'dana');

-- Geography data (hanya jika table baru)
INSERT INTO public.countries (name)
SELECT 'Indonesia' WHERE NOT EXISTS (SELECT 1 FROM public.countries WHERE name = 'Indonesia');

INSERT INTO public.provinces (name, country_id)
SELECT 'DKI Jakarta', id FROM public.countries WHERE name = 'Indonesia' AND NOT EXISTS (SELECT 1 FROM public.provinces WHERE name = 'DKI Jakarta')
UNION ALL
SELECT 'Jawa Barat', id FROM public.countries WHERE name = 'Indonesia' AND NOT EXISTS (SELECT 1 FROM public.provinces WHERE name = 'Jawa Barat')
UNION ALL
SELECT 'Jawa Tengah', id FROM public.countries WHERE name = 'Indonesia' AND NOT EXISTS (SELECT 1 FROM public.provinces WHERE name = 'Jawa Tengah')
UNION ALL
SELECT 'Jawa Timur', id FROM public.countries WHERE name = 'Indonesia' AND NOT EXISTS (SELECT 1 FROM public.provinces WHERE name = 'Jawa Timur')
UNION ALL
SELECT 'Bali', id FROM public.countries WHERE name = 'Indonesia' AND NOT EXISTS (SELECT 1 FROM public.provinces WHERE name = 'Bali');

INSERT INTO public.cities (name, province_id)
SELECT 'Jakarta Pusat', id FROM public.provinces WHERE name = 'DKI Jakarta' AND NOT EXISTS (SELECT 1 FROM public.cities WHERE name = 'Jakarta Pusat')
UNION ALL
SELECT 'Jakarta Selatan', id FROM public.provinces WHERE name = 'DKI Jakarta' AND NOT EXISTS (SELECT 1 FROM public.cities WHERE name = 'Jakarta Selatan')
UNION ALL
SELECT 'Jakarta Timur', id FROM public.provinces WHERE name = 'DKI Jakarta' AND NOT EXISTS (SELECT 1 FROM public.cities WHERE name = 'Jakarta Timur')
UNION ALL
SELECT 'Jakarta Barat', id FROM public.provinces WHERE name = 'DKI Jakarta' AND NOT EXISTS (SELECT 1 FROM public.cities WHERE name = 'Jakarta Barat')
UNION ALL
SELECT 'Jakarta Utara', id FROM public.provinces WHERE name = 'DKI Jakarta' AND NOT EXISTS (SELECT 1 FROM public.cities WHERE name = 'Jakarta Utara');

-- 4. CREATE INDEXES
-- ========================================

CREATE INDEX IF NOT EXISTS idx_users_phone ON public.users(phone);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_merchant_id ON public.users(merchant_id);
CREATE INDEX IF NOT EXISTS idx_users_phone ON public.users(phone);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_pets_owner_id ON public.pets(owner_id);
CREATE INDEX IF NOT EXISTS idx_pets_pet_category_id ON public.pets(pet_category_id);
CREATE INDEX IF NOT EXISTS idx_pet_schedules_pet_id ON public.pet_schedules(pet_id);
CREATE INDEX IF NOT EXISTS idx_pet_schedules_scheduled_at ON public.pet_schedules(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_products_store_id ON public.products(store_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);
-- Product indexes (comment out if columns don't exist)
-- CREATE INDEX IF NOT EXISTS idx_products_code ON public.products(code);
-- CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products(barcode);
-- Sales indexes (will be created when sales table exists)
-- CREATE INDEX IF NOT EXISTS idx_sales_store_id ON public.sales(store_id);
-- CREATE INDEX IF NOT EXISTS idx_sales_user_id ON public.sales(customer_id);
-- CREATE INDEX IF NOT EXISTS idx_sales_sale_date ON public.sales(sale_date);
-- CREATE INDEX IF NOT EXISTS idx_sales_sale_number ON public.sales(sale_number);

COMMIT; 