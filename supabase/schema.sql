-- Run this in Supabase SQL Editor after creating a project.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default 'Campus rider',
  college_email text unique,
  is_verified boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.rides (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.profiles(id) on delete cascade,
  origin text not null,
  destination text not null,
  travel_date date not null,
  departure_time text not null,
  seats_available int not null check (seats_available between 1 and 8),
  price_per_seat numeric(10,2) not null check (price_per_seat >= 0),
  vehicle text,
  notes text,
  status text not null default 'open' check (status in ('open','full','cancelled')),
  created_at timestamptz not null default now()
);
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  ride_id uuid not null references public.rides(id) on delete cascade,
  rider_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','declined','cancelled')),
  created_at timestamptz not null default now(),
  unique(ride_id,rider_id)
);
alter table public.profiles enable row level security;
alter table public.rides enable row level security;
alter table public.bookings enable row level security;
create policy "Profiles are visible to signed-in users" on public.profiles for select to authenticated using (true);
create policy "Users create own profile" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "Users update own profile" on public.profiles for update to authenticated using (auth.uid() = id);
create policy "Signed-in users can view open rides" on public.rides for select to authenticated using (status = 'open' or driver_id = auth.uid());
create policy "Drivers create own rides" on public.rides for insert to authenticated with check (driver_id = auth.uid());
create policy "Drivers update own rides" on public.rides for update to authenticated using (driver_id = auth.uid());
create policy "Drivers delete own rides" on public.rides for delete to authenticated using (driver_id = auth.uid());
create policy "Riders view own bookings and drivers view ride bookings" on public.bookings for select to authenticated using (rider_id = auth.uid() or exists(select 1 from public.rides where rides.id = bookings.ride_id and rides.driver_id = auth.uid()));
create policy "Riders create own booking" on public.bookings for insert to authenticated with check (rider_id = auth.uid());
create policy "Riders cancel own booking" on public.bookings for update to authenticated using (rider_id = auth.uid());
create policy "Drivers update booking status" on public.bookings for update to authenticated using (exists(select 1 from public.rides where rides.id = bookings.ride_id and rides.driver_id = auth.uid()));
-- Automatically create a profile for each new account.
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id,full_name,college_email) values(new.id,coalesce(new.raw_user_meta_data->>'full_name','Campus rider'),new.email) on conflict(id) do nothing;
  return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
