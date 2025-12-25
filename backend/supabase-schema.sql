// Supabase Database Schema for StreetDogs MVP
// Run this SQL in Supabase SQL editor

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgvector";

-- Hotspots table
CREATE TABLE hotspots (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  status TEXT NOT NULL DEFAULT 'NEW' CHECK (status IN ('NEW', 'PROBATION', 'VERIFIED', 'ARCHIVED')),
  risk_score DOUBLE PRECISION DEFAULT 0,
  display_radius_m INTEGER DEFAULT 30,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reports table
CREATE TABLE reports (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  hotspot_id UUID REFERENCES hotspots(id),
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  note TEXT,
  count_bucket TEXT CHECK (count_bucket IN ('1-2', '3-5', '6+')),
  time_bucket TEXT CHECK (time_bucket IN ('morning', 'evening', 'night')),
  evidence_asset_id TEXT,
  reporter_fingerprint TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Validation Events table
CREATE TABLE validation_events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  hotspot_id UUID NOT NULL REFERENCES hotspots(id),
  type TEXT NOT NULL CHECK (type IN ('confirm', 'deny', 'flag', 'admin_approve', 'admin_reject')),
  actor_id TEXT,
  reporter_fingerprint TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_hotspots_status ON hotspots(status);
CREATE INDEX idx_reports_hotspot_id ON reports(hotspot_id);
CREATE INDEX idx_validation_events_hotspot_id ON validation_events(hotspot_id);