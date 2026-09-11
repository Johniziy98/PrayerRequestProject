-- Prayer Request database for Supabase
-- Run this entire script in Supabase Dashboard -> SQL Editor.

create table if not exists public.prayers (
  id bigint generated always as identity primary key,
  prayer_text text not null check (char_length(trim(prayer_text)) between 1 and 2000),
  name text not null default '' check (char_length(name) <= 80),
  submitted_at timestamptz not null default now(),
  support_count integer not null default 0 check (support_count >= 0)
);

create index if not exists prayers_submitted_at_idx
  on public.prayers (submitted_at desc, id desc);

alter table public.prayers enable row level security;

drop policy if exists "Anyone can read prayers" on public.prayers;
create policy "Anyone can read prayers"
  on public.prayers for select
  to anon, authenticated
  using (true);

drop policy if exists "Anyone can submit prayers" on public.prayers;
create policy "Anyone can submit prayers"
  on public.prayers for insert
  to anon, authenticated
  with check (
    char_length(trim(prayer_text)) between 1 and 2000
    and char_length(name) <= 80
    and support_count = 0
  );

-- Support/pray count is changed through this function so the browser
-- does not need direct UPDATE permission on the table.
create or replace function public.support_prayer(p_id bigint)
returns public.prayers
language plpgsql
security definer
set search_path = public
as $$
declare
  updated_prayer public.prayers;
begin
  update public.prayers
     set support_count = support_count + 1
   where id = p_id
   returning * into updated_prayer;

  if updated_prayer.id is null then
    raise exception 'Prayer not found';
  end if;

  return updated_prayer;
end;
$$;

revoke all on function public.support_prayer(bigint) from public;
grant execute on function public.support_prayer(bigint) to anon, authenticated;

grant select, insert on public.prayers to anon, authenticated;
grant usage, select on sequence public.prayers_id_seq to anon, authenticated;
