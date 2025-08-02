-- Script untuk menambahkan data test
-- Pastikan untuk mengganti YOUR_STORE_ID dengan store_id yang sesuai

-- 1. Cek store yang ada
SELECT id, name, merchant_id FROM stores ORDER BY created_at DESC LIMIT 5;

-- 2. Insert test products (ganti YOUR_STORE_ID dengan store_id yang sesuai)
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
    is_active
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
    true
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
    true
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Pasir Kucing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    5000,
    15000,
    100,
    20,
    'kg',
    5000,
    'Pasir kucing berkualitas tinggi',
    true
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Mainan Kucing',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    3000,
    8000,
    25,
    5,
    'pcs',
    100,
    'Mainan kucing yang aman dan menarik',
    true
),
(
    gen_random_uuid(),
    now() AT TIME ZONE 'utc',
    '00000000-0000-0000-0000-000000000000'::uuid,
    'Vitamin Hewan',
    'YOUR_STORE_ID_HERE', -- Ganti dengan store_id yang sesuai
    NULL,
    8000,
    12000,
    40,
    10,
    'botol',
    200,
    'Vitamin untuk kesehatan hewan peliharaan',
    true
);

-- 3. Verifikasi data yang ditambahkan
SELECT 
    id,
    name,
    store_id,
    price,
    stock,
    is_active,
    created_at
FROM products 
WHERE store_id = 'YOUR_STORE_ID_HERE' -- Ganti dengan store_id yang sesuai
ORDER BY created_at DESC; 