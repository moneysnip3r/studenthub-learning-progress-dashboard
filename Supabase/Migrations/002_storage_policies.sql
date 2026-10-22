-- Run in Supabase SQL Editor after creating the "evidence" bucket

create policy "students upload own evidence"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'evidence'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "students update own evidence"
on storage.objects for update
to authenticated
using (
  bucket_id = 'evidence'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "public read evidence"
on storage.objects for select
using (bucket_id = 'evidence');