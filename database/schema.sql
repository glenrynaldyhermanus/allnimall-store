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
    discount_value NUMERIC NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_prescription_required BOOLEAN DEFAULT false,
    shelf_life_days INTEGER,
    storage_instructions TEXT,
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

-- store_carts
CREATE TABLE public.store_carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() AT TIME ZONE 'utc'),
    created_by UUID NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
    updated_at TIMESTAMP WITH TIME ZONE,
    updated_by UUID,
    deleted_at TIMESTAMP WITH TIME ZONE,
    store_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity SMALLINT NOT NULL DEFAULT 1,
    session_id TEXT, -- for anonymous sessions
    customer_id UUID, -- for logged in customers
    FOREIGN KEY (store_id) REFERENCES public.stores(id),
    FOREIGN KEY (product_id) REFERENCES public.products(id),
    FOREIGN KEY (customer_id) REFERENCES public.customers(id)
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
COMMENT ON TABLE public.products IS 'Pet products with specific fields for pet shop needs like expiry dates, pet size recommendations';
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

-- Ready for implementation with Allnimall Unified Customer Architecture! 