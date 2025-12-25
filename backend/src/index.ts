import express from 'express';
import cors from 'cors';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Placeholder: POST /reports - Create hotspot report
app.post('/reports', async (req, res) => {
  try {
    const { lat, lng, note, count_bucket, time_bucket, reporter_fingerprint } = req.body;
    
    // TODO: Implement rate limiting
    // TODO: Implement duplicate detection (30m radius)
    
    res.status(201).json({ message: 'Report created' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create report' });
  }
});

// Placeholder: GET /hotspots - Fetch hotspots for map
app.get('/hotspots', async (req, res) => {
  try {
    const { minLat, maxLat, minLng, maxLng } = req.query;
    
    // TODO: Implement geo bounding box query
    
    res.json({ hotspots: [] });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch hotspots' });
  }
});

// Placeholder: GET /hotspots/nearby - Fetch nearby VERIFIED hotspots for Safety Mode
app.get('/hotspots/nearby', async (req, res) => {
  try {
    const { lat, lng, radius, limit } = req.query;
    
    // TODO: Implement nearby hotspot fetch (limited to 100 geofences)
    
    res.json({ hotspots: [] });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch nearby hotspots' });
  }
});

// Placeholder: POST /hotspots/:id/feedback - Flag / confirm / deny
app.post('/hotspots/:id/feedback', async (req, res) => {
  try {
    const { type, actor_id } = req.body;
    
    // TODO: Store validation event and update risk_score
    
    res.json({ message: 'Feedback recorded' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to record feedback' });
  }
});

app.listen(port, () => {
  console.log(`StreetDogs Backend running on port ${port}`);
});