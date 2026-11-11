# RideMate — Campus Carpooling Platform

A polished, responsive campus carpooling app built with **Next.js 15, TypeScript, Tailwind CSS and Supabase**. Deploys to Vercel.

## Features
- Search rides by pickup, destination and date.
- Route matching score (exact/partial pickup + destination + date).
- Sort by best match, lowest fare or earliest departure.
- Driver cards, vehicle details, ratings, verification indicator, seats and ride notes.
- Fare-per-seat display and estimated equal cost split.
- Publish a ride with date, time, seats, fare, vehicle and notes.
- Request a seat and track your own offered rides / requested seats.
- Responsive layout for desktop and mobile.
- Demo mode works immediately using browser local storage.
- Optional Supabase email/password authentication and shared database schema.

## Run locally

```bash
npm install
npm run dev
```

Open http://localhost:3000.

## Deploy to Vercel

1. Push this folder to a GitHub repository.
2. Import the repository at https://vercel.com/new.
3. Framework preset: **Next.js**. Build command: `npm run build`.
4. Deploy. The app works in demo mode without environment variables.
5. For shared accounts and data, create a Supabase project and follow the setup below.

## Enable Supabase (recommended before real users)

1. Create a project at https://supabase.com.
2. Open **SQL Editor** and run `supabase/schema.sql`.
3. Copy Project URL and anon/public key from **Project Settings → API**.
4. Add these in Vercel → Project → Settings → Environment Variables, and in `.env.local` for local development:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

5. Redeploy after setting the variables.

## Important implementation notes

- Demo mode stores ride listings and seat requests in the current browser only. It is for judging, previews and UI demonstrations—not cross-device or multi-user persistence.
- Supabase mode enables account registration/login and database writes. Run the SQL schema and configure environment variables before inviting real users.
- The sample rides are fictional demo data. Remove or replace them before a real launch.
- A “verified” badge in demo data is illustrative. Real student verification requires an institution-email allowlist or manual admin verification workflow; do not treat the sample badge as proof of identity.
- The matching score is a transparent text-based route similarity heuristic, not live GPS routing or a trained AI model. For production-grade routing, add Google Maps Routes/Places API and store verified coordinates.
- Do not collect sensitive identity documents or expose private phone numbers publicly. Confirm pickup details privately and follow campus transport/safety policies.

## Project structure

```text
app/                 Next.js app and responsive UI
lib/matching.ts      Route score and fare split utilities
lib/supabase.ts      Optional Supabase client
supabase/schema.sql  Database tables, RLS policies and profile trigger
.env.example         Environment variable template
```

## Suggested next production upgrades
- Google Maps Places autocomplete and route distance/time estimates.
- Driver/rider chat and booking accept/decline workflow.
- Institutional email domain verification and admin moderation.
- Live seat count updates, notifications and cancellation policies.
- Real user ratings after completed rides.

## License
MIT — see `LICENSE`.
