-- StudentHub schema

create table students (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  pathway text not null,
  active boolean default true,
  created_at timestamptz default now()
);

create table submissions (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references students(id) on delete cascade not null,
  week_start date not null,
  focus text not null,
  roadmap_item text not null,
  progress text not null,
  evidence_type text not null,
  evidence_link text,
  challenges text,
  support_needed text,
  next_week_commitment text,
  submitted_at timestamptz default now(),
  admin_note text,
  flagged boolean default false,
  unique (student_id, week_start)
);

alter table students enable row level security;
alter table submissions enable row level security;

-- Students can see their own profile
create policy "students read own profile"
on students for select
using (auth.uid() = id);

-- Students can see + insert their own submissions
create policy "students read own submissions"
on submissions for select
using (auth.uid() = student_id);

create policy "students insert own submissions"
on submissions for insert
with check (auth.uid() = student_id);

-- Admin (identified by email) can see + update everything
create policy "admin read all students"
on students for select
using (auth.jwt() ->> 'email' in ('admin@example.com'));

create policy "admin read all submissions"
on submissions for select
using (auth.jwt() ->> 'email' in ('admin@example.com'));

create policy "admin update submissions"
on submissions for update
using (auth.jwt() ->> 'email' in ('admin@example.com'));

create policy "admin update students"
on students for update
using (auth.jwt() ->> 'email' in ('admin@example.com'));