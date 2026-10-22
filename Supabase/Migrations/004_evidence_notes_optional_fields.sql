-- Run once in Supabase > SQL Editor

-- New fields
alter table submissions add column if not exists evidence_items jsonb default '[]'::jsonb;
alter table submissions add column if not exists notes text;

-- No field is required any more
alter table submissions alter column main_subject drop not null;
alter table submissions alter column topic_area drop not null;
alter table submissions alter column progress drop not null;
alter table submissions alter column evidence_link drop not null;

-- Fix week_start dates that were saved as the Sunday (timezone bug) -> Monday
update submissions set week_start = week_start + 1 where extract(dow from week_start) = 0;