-- Debug queries untuk mengecek data di database

-- 1. Cek apakah ada stores
SELECT 
    id,
    name,
    merchant_id,
    is_active,
    created_at
FROM stores 
ORDER BY created_at DESC 
LIMIT 5;

-- 2. Cek apakah ada products
SELECT 
    id,
    name,
    store_id,
    price,
    stock,
    is_active,
    created_at
FROM products 
ORDER BY created_at DESC 
LIMIT 10;

-- 3. Cek role assignments
SELECT 
    ra.id,
    ra.user_id,
    ra.store_id,
    ra.merchant_id,
    ra.role_id,
    ra.is_active,
    u.name as user_name,
    u.email as user_email,
    s.name as store_name,
    m.name as merchant_name,
    r.name as role_name
FROM role_assignments ra
LEFT JOIN users u ON ra.user_id = u.id
LEFT JOIN stores s ON ra.store_id = s.id
LEFT JOIN merchants m ON ra.merchant_id = m.id
LEFT JOIN roles r ON ra.role_id = r.id
WHERE ra.is_active = true
ORDER BY ra.created_at DESC
LIMIT 10;

-- 4. Cek users
SELECT 
    id,
    name,
    email,
    username,
    auth_id,
    is_active,
    created_at
FROM users 
ORDER BY created_at DESC 
LIMIT 5;

-- 5. Cek products untuk store tertentu (ganti store_id)
SELECT 
    p.id,
    p.name,
    p.store_id,
    p.price,
    p.stock,
    p.is_active,
    s.name as store_name,
    p.created_at
FROM products p
LEFT JOIN stores s ON p.store_id = s.id
WHERE p.store_id = 'YOUR_STORE_ID_HERE' -- Ganti dengan store_id yang sesuai
ORDER BY p.created_at DESC;

-- 6. Cek apakah ada categories
SELECT 
    id,
    name,
    store_id,
    is_active,
    created_at
FROM products_categories 
ORDER BY created_at DESC 
LIMIT 5; 