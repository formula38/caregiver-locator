CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    password_salt VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('recipient', 'provider')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users (email);

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    care_services TEXT,
    location VARCHAR(100),
    rating NUMERIC(3, 2) NOT NULL DEFAULT 0.00,
    bio TEXT
);

CREATE INDEX idx_profiles_location_care ON profiles (location, care_services);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    recipient_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    provider_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (recipient_id, provider_id)
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    reviewer_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    reviewee_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    receiver_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_messages_receiver_sent ON messages (receiver_id, sent_at);
