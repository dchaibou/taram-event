
-- =========================
-- DOMAIN : USER
-- =========================
-- TABLE des rôles
CREATE TABLE IF NOT EXISTS public.role (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- TABLE Utilisateurs
CREATE TABLE IF NOT EXISTS public.user (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    phone VARCHAR(20),
    phone_verified BOOLEAN DEFAULT FALSE,
    password_hash TEXT NOT NULL,
    role_id INT NOT NULL,
    suspended BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES public.role(id) ON DELETE RESTRICT
);

-- Vue pour utilisateurs
CREATE OR REPLACE VIEW public.v_user AS
SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email,
    u.email_verified,
    u.phone,
    u.phone_verified,
    u.role_id,
    r.role_name,
    u.suspended,
    u.password_hash,
    u.created_at
FROM public.user u
JOIN public.role r ON u.role_id = r.id;

-- TABLE des codes de vérification
CREATE TABLE IF NOT EXISTS public.verification_code (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    code VARCHAR(10) NOT NULL,
    type VARCHAR(20) NOT NULL, -- exemple: "email_verification", "password_reset"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL '10 minutes'),
    FOREIGN KEY (user_id) REFERENCES public.user(id) ON DELETE CASCADE
);

-- Index pour retrouver rapidement un code encore valide
CREATE INDEX IF NOT EXISTS idx_verification_codes_valid
    ON public.verification_code (user_id, code);

-- Vue pour codes de vérification
CREATE OR REPLACE VIEW public.v_verification_code AS
SELECT 
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone,
    v.code,
    v.type,
    v.created_at,
    v.expires_at
FROM public.verification_code v
JOIN public.user u ON u.id = v.user_id;

-- =========================
-- DOMAIN : EVENT
-- =========================
-- TABLE des types d'événements
CREATE TABLE IF NOT EXISTS public.event_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- TABLE Événements
CREATE TABLE public.event (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    event_date TIMESTAMP NOT NULL,
    image_url VARCHAR(255),
    organizer_id INT NOT NULL,
    event_type_id INT NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Clés étrangères pour lier les événements aux utilisateurs et aux types
    FOREIGN KEY (organizer_id) REFERENCES public.user(id) ON DELETE CASCADE,
    FOREIGN KEY (event_type_id) REFERENCES public.event_type(id) ON DELETE RESTRICT
);

-- Table pour les différents types de billets pour un événement donné
CREATE TABLE public.ticket_type (
    id SERIAL PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    total_count INT NOT NULL CHECK (total_count > 0),
    available_count INT NOT NULL CHECK (available_count >= 0),

    -- Clé étrangère pour lier les types de billets aux événements
    FOREIGN KEY (event_id) REFERENCES public.event(id) ON DELETE CASCADE,
    
    -- Empêche les doublons de noms de billets pour le même événement
    UNIQUE (event_id, name)
);

-- Index pour optimiser les recherches fréquentes
CREATE INDEX idx_event_date ON public.event(event_date);
CREATE INDEX idx_event_organizer ON public.event(organizer_id);

--
--
--
-- TABLE Tickets
CREATE TABLE IF NOT EXISTS event.tickets (
    ticket_id SERIAL PRIMARY KEY,
    event_id INT NOT NULL,
    buyer_id INT NOT NULL,
    qr_code TEXT NOT NULL UNIQUE,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('valid', 'used', 'cancelled')) DEFAULT 'valid',
    FOREIGN KEY (event_id) REFERENCES event.events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (buyer_id) REFERENCES auth.user(id) ON DELETE CASCADE
);

-- =========================
-- DOMAIN : PAYMENT
-- =========================
CREATE SCHEMA IF NOT EXISTS payment;

-- TABLE des types de paiements
CREATE TABLE IF NOT EXISTS payment.payment_types (
    payment_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) UNIQUE NOT NULL
);

-- TABLE Paiements
CREATE TABLE IF NOT EXISTS payment.payments (
    payment_id SERIAL PRIMARY KEY,
    ticket_id INT NOT NULL UNIQUE,
    payment_type_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'failed')) DEFAULT 'pending',
    transaction_reference VARCHAR(100) UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES event.tickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_type_id) REFERENCES payment.payment_types(payment_type_id) ON DELETE RESTRICT
);

-- =========================
-- DOMAIN : REVIEW
-- =========================
CREATE SCHEMA IF NOT EXISTS review;

-- TABLE Avis
CREATE TABLE IF NOT EXISTS review.reviews (
    review_id SERIAL PRIMARY KEY,
    event_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES event.events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES auth.user(id) ON DELETE CASCADE,
    UNIQUE (event_id, user_id)
);

-- =========================
-- DOMAIN : AUTH
-- =========================

-- Insertion des rôles
INSERT INTO auth.role (role_name) 
VALUES 
    ('organizer'),
    ('participant'),
    ('admin');

-- Insertion des utilisateurs
-- L'organisateur avec l'ID 1 est Djibril CHAIBOU, l'admin
-- Les IDs sont gérés automatiquement par SERIAL
INSERT INTO auth.user (first_name, last_name, email, email_verified, phone, phone_verified, password_hash, role_id, suspended)
VALUES
    ('Djibril', 'CHAIBOU', 'djibrilchaibou.dc@gmail.com', TRUE, '+22798563482', TRUE, 'hash_djibril', 3, FALSE),
    ('Jane', 'DOE', 'jane.doe@organizer.com', TRUE, '+22799123456', TRUE, 'hash_jane', 1, FALSE),
    ('John', 'SMITH', 'john.smith@participant.com', TRUE, '+227987654321', TRUE, 'hash_john', 2, FALSE),
    ('Fatou', 'MAIGA', 'fatou.maiga@participant.com', TRUE, '+22790001122', TRUE, 'hash_fatou', 2, FALSE);

-- =========================
-- DOMAIN : EVENT
-- =========================

-- Insertion des types d'événements
INSERT INTO event.event_types (type_name) 
VALUES
    ('Concert'),
    ('Conférence'),
    ('Salon'),
    ('Atelier');

-- Insertion des événements
-- organizer_id: 1 -> Djibril, 2 -> Jane Doe
-- event_type_id: 1 -> Concert, 2 -> Conférence, etc.
INSERT INTO event.events (organizer_id, event_type_id, title, description, location, event_date, ticket_price, total_tickets, available_tickets, image_url)
VALUES
    (1, 1, 'Concert Stars Niger', 'Un grand concert avec des artistes locaux du Niger.', 'Niamey - Stade Général Seyni Kountché', '2025-12-20 20:00:00', 5000.00, 2000, 1998, 'concert_stars.jpg'),
    (2, 2, 'Conférence Tech Afrique', 'Événement majeur sur les nouvelles technologies en Afrique.', 'Niamey - Palais des Congrès', '2025-09-15 09:00:00', 10000.00, 500, 499, 'tech_africa.jpg'),
    (2, 3, 'Salon de l’Innovation', 'Exposition des startups et des innovations africaines.', 'Maradi - Centre Expo', '2025-10-05 10:00:00', 2000.00, 800, 799, 'salon_innovation.jpg'),
    (1, 4, 'Atelier de Programmation', 'Apprenez les bases du développement mobile avec Flutter.', 'Niamey - Espace Numérique', '2025-11-01 14:00:00', 15000.00, 50, 50, 'atelier_flutter.jpg');

-- Insertion des tickets
-- event_id: 1 -> Concert Stars Niger, 2 -> Conférence Tech Afrique, etc.
-- buyer_id: 3 -> John SMITH, 4 -> Fatou MAIGA
INSERT INTO event.tickets (event_id, buyer_id, qr_code, status)
VALUES
    (1, 3, 'TICKET_QR_A123BCDE', 'valid'),
    (1, 4, 'TICKET_QR_F456GHIJ', 'valid'),
    (2, 3, 'TICKET_QR_K789LMNO', 'used'),
    (3, 4, 'TICKET_QR_P012QRST', 'valid');

-- =========================
-- DOMAIN : PAYMENT
-- =========================

-- Insertion des types de paiements
INSERT INTO payment.payment_types (type_name) 
VALUES
    ('Mobile Money'),
    ('PayPal'),
    ('Carte Bancaire');

-- Insertion des paiements
-- ticket_id: 1, 2, 3, 4
-- payment_type_id: 1 -> Mobile Money, 2 -> PayPal, 3 -> Carte Bancaire
INSERT INTO payment.payments (ticket_id, payment_type_id, amount, status, transaction_reference)
VALUES
    (1, 1, 5000.00, 'completed', 'TXN-ABC-12345'),
    (2, 2, 5000.00, 'completed', 'TXN-DEF-67890'),
    (3, 3, 10000.00, 'completed', 'TXN-GHI-10112'),
    (4, 1, 2000.00, 'pending', 'TXN-JKL-31415');

-- =========================
-- DOMAIN : REVIEW
-- =========================

-- Insertion des avis
-- event_id: 1, 2, 3
-- user_id: 3 -> John SMITH, 4 -> Fatou MAIGA
INSERT INTO review.reviews (event_id, user_id, rating, comment)
VALUES
    (1, 3, 5, 'Super concert, ambiance incroyable ! Le son était top.'),
    (2, 3, 4, 'Conférence très intéressante, mais la salle était un peu petite.'),
    (3, 4, 5, 'Très belle organisation et beaucoup de bonnes innovations présentées. Je recommande !');