-- Script untuk menambahkan produk test
-- Pastikan store_id sesuai dengan store yang ada

-- Insert test products
INSERT INTO public.products (
    id,
    created_at,
    created_by,
    name,
    store_id,
    category_id,
    purchase_price,
    price,
    stock,
    min_stock,
    unit,
    weight_grams,
    description,
    is_active,
    product_type,
    duration_minutes,
    service_category
) VALUES 
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Makanan Kucing Premium',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    15000,
    25000,
    50,
    10,
    'pcs',
    500,
    'Makanan kucing premium dengan nutrisi lengkap',
    true,
    'item',
    NULL,
    NULL
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Makanan Anjing Dewasa',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    20000,
    35000,
    30,
    5,
    'pcs',
    1000,
    'Makanan anjing dewasa dengan protein tinggi',
    true,
    'item',
    NULL,
    NULL
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Shampoo Kucing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    25000,
    45000,
    20,
    3,
    'pcs',
    250,
    'Shampoo khusus kucing dengan pH seimbang',
    true,
    'item',
    NULL,
    NULL
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Mainan Bola Kucing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    5000,
    15000,
    100,
    20,
    'pcs',
    50,
    'Mainan bola untuk kucing dengan suara',
    true,
    'item',
    NULL,
    NULL
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Kandang Anjing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    150000,
    250000,
    5,
    1,
    'pcs',
    5000,
    'Kandang anjing ukuran medium',
    true,
    'item',
    NULL,
    NULL
),

-- Service products
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Grooming Anjing Kecil',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    0,
    150000,
    0,
    0,
    'session',
    0,
    'Jasa grooming untuk anjing kecil',
    true,
    'service',
    120,
    'grooming'
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Grooming Anjing Besar',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    0,
    200000,
    0,
    0,
    'session',
    0,
    'Jasa grooming untuk anjing besar',
    true,
    'service',
    180,
    'grooming'
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Grooming Kucing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    0,
    120000,
    0,
    0,
    'session',
    0,
    'Jasa grooming untuk kucing',
    true,
    'service',
    90,
    'grooming'
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Cek Kesehatan Hewan',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    0,
    100000,
    0,
    0,
    'session',
    0,
    'Jasa pemeriksaan kesehatan hewan',
    true,
    'service',
    60,
    'health'
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Vaksinasi Hewan',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    0,
    80000,
    0,
    0,
    'session',
    0,
    'Jasa vaksinasi hewan',
    true,
    'service',
    45,
    'health'
);

-- Query untuk melihat produk yang sudah ada
SELECT 
    id,
    name,
    store_id,
    price,
    stock,
    is_active,
    product_type,
    duration_minutes,
    service_category,
    created_at
FROM public.products 
WHERE store_id = 'YOUR_STORE_ID_HERE' -- Ganti dengan store_id yang sesuai
ORDER BY created_at DESC;

-- Quick test: Check if any service products exist
SELECT 
    COUNT(*) as total_products,
    COUNT(CASE WHEN product_type = 'service' THEN 1 END) as service_products,
    COUNT(CASE WHEN product_type = 'item' THEN 1 END) as item_products
FROM public.products 
WHERE store_id = 'YOUR_STORE_ID_HERE'; -- Ganti dengan store_id yang sesuai 