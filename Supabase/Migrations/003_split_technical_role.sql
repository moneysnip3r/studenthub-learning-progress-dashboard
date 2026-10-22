-- Migration: split submissions into Technical Learning / Role Development
-- Run this in Supabase SQL Editor. Safe to run even with existing test rows.

-- 1. Add update_type to distinguish the two categories
alter table submissions
  add column update_type text not null default 'technical'
  check (update_type in ('technical', 'role'));

-- 2. Rename fields to generic names that fit both categories
--    focus         -> main_subject   (e.g. "JavaScript" or "QA Tester")
--    roadmap_item  -> topic_area     (e.g. "Arrays" or "Test Case Design")
alter table submissions rename column focus to main_subject;
alter table submissions rename column roadmap_item to topic_area;

-- 3. Rename next_week_commitment -> next_focus (matches new spec wording)
alter table submissions rename column next_week_commitment to next_focus;

-- 4. Drop the old evidence_type dropdown field — no longer collected
alter table submissions drop column if exists evidence_type;

-- 5. Remove the one-submission-per-week constraint
--    Students can now submit multiple updates (technical + role, or several of each) per week
alter table submissions drop constraint if exists submissions_student_id_week_start_key;