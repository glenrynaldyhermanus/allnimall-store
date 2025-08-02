-- ========================================
-- SETUP ALLNIMALL PET SHOP POS SCHEMA
-- ========================================

-- STEP 1: CREATE BUSINESS TABLES
-- ========================================

-- merchants (pet shops, vets, groomers)
CREATE TABLE IF NOT EXISTS public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    business_type TEXT NOT NULL, -- 'pet_shop', 'vet_clinic', 'groomer', 'mixed'
    phone TEXT,
    email TEXT,
    address TEXT,
    city_id UUID,
    province_id UUID,
    country_id UUID,
    logo_url TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (city_id) REFERENCES public.cities(id),
    FOREIGN KEY (province_id) REFERENCES public.provinces(id),
    FOREIGN KEY (country_id) REFERENCES public.countries(id)
);

-- stores (branches/locations)
CREATE TABLE IF NOT EXISTS public.stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    merchant_id UUID NOT NULL,
    name TEXT NOT NULL,
    address TEXT,
    city_id UUID,
    province_id UUID,
    country_id UUID,
    phone TEXT,
    email TEXT,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (city_id) REFERENCES public.cities(id),
    FOREIGN KEY (province_id) REFERENCES public.provinces(id),
    FOREIGN KEY (country_id) REFERENCES public.countries(id)
);

-- STEP 2: CREATE USER MANAGEMENT TABLES
-- ========================================

-- users (staff/employees)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT,
    picture_url TEXT,
    password_hash TEXT,
    is_active BOOLEAN DEFAULT true,
    staff_type TEXT DEFAULT 'cashier' -- 'owner', 'admin', 'cashier', 'vet', 'groomer'
);

-- customers (pet owners)
CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT,
    picture_url TEXT,
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

-- roles
CREATE TABLE IF NOT EXISTS public.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL, -- 'owner', 'admin', 'cashier', 'vet', 'groomer'
    description TEXT,
    permissions TEXT[] -- array of permission strings
);

-- role_assignments
CREATE TABLE IF NOT EXISTS public.role_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    user_id UUID NOT NULL,
    merchant_id UUID NOT NULL,
    role_id UUID NOT NULL,
    store_id UUID NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    FOREIGN KEY (user_id) REFERENCES public.users(id),
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (role_id) REFERENCES public.roles(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- STEP 3: CREATE PET-SPECIFIC TABLES
-- ========================================

-- pets
CREATE TABLE IF NOT EXISTS public.pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    owner_id UUID NOT NULL,
    name TEXT NOT NULL,
    pet_category_id UUID NOT NULL,
    breed TEXT,
    birth_date DATE,
    gender TEXT, -- 'male', 'female'
    color TEXT,
    weight NUMERIC,
    microchip_id TEXT,
    picture_url TEXT,
    notes TEXT,
    FOREIGN KEY (owner_id) REFERENCES public.customers(id),
    FOREIGN KEY (pet_category_id) REFERENCES public.pet_categories(id)
);

-- pet_characters (many-to-many)
CREATE TABLE IF NOT EXISTS public.pet_characters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    pet_id UUID NOT NULL,
    character_id UUID NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (character_id) REFERENCES public.characters(id),
    UNIQUE(pet_id, character_id)
);

-- pet_healths
CREATE TABLE IF NOT EXISTS public.pet_healths (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    pet_id UUID NOT NULL,
    weight NUMERIC,
    weight_history JSONB, -- array of {date, weight} objects
    vaccination_status TEXT,
    last_vaccination_date DATE,
    next_vaccination_date DATE,
    health_notes TEXT,
    medical_conditions TEXT[],
    allergies TEXT[],
    FOREIGN KEY (pet_id) REFERENCES public.pets(id)
);

-- pet_schedules
CREATE TABLE IF NOT EXISTS public.pet_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    pet_id UUID NOT NULL,
    schedule_type_id UUID NOT NULL,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    status TEXT DEFAULT 'scheduled', -- 'scheduled', 'completed', 'cancelled'
    recurring_pattern_id UUID,
    FOREIGN KEY (pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (schedule_type_id) REFERENCES public.schedule_types(id)
);

-- schedule_recurring_patterns
CREATE TABLE IF NOT EXISTS public.schedule_recurring_patterns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    pattern_type TEXT NOT NULL, -- 'daily', 'weekly', 'monthly', 'yearly'
    interval_value INTEGER NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT true
);

-- STEP 4: CREATE PRODUCT & INVENTORY TABLES
-- ========================================

-- products
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    category_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    cost_price NUMERIC,
    stock_quantity INTEGER DEFAULT 0,
    min_stock_level INTEGER DEFAULT 0,
    max_stock_level INTEGER,
    barcode TEXT,
    sku TEXT,
    picture_url TEXT,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (category_id) REFERENCES public.products_categories(id)
);

-- inventory_transactions
CREATE TABLE IF NOT EXISTS public.inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    product_id UUID NOT NULL,
    transaction_type TEXT NOT NULL, -- 'in', 'out', 'adjustment'
    quantity INTEGER NOT NULL,
    unit_price NUMERIC,
    total_amount NUMERIC,
    reference_id UUID, -- sales_id, purchase_id, etc.
    reference_type TEXT, -- 'sale', 'purchase', 'adjustment'
    notes TEXT,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (product_id) REFERENCES public.products(id)
);

-- STEP 5: CREATE SALES & PAYMENT TABLES
-- ========================================

-- store_carts
CREATE TABLE IF NOT EXISTS public.store_carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    customer_id UUID,
    user_id UUID NOT NULL,
    status TEXT DEFAULT 'active', -- 'active', 'completed', 'cancelled'
    total_amount NUMERIC DEFAULT 0,
    discount_amount NUMERIC DEFAULT 0,
    final_amount NUMERIC DEFAULT 0,
    notes TEXT,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id),
    FOREIGN KEY (user_id) REFERENCES public.users(id)
);

-- sales
CREATE TABLE IF NOT EXISTS public.sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    customer_id UUID,
    user_id UUID NOT NULL,
    sale_number TEXT NOT NULL,
    sale_date TIMESTAMP WITH TIME ZONE NOT NULL,
    subtotal NUMERIC NOT NULL,
    discount_amount NUMERIC DEFAULT 0,
    tax_amount NUMERIC DEFAULT 0,
    total_amount NUMERIC NOT NULL,
    payment_method_id UUID,
    payment_status TEXT DEFAULT 'pending', -- 'pending', 'paid', 'cancelled'
    status TEXT DEFAULT 'completed', -- 'draft', 'completed', 'cancelled'
    notes TEXT,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id),
    FOREIGN KEY (user_id) REFERENCES public.users(id),
    FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id)
);

-- sales_items
CREATE TABLE IF NOT EXISTS public.sales_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    sale_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC NOT NULL,
    discount_amount NUMERIC DEFAULT 0,
    total_amount NUMERIC NOT NULL,
    notes TEXT,
    FOREIGN KEY (sale_id) REFERENCES public.sales(id),
    FOREIGN KEY (product_id) REFERENCES public.products(id)
);

-- store_payment_methods
CREATE TABLE IF NOT EXISTS public.store_payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    payment_method_id UUID NOT NULL,
    is_active BOOLEAN DEFAULT true,
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id),
    UNIQUE(store_id, payment_method_id)
);

-- STEP 6: CREATE INDEXES
-- ========================================

-- Business indexes
CREATE INDEX IF NOT EXISTS idx_merchants_business_type ON public.merchants(business_type);
CREATE INDEX IF NOT EXISTS idx_stores_merchant_id ON public.stores(merchant_id);

-- User indexes
CREATE INDEX IF NOT EXISTS idx_users_phone ON public.users(phone);
CREATE INDEX IF NOT EXISTS idx_users_staff_type ON public.users(staff_type);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_merchant_id ON public.customers(merchant_id);
CREATE INDEX IF NOT EXISTS idx_role_assignments_user_id ON public.role_assignments(user_id);
CREATE INDEX IF NOT EXISTS idx_role_assignments_store_id ON public.role_assignments(store_id);

-- Pet indexes
CREATE INDEX IF NOT EXISTS idx_pets_owner_id ON public.pets(owner_id);
CREATE INDEX IF NOT EXISTS idx_pets_pet_category_id ON public.pets(pet_category_id);
CREATE INDEX IF NOT EXISTS idx_pet_schedules_pet_id ON public.pet_schedules(pet_id);
CREATE INDEX IF NOT EXISTS idx_pet_schedules_scheduled_at ON public.pet_schedules(scheduled_at);

-- Product indexes
CREATE INDEX IF NOT EXISTS idx_products_store_id ON public.products(store_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_barcode ON public.products(barcode);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_product_id ON public.inventory_transactions(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_transactions_store_id ON public.inventory_transactions(store_id);

-- Sales indexes
CREATE INDEX IF NOT EXISTS idx_sales_store_id ON public.sales(store_id);
CREATE INDEX IF NOT EXISTS idx_sales_customer_id ON public.sales(customer_id);
CREATE INDEX IF NOT EXISTS idx_sales_sale_date ON public.sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_sales_sale_number ON public.sales(sale_number);

-- STEP 7: INSERT SAMPLE DATA
-- ========================================

-- Insert sample payment types (if not exists)
INSERT INTO public.payment_types (code, name) VALUES
('CASH', 'Cash'),
('CARD', 'Card'),
('TRANSFER', 'Transfer'),
('EWALLET', 'E-Wallet')
ON CONFLICT (code) DO NOTHING;

-- Insert sample payment methods (if not exists)
INSERT INTO public.payment_methods (payment_type_id, code, name) VALUES
((SELECT id FROM public.payment_types WHERE code = 'CASH'), 'CASH', 'Cash'),
((SELECT id FROM public.payment_types WHERE code = 'CARD'), 'VISA', 'Visa'),
((SELECT id FROM public.payment_types WHERE code = 'CARD'), 'MASTERCARD', 'Mastercard'),
((SELECT id FROM public.payment_types WHERE code = 'TRANSFER'), 'BCA', 'BCA Transfer'),
((SELECT id FROM public.payment_types WHERE code = 'EWALLET'), 'GOPAY', 'GoPay')
ON CONFLICT (code) DO NOTHING;

-- STEP 8: VERIFICATION
-- ========================================

-- Check all tables
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;

-- Check table counts
SELECT 'merchants' as table_name, count(*) as count FROM public.merchants
UNION ALL
SELECT 'stores', count(*) FROM public.stores
UNION ALL
SELECT 'users', count(*) FROM public.users
UNION ALL
SELECT 'customers', count(*) FROM public.customers
UNION ALL
SELECT 'pets', count(*) FROM public.pets
UNION ALL
SELECT 'products', count(*) FROM public.products
UNION ALL
SELECT 'sales', count(*) FROM public.sales;

COMMIT; 