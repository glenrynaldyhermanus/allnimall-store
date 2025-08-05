-- ========================================
-- ALLNIMALL PET SHOP POS SCHEMA
-- Enhanced schema with separated users (staff) and customers (pet owners)
-- ========================================

-- ========================================
-- GEOGRAPHY TABLES
-- ========================================

-- countries
CREATE TABLE public.countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL
);

-- provinces
CREATE TABLE public.provinces (
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

-- cities
CREATE TABLE public.cities (
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

-- ========================================
-- CORE BUSINESS TABLES
-- ========================================

-- merchants (pet shop owners/vets)
CREATE TABLE public.merchants (
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
    business_type TEXT DEFAULT 'pet_shop', -- 'pet_shop', 'veterinary', 'grooming'
    description TEXT
);

-- stores (branches of merchants)
CREATE TABLE public.stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    address TEXT,
    merchant_id UUID NOT NULL,
    country_id UUID,
    province_id UUID,
    city_id UUID,
    latitude NUMERIC,
    longitude NUMERIC,
    phone_country_code TEXT NOT NULL DEFAULT '+62',
    phone_number TEXT NOT NULL,
    phone_verified BOOLEAN NOT NULL DEFAULT false,
    business_field TEXT NOT NULL DEFAULT 'pet_shop',
    business_description TEXT,
    stock_setting TEXT NOT NULL DEFAULT 'automatic',
    currency TEXT NOT NULL DEFAULT 'IDR',
    default_tax_rate NUMERIC NOT NULL DEFAULT 0,
    motto TEXT,
    is_branch BOOLEAN NOT NULL DEFAULT true,
    is_online_delivery_active BOOLEAN DEFAULT false,
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (country_id) REFERENCES public.countries(id),
    FOREIGN KEY (province_id) REFERENCES public.provinces(id),
    FOREIGN KEY (city_id) REFERENCES public.cities(id)
);

-- ========================================
-- USER MANAGEMENT & ROLES
-- ========================================

-- users (staff/employees)
CREATE TABLE public.users (
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
    -- Authentication fields for Supabase
    auth_id UUID, -- Supabase auth ID for staff authentication
    username TEXT UNIQUE, -- Username for staff login (used to find email for Supabase auth)
    -- Staff-specific fields
    role_id UUID,
    store_id UUID,
    is_active BOOLEAN NOT NULL DEFAULT true,
    staff_type TEXT DEFAULT 'general', -- 'cashier', 'vet', 'groomer', 'admin'
    hire_date DATE,
    salary NUMERIC,
    emergency_contact TEXT,
    FOREIGN KEY (role_id) REFERENCES public.roles(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- customers (pet owners) - Universal customer data
CREATE TABLE public.customers (
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
    -- Authentication field for Allnimall login
    auth_id UUID, -- Supabase auth ID. NULL = customer not logged in to Allnimall, NOT NULL = customer logged in to Allnimall
    -- Customer-specific fields
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
    FOREIGN KEY (city_id) REFERENCES public.cities(id),
    FOREIGN KEY (province_id) REFERENCES public.provinces(id),
    FOREIGN KEY (country_id) REFERENCES public.countries(id)
);

-- roles
CREATE TABLE public.roles (
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
CREATE TABLE public.role_assignments (
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

-- merchant_customers (mapping between merchants and customers)
CREATE TABLE public.merchant_customers (
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
-- PET-SPECIFIC TABLES
-- ========================================

-- characters (pet character traits)
CREATE TABLE public.characters (
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

-- pet_categories
CREATE TABLE public.pet_categories (
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

-- pets
CREATE TABLE public.pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    owner_id UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid, -- references customers.id
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
    vaccination_status TEXT DEFAULT 'unknown', -- 'complete', 'partial', 'none', 'unknown'
    FOREIGN KEY (pet_category_id) REFERENCES public.pet_categories(id),
    FOREIGN KEY (owner_id) REFERENCES public.customers(id)
);

-- pet_characters
CREATE TABLE public.pet_characters (
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

-- pet_healths
CREATE TABLE public.pet_healths (
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
    weight_history JSONB, -- Store weight tracking over time
    temperature_history JSONB, -- Store temperature readings
    next_vaccination_due DATE,
    next_deworming_due DATE,
    vet_notes TEXT,
    FOREIGN KEY (pet_id) REFERENCES public.pets(id)
);

-- ========================================
-- PRODUCT MANAGEMENT
-- ========================================

-- products_categories
CREATE TABLE public.products_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    store_id UUID NOT NULL,
    pet_category_id UUID,
    parent_category_id UUID, -- for nested categories
    type TEXT DEFAULT 'item', -- 'item' atau 'service'
    FOREIGN KEY (pet_category_id) REFERENCES public.pet_categories(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (parent_category_id) REFERENCES public.products_categories(id)
);

-- products
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    name TEXT NOT NULL,
    picture_url TEXT,
    store_id UUID NOT NULL,
    category_id UUID,
    purchase_price NUMERIC NOT NULL DEFAULT 0,
    price NUMERIC NOT NULL DEFAULT 0, -- selling price
    expired_date DATE,
    stock INTEGER NOT NULL DEFAULT 0,
    min_stock INTEGER NOT NULL DEFAULT 0,
    max_stock INTEGER,
    -- Product details
    code TEXT UNIQUE,
    barcode TEXT,
    unit TEXT DEFAULT 'pcs',
    weight_grams INTEGER NOT NULL DEFAULT 0,
    description TEXT,
    ingredients TEXT,
    usage_instructions TEXT,
    age_recommendation TEXT,
    pet_size_recommendation TEXT, -- 'small', 'medium', 'large', 'all'
    -- Business fields
    discount_type INTEGER NOT NULL DEFAULT 1, -- 1=none, 2=percentage, 3=fixed
    discount_value NUMERIC NOT NULL DEFAULT 0, -- Discount amount - percentage (if discount_type=2) or fixed amount (if discount_type=3)
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_prescription_required BOOLEAN DEFAULT false,
    shelf_life_days INTEGER,
    storage_instructions TEXT,
    -- Service fields
    product_type TEXT DEFAULT 'item', -- 'item' atau 'service'
    duration_minutes INTEGER, -- untuk jasa yang berdurasi
    service_category TEXT, -- kategori jasa (grooming, veterinary, dll)
    FOREIGN KEY (category_id) REFERENCES public.products_categories(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- ========================================
-- INVENTORY MANAGEMENT
-- ========================================

-- inventory_transactions
CREATE TABLE public.inventory_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    product_id UUID NOT NULL,
    store_id UUID NOT NULL,
    type INTEGER NOT NULL, -- 1=in, 2=out, 3=adjustment, 4=expired, 5=damaged
    quantity NUMERIC NOT NULL,
    reference TEXT,
    note TEXT,
    previous_qty NUMERIC,
    new_qty NUMERIC,
    batch_number TEXT,
    expiry_date DATE,
    unit_cost NUMERIC,
    total_cost NUMERIC,
    FOREIGN KEY (product_id) REFERENCES public.products(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- ========================================
-- PAYMENT SYSTEM
-- ========================================

-- payment_types
CREATE TABLE public.payment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    code TEXT NOT NULL,
    name TEXT NOT NULL
);

-- payment_methods
CREATE TABLE public.payment_methods (
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

-- store_payment_methods
CREATE TABLE public.store_payment_methods (
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

-- ========================================
-- SALES SYSTEM
-- ========================================

-- store_carts (cart header)
CREATE TABLE public.store_carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    session_id TEXT, -- for anonymous sessions
    customer_id UUID, -- for logged in customers
    status TEXT NOT NULL DEFAULT 'active', -- 'active', 'completed', 'abandoned'
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id)
);

-- store_cart_items (cart items)
CREATE TABLE public.store_cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    cart_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 1,
    unit_price NUMERIC NOT NULL DEFAULT 0,
    FOREIGN KEY (cart_id) REFERENCES public.store_carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES public.products(id)
);

-- sales
CREATE TABLE public.sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    customer_id UUID,
    customer_name TEXT,
    customer_phone TEXT,
    customer_email TEXT,
    sale_number TEXT NOT NULL,
    sale_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    subtotal NUMERIC NOT NULL DEFAULT 0,
    discount_amount NUMERIC NOT NULL DEFAULT 0,
    tax_amount NUMERIC NOT NULL DEFAULT 0,
    total_amount NUMERIC NOT NULL DEFAULT 0,
    payment_method_id UUID,
    status TEXT NOT NULL DEFAULT 'completed', -- 'completed', 'pending', 'cancelled'
    notes TEXT,
    cashier_id UUID,
    -- Pet-specific fields
    pet_id UUID, -- if purchase is for specific pet
    service_type TEXT, -- 'retail', 'grooming', 'medical', 'boarding'
    appointment_id UUID, -- link to appointment if applicable
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id),
    FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id),
    FOREIGN KEY (cashier_id) REFERENCES public.users(id),
    FOREIGN KEY (pet_id) REFERENCES public.pets(id)
);

-- sales_items
CREATE TABLE public.sales_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    sale_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity NUMERIC NOT NULL,
    unit_price NUMERIC NOT NULL,
    discount_amount NUMERIC NOT NULL DEFAULT 0,
    tax_amount NUMERIC NOT NULL DEFAULT 0,
    total_amount NUMERIC NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES public.sales(id),
    FOREIGN KEY (product_id) REFERENCES public.products(id)
);

-- ========================================
-- PET SCHEDULING SYSTEM
-- ========================================

-- schedule_types
CREATE TABLE public.schedule_types (
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
    category TEXT DEFAULT 'general' -- 'medical', 'grooming', 'general', 'medication', 'feeding'
);

-- pet_schedules
CREATE TABLE public.pet_schedules (
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
    recurring_pattern TEXT, -- 'daily', 'weekly', 'monthly', 'custom'
    recurring_interval INTEGER DEFAULT 1,
    recurring_end_date DATE,
    priority TEXT DEFAULT 'medium', -- 'low', 'medium', 'high', 'urgent'
    -- Staff assignment
    assigned_staff_id UUID,
    service_fee NUMERIC DEFAULT 0,
    status TEXT DEFAULT 'scheduled', -- 'scheduled', 'in_progress', 'completed', 'cancelled', 'no_show'
    FOREIGN KEY (pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (schedule_type_id) REFERENCES public.schedule_types(id),
    FOREIGN KEY (assigned_staff_id) REFERENCES public.users(id)
);

-- schedule_recurring_patterns
CREATE TABLE public.schedule_recurring_patterns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    schedule_id UUID NOT NULL,
    day_of_week INTEGER[], -- 0=Sunday, 1=Monday, etc.
    day_of_month INTEGER[],
    month_of_year INTEGER[],
    specific_dates DATE[],
    time_of_day TIME,
    end_date DATE,
    FOREIGN KEY (schedule_id) REFERENCES public.pet_schedules(id)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- User and role indexes
CREATE INDEX idx_users_phone ON public.users(phone);
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_auth_id ON public.users(auth_id);
CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_role_assignments_user_id ON public.role_assignments(user_id);
CREATE INDEX idx_role_assignments_store_id ON public.role_assignments(store_id);

-- Customer indexes
CREATE INDEX idx_customers_phone ON public.customers(phone);
CREATE INDEX idx_customers_email ON public.customers(email);
CREATE INDEX idx_customers_auth_id ON public.customers(auth_id);

-- Merchant customers indexes
CREATE INDEX idx_merchant_customers_merchant_id ON public.merchant_customers(merchant_id);
CREATE INDEX idx_merchant_customers_customer_id ON public.merchant_customers(customer_id);
CREATE INDEX idx_merchant_customers_store_id ON public.merchant_customers(store_id);
CREATE INDEX idx_merchant_customers_is_active ON public.merchant_customers(is_active);

-- Pet indexes
CREATE INDEX idx_pets_owner_id ON public.pets(owner_id);
CREATE INDEX idx_pets_pet_category_id ON public.pets(pet_category_id);
CREATE INDEX idx_pet_schedules_pet_id ON public.pet_schedules(pet_id);
CREATE INDEX idx_pet_schedules_scheduled_at ON public.pet_schedules(scheduled_at);

-- Product indexes
CREATE INDEX idx_products_store_id ON public.products(store_id);
CREATE INDEX idx_products_category_id ON public.products(category_id);
CREATE INDEX idx_products_code ON public.products(code);
CREATE INDEX idx_products_barcode ON public.products(barcode);
CREATE INDEX idx_products_product_type ON public.products(product_type);
CREATE INDEX idx_products_service_category ON public.products(service_category);
CREATE INDEX idx_products_categories_type ON public.products_categories(type);

-- Sales indexes
CREATE INDEX idx_sales_store_id ON public.sales(store_id);
CREATE INDEX idx_sales_customer_id ON public.sales(customer_id);
CREATE INDEX idx_sales_sale_date ON public.sales(sale_date);
CREATE INDEX idx_sales_sale_number ON public.sales(sale_number);

-- Inventory indexes
CREATE INDEX idx_inventory_transactions_product_id ON public.inventory_transactions(product_id);
CREATE INDEX idx_inventory_transactions_store_id ON public.inventory_transactions(store_id);
CREATE INDEX idx_inventory_transactions_created_at ON public.inventory_transactions(created_at);

-- ========================================
-- SAMPLE DATA INSERTS
-- ========================================

-- Insert default payment types
INSERT INTO public.payment_types (code, name) VALUES
('CASH', 'Cash'),
('CARD', 'Card'),
('TRANSFER', 'Transfer'),
('EWALLET', 'E-Wallet')
ON CONFLICT (code) DO NOTHING;

-- Insert default payment methods
INSERT INTO public.payment_methods (payment_type_id, code, name) VALUES
((SELECT id FROM public.payment_types WHERE code = 'CASH'), 'CASH', 'Cash'),
((SELECT id FROM public.payment_types WHERE code = 'CARD'), 'VISA', 'Visa'),
((SELECT id FROM public.payment_types WHERE code = 'CARD'), 'MASTERCARD', 'Mastercard'),
((SELECT id FROM public.payment_types WHERE code = 'TRANSFER'), 'BCA', 'BCA Transfer'),
((SELECT id FROM public.payment_types WHERE code = 'EWALLET'), 'GOPAY', 'GoPay')
ON CONFLICT (code) DO NOTHING;

-- Insert default roles
INSERT INTO public.roles (name, description, permissions) VALUES
('owner', 'Business Owner', ARRAY['all']),
('admin', 'Store Administrator', ARRAY['manage_store', 'manage_staff', 'view_reports']),
('cashier', 'Cashier', ARRAY['process_sales', 'manage_inventory']),
('vet', 'Veterinarian', ARRAY['manage_pets', 'manage_schedules', 'view_health_records']),
('groomer', 'Pet Groomer', ARRAY['manage_schedules', 'view_pets'])
ON CONFLICT DO NOTHING;

-- Insert default pet categories
INSERT INTO public.pet_categories (name_en, name_id) VALUES
('Dog', 'Anjing'),
('Cat', 'Kucing'),
('Bird', 'Burung'),
('Fish', 'Ikan'),
('Rabbit', 'Kelinci'),
('Hamster', 'Hamster'),
('Reptile', 'Reptil')
ON CONFLICT DO NOTHING;

-- Insert default schedule types
INSERT INTO public.schedule_types (name, description, icon, color, is_recurring, default_duration_minutes, category) VALUES
('Vaccination', 'Pet vaccination appointment', 'vaccine', '#ff6b6b', false, 30, 'medical'),
('Grooming', 'Pet grooming session', 'scissors', '#4ecdc4', false, 60, 'grooming'),
('Health Checkup', 'General health examination', 'stethoscope', '#45b7d1', false, 45, 'medical'),
('Medication', 'Medication administration', 'pill', '#96ceb4', true, 5, 'medical'),
('Feeding', 'Feeding schedule', 'bowl', '#feca57', true, 10, 'feeding'),
('Exercise', 'Exercise and play time', 'run', '#ff9ff3', true, 30, 'general'),
('Deworming', 'Deworming treatment', 'bug', '#54a0ff', false, 15, 'medical')
ON CONFLICT DO NOTHING;

-- Insert sample characters
INSERT INTO public.characters (character_en, character_id, good_character) VALUES
('Friendly', 'ramah', true),
('Aggressive', 'agresif', false),
('Playful', 'suka_bermain', true),
('Shy', 'pemalu', true),
('Energetic', 'energik', true),
('Calm', 'tenang', true),
('Protective', 'protektif', true),
('Destructive', 'merusak', false),
('Loyal', 'setia', true),
('Independent', 'mandiri', true)
ON CONFLICT DO NOTHING;

-- Insert sample geography data (Indonesia)
INSERT INTO public.countries (name) VALUES ('Indonesia')
ON CONFLICT DO NOTHING;

INSERT INTO public.provinces (name, country_id) 
SELECT 'DKI Jakarta', id FROM public.countries WHERE name = 'Indonesia'
UNION ALL
SELECT 'Jawa Barat', id FROM public.countries WHERE name = 'Indonesia'
UNION ALL
SELECT 'Jawa Tengah', id FROM public.countries WHERE name = 'Indonesia'
UNION ALL
SELECT 'Jawa Timur', id FROM public.countries WHERE name = 'Indonesia'
UNION ALL
SELECT 'Bali', id FROM public.countries WHERE name = 'Indonesia'
ON CONFLICT DO NOTHING;

-- Insert sample cities for DKI Jakarta
INSERT INTO public.cities (name, province_id)
SELECT 'Jakarta Pusat', id FROM public.provinces WHERE name = 'DKI Jakarta'
UNION ALL
SELECT 'Jakarta Selatan', id FROM public.provinces WHERE name = 'DKI Jakarta'
UNION ALL
SELECT 'Jakarta Timur', id FROM public.provinces WHERE name = 'DKI Jakarta'
UNION ALL
SELECT 'Jakarta Barat', id FROM public.provinces WHERE name = 'DKI Jakarta'
UNION ALL
SELECT 'Jakarta Utara', id FROM public.provinces WHERE name = 'DKI Jakarta'
ON CONFLICT DO NOTHING;

-- Insert sample merchants
INSERT INTO public.merchants (name, business_type, description) VALUES
('Allnimall Pet Shop', 'pet_shop', 'Premium pet shop with veterinary services')
ON CONFLICT DO NOTHING;

-- Insert sample stores
INSERT INTO public.stores (name, merchant_id, business_field, business_description) 
SELECT 'Allnimall Pet Shop - Jakarta Selatan', id, 'pet_shop', 'Main branch in South Jakarta'
FROM public.merchants WHERE name = 'Allnimall Pet Shop'
ON CONFLICT DO NOTHING;

-- Insert sample users (staff)
INSERT INTO public.users (name, phone, email, username, staff_type, store_id) 
SELECT 
    'Demo Staff',
    '+6281234567890',
    'demo@allnimall.com',
    'demo',
    'cashier',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert another test user
INSERT INTO public.users (name, phone, email, username, staff_type, store_id) 
SELECT 
    'Admin Staff',
    '+6281314169140',
    'admin@allnimall.com',
    'admin',
    'admin',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- ========================================
-- HELPER FUNCTIONS FOR UNIFIED CUSTOMER ARCHITECTURE
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
-- COMMENTS FOR DOCUMENTATION
-- ========================================

COMMENT ON TABLE public.merchants IS 'Pet shop owners, veterinary clinics, or grooming services that use the POS system';
COMMENT ON TABLE public.stores IS 'Physical locations/branches of merchants';
COMMENT ON TABLE public.users IS 'Staff/employees of the pet shop with role-based access and Supabase authentication';
COMMENT ON TABLE public.customers IS 'Universal customer data - pet owners who can be registered with multiple merchants. auth_id determines Allnimall login status';
COMMENT ON TABLE public.merchant_customers IS 'Mapping table between merchants and customers. One customer can be registered with multiple merchants';
COMMENT ON TABLE public.pets IS 'Pet information registered in the system for tracking health and services. Linked to customers, accessible across all merchants when customer logs in';
COMMENT ON TABLE public.pet_healths IS 'Detailed health records for each pet including vaccination, medication, and vet visit history';
COMMENT ON TABLE public.pet_schedules IS 'Scheduling system for pet appointments, grooming, medication reminders, etc.';
COMMENT ON TABLE public.products IS 'Pet products and services with specific fields for pet shop needs. Supports both physical products (items) and services (grooming, veterinary, etc.)';
COMMENT ON TABLE public.sales IS 'Sales transactions with pet-specific fields for service type and pet association';

-- ========================================
-- SCHEMA COMPLETION MESSAGE
-- ========================================

-- This schema provides:
-- 1. Complete POS functionality (sales, inventory, payment management)
-- 2. Pet-specific features (health tracking, scheduling, grooming)
-- 3. Unified customer architecture (one customer can be registered with multiple merchants)
-- 4. Supabase authentication for both staff and customers
-- 5. Role-based access control for multi-user stores
-- 6. Comprehensive business management tools
-- 7. Geographic support for Indonesia
-- 8. Performance optimized with proper indexes
-- 9. Helper functions for customer-merchant relationships
-- 10. Sample data for quick development start

-- ========================================
-- SAMPLE SERVICE DATA
-- ========================================

-- Insert sample service products
INSERT INTO public.products (
    name,
    price,
    purchase_price,
    stock,
    product_type,
    service_category,
    duration_minutes,
    description,
    store_id
) 
SELECT 
    'Grooming Anjing Kecil',
    150000,
    0,
    0,
    'service',
    'grooming',
    120,
    'Grooming lengkap untuk anjing kecil (bawah 10kg)',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (
    name,
    price,
    purchase_price,
    stock,
    product_type,
    service_category,
    duration_minutes,
    description,
    store_id
) 
SELECT 
    'Grooming Anjing Besar',
    200000,
    0,
    0,
    'service',
    'grooming',
    180,
    'Grooming lengkap untuk anjing besar (diatas 10kg)',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (
    name,
    price,
    purchase_price,
    stock,
    product_type,
    service_category,
    duration_minutes,
    description,
    store_id
) 
SELECT 
    'Konsultasi Dokter Hewan',
    100000,
    0,
    0,
    'service',
    'veterinary',
    30,
    'Konsultasi kesehatan hewan dengan dokter hewan',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (
    name,
    price,
    purchase_price,
    stock,
    product_type,
    service_category,
    duration_minutes,
    description,
    store_id
) 
SELECT 
    'Vaksinasi Dasar',
    250000,
    0,
    0,
    'service',
    'vaccination',
    45,
    'Vaksinasi dasar untuk anjing/kucing',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (
    name,
    price,
    purchase_price,
    stock,
    product_type,
    service_category,
    duration_minutes,
    description,
    store_id
) 
SELECT 
    'Antar Jemput Pet',
    50000,
    0,
    0,
    'service',
    'transportation',
    60,
    'Layanan antar jemput hewan peliharaan',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- ========================================
-- SAMPLE CATEGORIES DATA
-- ========================================

-- Insert sample categories for items
INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Makanan Anjing',
    'item',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Makanan Kucing',
    'item',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Obat-obatan',
    'item',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Aksesoris',
    'item',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Vitamin & Suplemen',
    'item',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert sample categories for services
INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Grooming',
    'service',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Kedokteran Hewan',
    'service',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Pelatihan',
    'service',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Penitipan',
    'service',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products_categories (
    name,
    type,
    store_id
) 
SELECT 
    'Transportasi',
    'service',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Ready for implementation with Allnimall Unified Customer Architecture! 

-- ========================================
-- UNIFIED BOOKING SYSTEM
-- ========================================

-- Tabel untuk partnership merchant dengan Allnimall
CREATE TABLE public.merchant_partnerships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    merchant_id UUID NOT NULL,
    store_id UUID NOT NULL,
    partnership_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'active', 'suspended', 'terminated'
    partnership_type TEXT NOT NULL DEFAULT 'service_provider', -- 'service_provider', 'product_supplier', 'both'
    commission_rate NUMERIC DEFAULT 0, -- persentase komisi untuk Allnimall
    service_areas JSONB, -- area yang dilayani
    is_featured BOOLEAN DEFAULT false,
    partnership_start_date DATE,
    partnership_end_date DATE,
    
    FOREIGN KEY (merchant_id) REFERENCES public.merchants(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id)
);

-- Tabel untuk service availability per merchant
CREATE TABLE public.merchant_service_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    store_id UUID NOT NULL,
    service_product_id UUID NOT NULL,
    day_of_week INTEGER NOT NULL, -- 0=Sunday, 1=Monday, etc.
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_duration_minutes INTEGER DEFAULT 60,
    max_concurrent_bookings INTEGER DEFAULT 1,
    is_available BOOLEAN DEFAULT true,
    
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (service_product_id) REFERENCES public.products(id)
);

-- Tabel utama untuk semua jenis booking
CREATE TABLE public.service_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    -- Booking source & reference
    booking_source TEXT NOT NULL, -- 'merchant_online_store', 'allnimall_app', 'offline_store'
    booking_reference TEXT UNIQUE, -- nomor referensi booking (format: BK-YYYYMMDD-XXXX)
    
    -- Customer & Pet (Pet bisa optional)
    customer_id UUID NOT NULL,
    pet_id UUID, -- NULL jika tidak ada pet
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_email TEXT,
    
    -- Service & Store
    store_id UUID NOT NULL,
    service_product_id UUID NOT NULL,
    service_name TEXT NOT NULL,
    
    -- Appointment details
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    duration_minutes INTEGER NOT NULL,
    
    -- Service location
    service_type TEXT NOT NULL DEFAULT 'in_store', -- 'in_store', 'on_site'
    customer_address TEXT, -- untuk on-site service
    latitude NUMERIC,
    longitude NUMERIC,
    
    -- Status tracking
    status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'
    payment_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'paid', 'refunded'
    
    -- Financial
    service_fee NUMERIC NOT NULL DEFAULT 0,
    on_site_fee NUMERIC DEFAULT 0,
    discount_amount NUMERIC DEFAULT 0,
    total_amount NUMERIC NOT NULL DEFAULT 0,
    
    -- Staff assignment
    assigned_staff_id UUID,
    staff_notes TEXT,
    customer_notes TEXT,
    
    -- Allnimall specific
    allnimall_commission NUMERIC DEFAULT 0,
    partnership_id UUID, -- link ke merchant_partnerships jika dari Allnimall
    
    -- Links
    sale_id UUID, -- link ke sales table
    
    FOREIGN KEY (customer_id) REFERENCES public.customers(id),
    FOREIGN KEY (pet_id) REFERENCES public.pets(id),
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (service_product_id) REFERENCES public.products(id),
    FOREIGN KEY (assigned_staff_id) REFERENCES public.users(id),
    FOREIGN KEY (partnership_id) REFERENCES public.merchant_partnerships(id),
    FOREIGN KEY (sale_id) REFERENCES public.sales(id)
);

-- ========================================
-- CALENDAR-STYLE BOOKING SYSTEM
-- ========================================
-- 
-- FLOW BOOKING SYSTEM:
-- 1. User pilih tanggal di UI
-- 2. User tekan tombol "Pilih Time Slot" 
-- 3. Dialog muncul dengan matrix:
--    - Baris: Jam operasional (08:00-17:00)
--    - Kolom: Semua staff yang aktif
--    - Cell: Status availability per staff per jam (✅/❌)
-- 4. User pilih jam & staff yang available
-- 5. User konfirmasi booking
-- 6. Booking masuk ke cart dengan detail: nama produk, staff, estimasi waktu
-- 
-- KEUNGGULAN FLOW INI:
-- ✅ Tidak perlu pre-generate slot di database
-- ✅ Otomatis generate 24 jam setiap pilih tanggal
-- ✅ Cek real-time dari service_bookings
-- ✅ Seperti Google Calendar
-- ✅ Tidak ada risiko lupa generate slot
-- ✅ Fleksibel untuk multiple staff per jam
-- 
-- DATA SOURCE:
-- - service_bookings: Data booking aktual
-- - users + role_assignments: Data staff aktif
-- - products: Data service dengan durasi
-- 
-- FUNCTION UTAMA:
-- - get_calendar_slots_with_staff(): Generate matrix jam × staff
-- - is_staff_available_for_range(): Validasi booking dengan durasi > 1 jam

-- ========================================
-- BOOKING SYSTEM INDEXES
-- ========================================

-- Booking indexes
CREATE INDEX idx_service_bookings_booking_source ON public.service_bookings(booking_source);
CREATE INDEX idx_service_bookings_booking_reference ON public.service_bookings(booking_reference);
CREATE INDEX idx_service_bookings_customer_id ON public.service_bookings(customer_id);
CREATE INDEX idx_service_bookings_store_id ON public.service_bookings(store_id);
CREATE INDEX idx_service_bookings_service_product_id ON public.service_bookings(service_product_id);
CREATE INDEX idx_service_bookings_booking_date ON public.service_bookings(booking_date);
CREATE INDEX idx_service_bookings_status ON public.service_bookings(status);
CREATE INDEX idx_service_bookings_payment_status ON public.service_bookings(payment_status);
CREATE INDEX idx_service_bookings_assigned_staff_id ON public.service_bookings(assigned_staff_id);

-- ========================================
-- CALENDAR-STYLE BOOKING FUNCTIONS
-- ========================================

-- Function untuk generate matrix jam × staff dengan status availability
-- Digunakan untuk UI calendar-style booking
CREATE OR REPLACE FUNCTION get_calendar_slots_with_staff(
    p_store_id UUID,
    p_service_product_id UUID,
    p_booking_date DATE,
    p_start_hour INTEGER DEFAULT 8,
    p_end_hour INTEGER DEFAULT 17
)
RETURNS TABLE (
    slot_time TEXT,
    staff_id UUID,
    staff_name TEXT,
    staff_phone TEXT,
    avatar TEXT,
    is_available BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    WITH time_slots AS (
        SELECT 
            to_char(
                (make_time(p_start_hour, 0, 0) + (INTERVAL '1 hour' * generate_series(0, p_end_hour - p_start_hour))
            ), 'HH24:MI') as slot_time
    ),
    all_staff AS (
        SELECT 
            u.id as staff_id,
            u.name as staff_name,
            u.phone as staff_phone,
            LEFT(u.name, 2) as avatar
        FROM public.users u
        JOIN public.role_assignments ra ON u.id = ra.user_id
        WHERE ra.store_id = p_store_id
        AND ra.is_active = true
        AND u.is_active = true
    ),
    bookings AS (
        SELECT 
            sb.assigned_staff_id,
            sb.booking_time,
            sb.duration_minutes
        FROM public.service_bookings sb
        WHERE sb.store_id = p_store_id
        AND sb.service_product_id = p_service_product_id
        AND sb.booking_date = p_booking_date
        AND sb.status NOT IN ('cancelled', 'no_show')
    )
    SELECT 
        ts.slot_time,
        s.staff_id,
        s.staff_name,
        s.staff_phone,
        s.avatar,
        -- Cek apakah staff available di jam ts.slot_time
        NOT EXISTS (
            SELECT 1 FROM bookings b
            WHERE b.assigned_staff_id = s.staff_id
            AND (
                -- Cek overlap: jam yang dipilih ada di range booking
                ts.slot_time::time >= b.booking_time
                AND ts.slot_time::time < (b.booking_time + (b.duration_minutes || ' minutes')::interval)
            )
        ) AS is_available
    FROM time_slots ts
    CROSS JOIN all_staff s
    ORDER BY ts.slot_time, s.staff_name;
END;
$$ LANGUAGE plpgsql;

-- Function untuk validasi staff availability untuk range jam tertentu
-- Digunakan untuk booking dengan durasi lebih dari 1 jam
CREATE OR REPLACE FUNCTION is_staff_available_for_range(
    p_store_id UUID,
    p_service_product_id UUID,
    p_booking_date DATE,
    p_staff_id UUID,
    p_start_time TIME,
    p_duration_minutes INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    conflict_count INTEGER;
BEGIN
    SELECT COUNT(1)
    INTO conflict_count
    FROM public.service_bookings sb
    WHERE sb.store_id = p_store_id
    AND sb.service_product_id = p_service_product_id
    AND sb.booking_date = p_booking_date
    AND sb.assigned_staff_id = p_staff_id
    AND sb.status NOT IN ('cancelled', 'no_show')
    AND (
        -- Cek overlap waktu
        (p_start_time, (p_start_time + (p_duration_minutes || ' minutes')::interval)::time)
        OVERLAPS
        (sb.booking_time, (sb.booking_time + (sb.duration_minutes || ' minutes')::interval)::time)
    );

    RETURN conflict_count = 0;
END;
$$ LANGUAGE plpgsql;

-- Partnership indexes
CREATE INDEX idx_merchant_partnerships_merchant_id ON public.merchant_partnerships(merchant_id);
CREATE INDEX idx_merchant_partnerships_store_id ON public.merchant_partnerships(store_id);
CREATE INDEX idx_merchant_partnerships_partnership_status ON public.merchant_partnerships(partnership_status);

-- Availability indexes
CREATE INDEX idx_merchant_service_availability_store_id ON public.merchant_service_availability(store_id);
CREATE INDEX idx_merchant_service_availability_service_product_id ON public.merchant_service_availability(service_product_id);
CREATE INDEX idx_merchant_service_availability_day_of_week ON public.merchant_service_availability(day_of_week);

-- ========================================
-- BOOKING SYSTEM HELPER FUNCTIONS
-- ========================================

-- Function untuk generate booking reference
CREATE OR REPLACE FUNCTION generate_booking_reference()
RETURNS TEXT AS $$
DECLARE
    today_date TEXT;
    sequence_number INTEGER;
    booking_ref TEXT;
BEGIN
    today_date := to_char(current_date, 'YYYYMMDD');
    
    -- Get next sequence number for today
    SELECT COALESCE(MAX(CAST(SUBSTRING(booking_reference FROM 13) AS INTEGER)), 0) + 1
    INTO sequence_number
    FROM public.service_bookings
    WHERE booking_reference LIKE 'BK-' || today_date || '-%';
    
    booking_ref := 'BK-' || today_date || '-' || LPAD(sequence_number::TEXT, 4, '0');
    
    RETURN booking_ref;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- CALENDAR-STYLE BOOKING SYSTEM DOCUMENTATION
-- ========================================
-- 
-- PERUBAHAN ARSITEKTUR:
-- ❌ Dihapus: Tabel booking_slots (pre-generate slot)
-- ❌ Dihapus: Function check_slot_availability, get_available_slots, update_slot_capacity
-- ✅ Ditambah: Function get_calendar_slots_with_staff() untuk matrix jam × staff
-- ✅ Ditambah: Function is_staff_available_for_range() untuk validasi durasi > 1 jam
-- 
-- FLOW BOOKING SYSTEM BARU:
-- 1. User pilih tanggal di UI
-- 2. User tekan tombol "Pilih Time Slot" 
-- 3. Dialog muncul dengan matrix:
--    - Baris: Jam operasional (08:00-17:00) - otomatis generate
--    - Kolom: Semua staff yang aktif di store tersebut
--    - Cell: Status availability per staff per jam (✅/❌)
-- 4. User pilih jam & staff yang available
-- 5. User konfirmasi booking
-- 6. Booking masuk ke cart dengan detail: nama produk, staff, estimasi waktu
-- 
-- KEUNGGULAN FLOW INI:
-- ✅ Tidak perlu pre-generate slot di database
-- ✅ Otomatis generate 24 jam setiap pilih tanggal
-- ✅ Cek real-time dari service_bookings
-- ✅ Seperti Google Calendar
-- ✅ Tidak ada risiko lupa generate slot
-- ✅ Fleksibel untuk multiple staff per jam
-- ✅ Support durasi service > 1 jam
-- 
-- DATA SOURCE:
-- - service_bookings: Data booking aktual (source of truth)
-- - users + role_assignments: Data staff aktif
-- - products: Data service dengan durasi
-- 
-- FUNCTION UTAMA:
-- - get_calendar_slots_with_staff(): Generate matrix jam × staff
-- - is_staff_available_for_range(): Validasi booking dengan durasi > 1 jam
-- 
-- CONTOH PENGGUNAAN:
-- SELECT * FROM get_calendar_slots_with_staff(
--     'store_id_xxx', 
--     'service_id_yyy', 
--     '2025-01-06'
-- );
-- 
-- Hasil: Matrix dengan kolom slot_time, staff_id, staff_name, is_available
-- untuk setiap kombinasi jam (08:00-17:00) × staff aktif

-- ========================================
-- SAMPLE BOOKING DATA
-- ========================================

-- Insert sample merchant partnership
INSERT INTO public.merchant_partnerships (
    merchant_id,
    store_id,
    partnership_status,
    partnership_type,
    commission_rate,
    service_areas,
    is_featured,
    partnership_start_date
) 
SELECT 
    m.id,
    s.id,
    'active',
    'service_provider',
    10.0, -- 10% komisi untuk Allnimall
    '{"areas": ["Jakarta Selatan", "Jakarta Pusat"], "radius_km": 15}',
    true,
    current_date
FROM public.merchants m
JOIN public.stores s ON s.merchant_id = m.id
WHERE m.name = 'Allnimall Pet Shop'
AND s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert sample service availability
INSERT INTO public.merchant_service_availability (
    store_id,
    service_product_id,
    day_of_week,
    start_time,
    end_time,
    slot_duration_minutes,
    max_concurrent_bookings
) 
SELECT 
    s.id,
    p.id,
    1, -- Monday
    '09:00',
    '17:00',
    120, -- 2 hours
    1
FROM public.stores s
JOIN public.products p ON p.store_id = s.id
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
AND p.name = 'Grooming Anjing Kecil'
AND p.product_type = 'service'
ON CONFLICT DO NOTHING;

-- ========================================
-- SAMPLE BOOKING DATA (CALENDAR-STYLE)
-- ========================================

-- Insert sample service bookings untuk testing calendar-style
INSERT INTO public.service_bookings (
    booking_source,
    booking_reference,
    customer_id,
    customer_name,
    customer_phone,
    store_id,
    service_product_id,
    service_name,
    booking_date,
    booking_time,
    duration_minutes,
    status,
    payment_status,
    service_fee,
    total_amount,
    assigned_staff_id
) 
SELECT 
    'merchant_online_store',
    generate_booking_reference(),
    c.id,
    c.name,
    c.phone,
    s.id,
    p.id,
    p.name,
    current_date,
    '10:00',
    p.duration_minutes,
    'confirmed',
    'paid',
    p.price,
    p.price,
    u.id
FROM public.stores s
JOIN public.products p ON p.store_id = s.id
JOIN public.users u ON u.store_id = s.id
JOIN public.customers c ON c.id = (
    SELECT id FROM public.customers LIMIT 1
)
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
AND p.name = 'Grooming Anjing Kecil'
AND p.product_type = 'service'
AND u.name = 'Demo Staff'
ON CONFLICT DO NOTHING;

-- Insert sample booking untuk staff lain di jam yang sama (testing multiple staff)
INSERT INTO public.service_bookings (
    booking_source,
    booking_reference,
    customer_id,
    customer_name,
    customer_phone,
    store_id,
    service_product_id,
    service_name,
    booking_date,
    booking_time,
    duration_minutes,
    status,
    payment_status,
    service_fee,
    total_amount,
    assigned_staff_id
) 
SELECT 
    'merchant_online_store',
    generate_booking_reference(),
    c.id,
    c.name,
    c.phone,
    s.id,
    p.id,
    p.name,
    current_date,
    '10:00',
    p.duration_minutes,
    'confirmed',
    'paid',
    p.price,
    p.price,
    u.id
FROM public.stores s
JOIN public.products p ON p.store_id = s.id
JOIN public.users u ON u.store_id = s.id
JOIN public.customers c ON c.id = (
    SELECT id FROM public.customers LIMIT 1
)
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
AND p.name = 'Grooming Anjing Besar'
AND p.product_type = 'service'
AND u.name = 'Admin Staff'
ON CONFLICT DO NOTHING;

-- ========================================
-- BOOKING SYSTEM COMMENTS
-- ========================================

COMMENT ON TABLE public.merchant_partnerships IS 'Partnership antara merchant dengan Allnimall untuk layanan jasa';
COMMENT ON TABLE public.merchant_service_availability IS 'Jadwal availability layanan per merchant';
COMMENT ON TABLE public.service_bookings IS 'Sistem booking terpadu untuk semua jenis booking (merchant online, Allnimall app, offline store)';
COMMENT ON TABLE public.service_bookings IS 'Sistem booking terpadu untuk semua jenis booking (merchant online, Allnimall app, offline store) dengan calendar-style availability';

COMMENT ON COLUMN public.service_bookings.booking_source IS 'Sumber booking: merchant_online_store, allnimall_app, offline_store';
COMMENT ON COLUMN public.service_bookings.booking_reference IS 'Nomor referensi booking unik (format: BK-YYYYMMDD-XXXX)';
COMMENT ON COLUMN public.service_bookings.pet_id IS 'ID pet (optional - bisa NULL jika tidak ada pet)';
COMMENT ON COLUMN public.service_bookings.service_type IS 'Tipe layanan: in_store atau on_site';
COMMENT ON COLUMN public.service_bookings.status IS 'Status booking: pending, confirmed, in_progress, completed, cancelled, no_show';
COMMENT ON COLUMN public.service_bookings.payment_status IS 'Status pembayaran: pending, paid, refunded';
COMMENT ON COLUMN public.service_bookings.allnimall_commission IS 'Komisi untuk Allnimall jika booking dari Allnimall app';

-- ========================================
-- PRODUCT COLUMN COMMENTS
-- ========================================

COMMENT ON COLUMN public.products.discount_type IS 'Discount type: 1=none, 2=percentage, 3=fixed';
COMMENT ON COLUMN public.products.discount_value IS 'Discount amount - percentage (if discount_type=2) or fixed amount (if discount_type=3)';
COMMENT ON COLUMN public.products.product_type IS 'Product type: item (physical product) or service';
COMMENT ON COLUMN public.products.duration_minutes IS 'Service duration in minutes (for service type products)';
COMMENT ON COLUMN public.products.service_category IS 'Service category: grooming, veterinary, transportation, etc.';

-- ========================================
-- FINAL SCHEMA COMPLETION MESSAGE
-- ========================================

-- Schema ini sekarang menyediakan:
-- 1. Complete POS functionality (sales, inventory, payment management)
-- 2. Pet-specific features (health tracking, scheduling, grooming)
-- 3. Unified customer architecture (one customer can be registered with multiple merchants)
-- 4. Supabase authentication for both staff and customers
-- 5. Role-based access control for multi-user stores
-- 6. Comprehensive business management tools
-- 7. Geographic support for Indonesia
-- 8. Performance optimized with proper indexes
-- 9. Helper functions for customer-merchant relationships
-- 10. Sample data for quick development start
-- 11. CALENDAR-STYLE BOOKING SYSTEM:
--     - Otomatis generate jam operasional (08:00-17:00)
--     - Matrix jam × staff dengan status availability real-time
--     - Support multiple staff per jam
--     - Validasi durasi service > 1 jam
--     - Seperti Google Calendar (tidak perlu pre-generate slot)
-- 12. Merchant partnership dengan Allnimall
-- 13. Real-time availability dari service_bookings
-- 14. Commission tracking untuk partnership

-- Ready for implementation with Allnimall Unified Customer Architecture + Unified Booking System! 