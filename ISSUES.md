# StreetDogs — Issue Backlog (MVP)

This file contains the ready-to-create issues grouped by epics for the StreetDogs Heatmap + Safety Mode MVP.

---

## EPIC A — Product Definition + Repo Readiness (P0)

### A1 — Create MVP README spec for Copilot and contributors (P0)
**Goal:** Make the repo self-explanatory so Copilot/engineers don’t guess requirements.
**Acceptance criteria:** README includes problem, MVP scope, non-goals, core flows, hotspot definition (20–30m spot semantics, 100m alert trigger), data model, validation rules, Safety Mode rules, geofence constraints, How to run locally placeholders + env variables.

### A2 — Define GitHub issue templates (Bug / Feature / Epic) (P0)
**Acceptance criteria:** `.github/ISSUE_TEMPLATE/feature.yml`, `bug.yml`, `epic.yml` present. Feature template includes: Problem, Proposed solution, API changes, UI changes, Acceptance criteria, Telemetry, Risks.

---

## EPIC B — Backend Data + APIs (MVP feed) (P0)

### B1 — Define DB schema for Hotspots, Reports, ValidationEvents (P0)
Tables/collections: hotspots, reports, validation_events. Indexes for geo queries.

### B2 — API: Create hotspot report (POST /reports) (P0)
Accepts lat/lng, optional note, count_bucket, time_bucket, optional evidence reference. Server does validation, rate limiting, returns {hotspot_id, created_or_merged}.

### B3 — API: Fetch hotspots for map (GET /hotspots) with bounding box (P0)
Query by viewport, return minimal fields for heatmap (lat/lng + weight/risk/status). Filters: status, updated_since.

### B4 — API: Fetch nearby VERIFIED hotspots for Safety Mode (GET /hotspots/nearby) (P0)
Inputs: user lat/lng + radius, limit (e.g., 80). Returns VERIFIED hotspots prioritized by distance/risk. Keep results sized to keep geofences ≤100.

### B5 — Abuse controls: rate limit + duplicate detection (P0)
Rate limiting configurable. Duplicate logic: if report within 30m of existing hotspot → merge as confirmation. Unit tests required.

---

## EPIC C — Validation Engine (truthfulness) (P0)

### C1 — Implement hotspot status lifecycle (NEW → PROBATION → VERIFIED → ARCHIVED) (P0)
Deterministic, configurable transitions based on independent confirmations and flags/denies/staleness.

### C2 — Implement risk_score computation (P0)
Derived from confirmations, recency decay, denies/flags penalty — supports heatmap weighting.

### C3 — API: Flag hotspot / deny / confirm (POST /hotspots/:id/feedback) (P0)
Stores ValidationEvent and triggers status/risk recalculation.

---

## EPIC D — Mobile App: Map + Heatmap (P0)

### D1 — Map screen scaffold + location permission handling (P0)
Map renders, center on current location if permitted, graceful fallback if denied.

### D2 — Heatmap overlay rendering using Maps Utility Library (P0)
Heatmap uses `HeatmapTileProvider` + `TileOverlay`, consumes backend hotspots with weights.

### D3 — Hotspot details bottom-sheet (P0)
Shows risk level, status, last updated, and actions: confirm/deny/flag.

---

## EPIC E — Mobile App: Report Hotspot (data upload) (P0)

### E1 — “Report Hotspot” UX flow (current location + pin drop) (P0)
Report via current GPS or pin drop; form fields: note, count_bucket, time_bucket; submit to POST /reports.

### E2 — Private evidence upload (optional) (P1)
Photo uploaded to private storage, linked to report, accessible to admin only.

---

## EPIC F — Safety Mode Alerts (P0)

### F1 — Safety Mode toggle + session behavior (P0)
Explicit ON/OFF, when ON monitor proximity to VERIFIED hotspots, when OFF stop monitoring and clear geofences.

### F2 — Geofence registration strategy (dynamic nearby hotspots) (P0)
Fetch nearby VERIFIED hotspots and register geofences, enforce max active geofences ≤100, geofence radius 100–150m, refresh geofences on significant move (500–1000m).

### F3 — Alert triggering + anti-spam cooldown (P0)
On geofence ENTER/DWELL show in-app alert + notification; cooldown (e.g., 10 minutes) per hotspot; emit logging event.

### F4 — Android notification permission + channel setup (P0)
Request `POST_NOTIFICATIONS` on Android 13+, configure channels, fallback to in-app banner if denied.

---

## EPIC G — Admin Moderation (P0 minimal)

### G1 — Admin: list NEW/FLAGGED hotspots + approve/reject/merge (P0)
Admin can view by status, approve (force VERIFIED), reject (ARCHIVED), merge duplicates, view report history + evidence, audit trail stored.

---

## EPIC H — QA, Telemetry, Release (P0)

### H1 — Instrument basic telemetry events (privacy-safe) (P0)
Events: `app_open`, `safety_mode_on/off`, `report_created`, `hotspot_confirm/deny/flag`, `alert_triggered`. No continuous location storage.

### H2 — Automated tests (P0)
Unit tests for report merge, status transitions, risk_score changes, and Safety Mode smoke checklist.

### H3 — CI pipeline: build + lint + test (P0)
CI runs on PR: lint, unit tests, build artifact (debug). Document branch protection.

---

## Optional P1 backlog
- Offline caching for map tiles / last hotspots
- “Report still active” quick button after alert
- City/area search + saved areas
- Fraud heuristics (device reputation, burst detection)

---

Primary stack: ReactNative + Supabase
