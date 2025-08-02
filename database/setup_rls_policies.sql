-- ========================================
-- SETUP RLS POLICIES - TEMPORARY ALLOW ALL
-- ========================================

-- STEP 1: ENABLE RLS ON ALL TABLES
-- ========================================

-- Business tables
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stores ENABLE ROW LEVEL SECURITY;

-- User management tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_assignments ENABLE ROW LEVEL SECURITY;

-- Pet-specific tables
ALTER TABLE public.pets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_healths ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedule_recurring_patterns ENABLE ROW LEVEL SECURITY;

-- Product & Inventory tables
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_transactions ENABLE ROW LEVEL SECURITY;

-- Sales & Payment tables
ALTER TABLE public.store_carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.store_payment_methods ENABLE ROW LEVEL SECURITY;

-- Master tables
ALTER TABLE public.characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schedule_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.provinces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cities ENABLE ROW LEVEL SECURITY;

-- STEP 2: CREATE ALLOW ALL POLICIES
-- ========================================

-- Business tables policies
CREATE POLICY "Allow all on merchants" ON public.merchants FOR ALL USING (true);
CREATE POLICY "Allow all on stores" ON public.stores FOR ALL USING (true);

-- User management policies
CREATE POLICY "Allow all on users" ON public.users FOR ALL USING (true);
CREATE POLICY "Allow all on customers" ON public.customers FOR ALL USING (true);
CREATE POLICY "Allow all on roles" ON public.roles FOR ALL USING (true);
CREATE POLICY "Allow all on role_assignments" ON public.role_assignments FOR ALL USING (true);

-- Pet-specific policies
CREATE POLICY "Allow all on pets" ON public.pets FOR ALL USING (true);
CREATE POLICY "Allow all on pet_characters" ON public.pet_characters FOR ALL USING (true);
CREATE POLICY "Allow all on pet_healths" ON public.pet_healths FOR ALL USING (true);
CREATE POLICY "Allow all on pet_schedules" ON public.pet_schedules FOR ALL USING (true);
CREATE POLICY "Allow all on schedule_recurring_patterns" ON public.schedule_recurring_patterns FOR ALL USING (true);

-- Product & Inventory policies
CREATE POLICY "Allow all on products" ON public.products FOR ALL USING (true);
CREATE POLICY "Allow all on inventory_transactions" ON public.inventory_transactions FOR ALL USING (true);

-- Sales & Payment policies
CREATE POLICY "Allow all on store_carts" ON public.store_carts FOR ALL USING (true);
CREATE POLICY "Allow all on sales" ON public.sales FOR ALL USING (true);
CREATE POLICY "Allow all on sales_items" ON public.sales_items FOR ALL USING (true);
CREATE POLICY "Allow all on store_payment_methods" ON public.store_payment_methods FOR ALL USING (true);

-- Master tables policies
CREATE POLICY "Allow all on characters" ON public.characters FOR ALL USING (true);
CREATE POLICY "Allow all on pet_categories" ON public.pet_categories FOR ALL USING (true);
CREATE POLICY "Allow all on schedule_types" ON public.schedule_types FOR ALL USING (true);
CREATE POLICY "Allow all on payment_types" ON public.payment_types FOR ALL USING (true);
CREATE POLICY "Allow all on payment_methods" ON public.payment_methods FOR ALL USING (true);
CREATE POLICY "Allow all on products_categories" ON public.products_categories FOR ALL USING (true);
CREATE POLICY "Allow all on countries" ON public.countries FOR ALL USING (true);
CREATE POLICY "Allow all on provinces" ON public.provinces FOR ALL USING (true);
CREATE POLICY "Allow all on cities" ON public.cities FOR ALL USING (true);

-- STEP 3: VERIFICATION
-- ========================================

-- Check RLS status
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN (
    'merchants', 'stores', 'users', 'customers', 'roles', 'role_assignments',
    'pets', 'pet_characters', 'pet_healths', 'pet_schedules', 'schedule_recurring_patterns',
    'products', 'inventory_transactions', 'store_carts', 'sales', 'sales_items', 'store_payment_methods',
    'characters', 'pet_categories', 'schedule_types', 'payment_types', 'payment_methods',
    'products_categories', 'countries', 'provinces', 'cities'
  )
ORDER BY tablename;

-- Check policies
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- STEP 4: TEST ACCESS
-- ========================================

-- Test basic queries
SELECT 'RLS Test' as test_type, count(*) as count FROM public.merchants
UNION ALL
SELECT 'RLS Test', count(*) FROM public.users
UNION ALL
SELECT 'RLS Test', count(*) FROM public.customers
UNION ALL
SELECT 'RLS Test', count(*) FROM public.pets
UNION ALL
SELECT 'RLS Test', count(*) FROM public.products;

COMMIT; 