Business Requirements Document (BRD)

Street Dogs Risk Map and Proximity Alerts (Android-first)

Document version: v0.1 (MVP)
Date: 25 Dec 2025
Owner: Product/Engineering (You)
Target: GitHub README + initial backlog seed

⸻

1) Background and business problem

In many Indian cities, street dogs form clusters at predictable points (food spots, intersections, market edges, quiet lanes). Two-wheeler riders, delivery riders, walkers, and late-night commuters face sudden chasing/barking incidents, especially when visibility is low.

Problem: People do not have a simple, route-relevant way to know “higher risk zones” ahead of time, and they do not get timely, local alerts while moving.

⸻

2) Product vision

A lightweight, free, crowd-sourced street-dog risk heatmap with an optional Safety Mode that warns users when they are approaching a known dog hotspot.

⸻

3) Goals and success criteria

Goals (MVP)
	1.	Show a map with dog hotspots and risk intensity (heatmap).
	2.	Allow public users to report a dog hotspot quickly.
	3.	Provide proximity alerts (visual + push notification) when a user is near a hotspot while Safety Mode is ON.
	4.	Improve trustworthiness of reports via basic validation and moderation.

Success metrics (examples)
	•	Weekly active users (WAU)
	•	Safety Mode sessions/day
	•	Alert events/day and “useful alert” feedback rate
	•	% of reports that become “verified”
	•	Time-to-review for flagged reports

⸻

4) In-scope vs out-of-scope

In scope (MVP)
	•	Android app (APK distribution + Play Store track later)
	•	Map + heatmap visualization
	•	Report hotspot (with optional private evidence)
	•	Safety Mode proximity alerts
	•	Basic validation + moderation workflows
	•	Minimal analytics (privacy-preserving)

Out of scope (initial MVP)
	•	Background tracking always-on (without explicit Safety Mode)
	•	Route planning / navigation replacement
	•	Paid monetization, enterprise API contracts
	•	Publicly visible photos of dogs (explicitly excluded)

⸻

5) Target users and primary use cases

Personas
	•	Delivery rider (two-wheeler): wants live warning while approaching risk zones.
	•	Night commuter: wants safer awareness on regular routes.
	•	Walker / jogger: wants situational awareness in lanes/streets.
	•	Animal rescuer/volunteer: uses map to plan safer pickup/rescue routes.

Core use cases
	1.	Explore Map: open app → see heatmap in current city/area.
	2.	Safety Mode: turn ON Safety Mode → get alert near hotspots.
	3.	Report Hotspot: add a dog hotspot at current/selected location.
	4.	Validate: community and/or moderator marks report as trusted.

⸻

6) Key product decisions (important constraints)

Proximity radius and GPS reality
	•	Hotspot “dog spot radius” (for display/intensity): 20–30 meters (domain preference).
	•	Alert trigger radius (practical): ~100 meters to reduce missed detections due to real-world location accuracy and platform recommendations for geofencing. Android guidance explicitly mentions using a minimum radius of ~100m for best results.  ￼

Geofence scale limitation
	•	Android geofencing has a limit of ~100 active geofences per app per user; therefore we must load only the nearest hotspots around the user during Safety Mode.  ￼

Notifications permission
	•	On Android 13+, notifications require runtime permission (POST_NOTIFICATIONS).  ￼

Background location policy risk (Play Store)
	•	If you request background location, Google Play requires that it is core to the app and that user expectations and disclosures are met. MVP should prefer Safety Mode (foreground/on-demand) to reduce policy friction.  ￼

⸻

7) Functional requirements (MVP)

7.1 Map & discovery

FR-1: App shows a map centered on user’s current area (or last used area).
FR-2: Heatmap layer indicates hotspot intensity (e.g., Low/Medium/High).
FR-3: Tap hotspot → show details: risk level, last updated, verification status, community notes.

7.2 Reporting (data upload)

FR-4: User can “Add Hotspot” by:
	•	current location (one-tap), or
	•	pin drop on map.
FR-5: User provides:
	•	optional short note (e.g., “pack of 5 near tea stall”),
	•	time-of-day tag (optional),
	•	optional private evidence (photo) not publicly shown.
FR-6: App enforces basic anti-spam controls:
	•	rate limit reports per user/device/day,
	•	duplicate detection (same area + time window).

7.3 Safety Mode alerts (when to throw alerts)

FR-7: User can enable/disable Safety Mode explicitly.
FR-8: While Safety Mode is ON, trigger an alert when user is within ~100m of a verified/probation hotspot. (Geofencing guidance supports ~100m as a practical minimum for consistent detection.)  ￼
FR-9: Alert includes:
	•	“Approaching dog hotspot in ~100m”
	•	risk level
	•	quick actions: “Acknowledge”, “Report false”, “Report still active”
FR-10: Alert throttling:
	•	avoid alert spam by using dwell/transition logic and cooldown windows (geofencing guidance suggests dwell triggers to reduce spam).  ￼

7.4 Validation (how to validate data)

FR-11: Reports have statuses: New → Probation → Verified → Archived.
FR-12: Validation signals (MVP):
	•	Community verification: multiple independent confirmations in same area/time window
	•	Moderator review: admin approves/denies
	•	Metadata checks (optional): if user attaches a photo, extract geotag/time metadata where available to support positional validation (photo remains private). Research and mapping practice commonly use geotags from contributed images plus moderation for positional validation.  ￼
FR-13: Flagging:
	•	Users can flag hotspots as incorrect/unsafe/malicious.
	•	Flagged items go to moderation queue.

7.5 Admin/moderation (minimal)

FR-14: Admin console (can be basic web page) to:
	•	review new reports
	•	approve/deny
	•	merge duplicates
	•	view flags and audit history

⸻

8) Non-functional requirements

Performance & reliability
	•	NFR-1: Map loads within 2–3 seconds on mid-range Android in typical network.
	•	NFR-2: Safety Mode should minimize battery drain; only keep nearest hotspots loaded (due to geofence limits).  ￼

Privacy & compliance
	•	NFR-3: Do not store continuous location history by default.
	•	NFR-4: Prominent disclosure for location usage; request only necessary permissions.
	•	NFR-5: If background location is ever introduced, it must align with Play background location requirements and user expectations.  ￼

Security
	•	NFR-6: Auth is optional for MVP, but if present: protect endpoints, rate limit, basic abuse detection.
	•	NFR-7: Evidence photos stored privately with access controls.

⸻

9) Data model (logical)

Entities
	•	Hotspot
	•	id, lat, lng
	•	risk_level (derived)
	•	display_radius_m (20–30)
	•	status (New/Probation/Verified/Archived)
	•	created_at, updated_at
	•	Report
	•	id, hotspot_id (or creates new)
	•	reporter_id (or device hash)
	•	note, tags, timestamp
	•	evidence_asset_id (optional, private)
	•	VerificationEvent
	•	id, hotspot_id
	•	type (confirm/deny/flag/admin_approve/admin_deny)
	•	actor_id, created_at

⸻

10) Assumptions and dependencies
	•	Android-first is acceptable for MVP distribution (APK on website + Play later).
	•	Map provider to be chosen (Google Maps / Mapbox / OSM). Licensing/usage must be respected.
	•	Push notifications require runtime permission on Android 13+.  ￼
	•	Safety Mode relies on device location accuracy; minimum practical alert radius is around 100m when using geofences.  ￼

⸻

11) Risks and mitigations
	1.	False reports / misuse
	•	Mitigation: rate limits, duplicate detection, probation status, moderation queue.
	2.	Alert spam
	•	Mitigation: dwell/cooldown logic and risk thresholds (geofencing best practices).  ￼
	3.	Battery drain
	•	Mitigation: Safety Mode is explicit; keep only nearest hotspots active due to platform limits.  ￼
	4.	Play Store compliance
	•	Mitigation: avoid background location initially; keep a clear disclosure; request only needed permissions.  ￼

⸻

12) MVP deliverables (for GitHub README)
	•	Problem statement + vision
	•	MVP scope bullets (Map, Report, Safety Mode Alerts, Validation)
	•	Permission rationale (Location + Notifications)
	•	Data privacy stance (no public photos; minimal location storage)
	•	High-level architecture (Mobile → API → DB → moderation)
	•	Roadmap (v0.1 MVP → v0.2 verification improvements → v0.3 partnerships/APIs)
