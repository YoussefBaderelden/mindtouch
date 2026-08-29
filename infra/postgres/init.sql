-- MindTouch relational schema (v1)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE caregiver_links (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    caregiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    scopes TEXT[] DEFAULT '{}',
    status TEXT DEFAULT 'pending',
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    platform TEXT,
    name TEXT,
    public_key TEXT,
    last_seen TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ha_connections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    base_url_enc TEXT NOT NULL,
    token_enc TEXT NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    schedule_cron TEXT NOT NULL,
    last_confirmed TIMESTAMPTZ,
    escalate_after_min INT DEFAULT 30,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE sos_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    status TEXT DEFAULT 'triggered',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE sos_deliveries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sos_id UUID REFERENCES sos_events(id) ON DELETE CASCADE,
    caregiver_id UUID REFERENCES users(id),
    channel TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    ack_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_devices_user ON devices(user_id);
CREATE INDEX idx_sos_user ON sos_events(user_id);
