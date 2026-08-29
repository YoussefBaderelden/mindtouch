CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE session_summaries (
    time TIMESTAMPTZ NOT NULL,
    user_id UUID NOT NULL,
    duration_sec INT,
    intent_count INT,
    avg_latency_ms INT,
    signal_quality_avg REAL
);

SELECT create_hypertable('session_summaries', 'time');

CREATE TABLE usage_events (
    time TIMESTAMPTZ NOT NULL,
    user_id UUID NOT NULL,
    event_type TEXT NOT NULL,
    payload JSONB
);

SELECT create_hypertable('usage_events', 'time');
