-- ========================================
-- SAMPLE DATA FOR ALLNIMALL PET SHOP
-- Run this after setting up the main schema
-- ========================================

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
INSERT INTO public.users (name, phone, email, staff_type, store_id) 
SELECT 
    'Demo Staff',
    '+6281234567890',
    'demo@allnimall.com',
    'cashier',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert another test user
INSERT INTO public.users (name, phone, email, staff_type, store_id) 
SELECT 
    'Admin Staff',
    '+6281314169140',
    'admin@allnimall.com',
    'admin',
    s.id
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert sample customers (pet owners)
INSERT INTO public.customers (name, phone, email, merchant_id) 
SELECT 
    'John Doe',
    '+6281111111111',
    'john@example.com',
    m.id
FROM public.merchants m 
WHERE m.name = 'Allnimall Pet Shop'
ON CONFLICT DO NOTHING;

INSERT INTO public.customers (name, phone, email, merchant_id) 
SELECT 
    'Jane Smith',
    '+6282222222222',
    'jane@example.com',
    m.id
FROM public.merchants m 
WHERE m.name = 'Allnimall Pet Shop'
ON CONFLICT DO NOTHING;

-- Insert sample products
INSERT INTO public.products (name, code, price, stock, min_stock, store_id, category_id) 
SELECT 
    'Royal Canin Dog Food',
    'RC001',
    150000,
    50,
    10,
    s.id,
    NULL
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (name, code, price, stock, min_stock, store_id, category_id) 
SELECT 
    'Whiskas Cat Food',
    'WC001',
    75000,
    30,
    5,
    s.id,
    NULL
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

INSERT INTO public.products (name, code, price, stock, min_stock, store_id, category_id) 
SELECT 
    'Pet Collar',
    'PC001',
    25000,
    20,
    3,
    s.id,
    NULL
FROM public.stores s 
WHERE s.name = 'Allnimall Pet Shop - Jakarta Selatan'
ON CONFLICT DO NOTHING;

-- Insert sample pets
INSERT INTO public.pets (name, owner_id, type, breed) 
SELECT 
    'Buddy',
    c.id,
    'Dog',
    'Golden Retriever'
FROM public.customers c 
WHERE c.name = 'John Doe'
ON CONFLICT DO NOTHING;

INSERT INTO public.pets (name, owner_id, type, breed) 
SELECT 
    'Whiskers',
    c.id,
    'Cat',
    'Persian'
FROM public.customers c 
WHERE c.name = 'Jane Smith'
ON CONFLICT DO NOTHING;

-- Success message
SELECT 'Sample data inserted successfully!' as message; 