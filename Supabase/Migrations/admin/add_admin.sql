-- Run in Supabase SQL Editor to add another admin
-- Replace these example addresses with the real admin emails before running.

drop policy "admin read all students" on students;
drop policy "admin read all submissions" on submissions;
drop policy "admin update submissions" on submissions;
drop policy "admin update students" on students;

create policy "admin read all students"
on students for select
using (auth.jwt() ->> 'email' in ('admin1@example.com', 'admin2@example.com', 'admin3@example.com'));

create policy "admin read all submissions"
on submissions for select
using (auth.jwt() ->> 'email' in ('admin1@example.com', 'admin2@example.com', 'admin3@example.com'));

create policy "admin update submissions"
on submissions for update
using (auth.jwt() ->> 'email' in ('admin1@example.com', 'admin2@example.com', 'admin3@example.com'));

create policy "admin update students"
on students for update
using (auth.jwt() ->> 'email' in ('admin1@example.com', 'admin2@example.com', 'admin3@example.com'));