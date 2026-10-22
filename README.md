# StudentHub Learning Progress Dashboard

A simple weekly check-in tool for StudentHub members: each week students record what they learned and the evidence for it, and the team can see who is progressing, who is stuck, and who has gone quiet.

Live with StudentHub Cohort 1.

## What it does

**Students**
- Log in and submit a weekly update, either Technical Learning (subject and topics) or Role Development (role and area)
- Attach as many evidence links and files as needed, and add challenges, support needed and notes
- Edit this week's updates and open any previous submission to see the full detail

**Admins**
- See every update across the cohort, filtered by type
- Open an update for full detail, add an admin note, and flag students who need attention
- See at a glance how many students have submitted this week

## Tech stack

- HTML, CSS and JavaScript (no framework, no build step)
- Supabase: Auth, PostgreSQL with Row Level Security, and Storage for evidence files
- Netlify for hosting

## Project structure

```
index.html        Landing page: choose student or admin
student.html      Student side
admin.html        Admin side
supabase/
  migrations/     Database scripts, numbered in the order they were run
  admin/          Admin-access script
```

## Known issues and technical debt

Named here on purpose. This is a working production tool, and these are the next things to fix.

1. **JavaScript and CSS are embedded in the HTML files.** Each page holds its own styles and script, and some code (date helpers, escaping, colours, the Supabase client setup) is duplicated across pages. They should be split into shared `css/` and `js/` files.
2. **The Supabase URL and anon key are written directly into each page.** The anon key is designed to be public and the data is protected by Row Level Security, but the values should live in one shared config file.
3. **Admin emails are hardcoded in the database policies.** Adding an admin means dropping and recreating four policies, and the emails are also visible in `supabase/admin/add_admin.sql`. This should move to an `admins` table.
4. **A policy is missing from the SQL files.** Students can edit their own submissions in the live database, but the policy that allows it was never saved to a file, so the repo cannot yet rebuild the database from scratch.
5. **The SQL files are one-off scripts, not a current schema.** `001_initial_schema.sql` describes the original tables, which later migrations changed. There is no single file showing the schema as it is today.
6. **Old columns are still in the table.** `progress`, `next_focus` and `evidence_link` are no longer collected or are only read for old submissions, but they have not been removed.
7. **The evidence bucket is public.** Anyone with a file's link can open it. It should become private, with access through signed links.
8. **Student edits are never locked.** A student can edit an update at any time, including after the week has ended.
9. **No password reset.** Students who forget their password need an admin to reset it.
10. **Students and admins are created by hand.** Accounts are added one at a time in the Supabase dashboard, with no bulk import.
11. **The reporting week uses the device's date.** A device with the wrong date or time zone would put an update in the wrong week.
12. **Dropdown options are hardcoded** in `student.html` and must be edited in the code when the cohort moves to new subjects.
13. **No retention policy for uploaded evidence files.**
14. **No automated tests, and deployment is manual** (drag and drop into Netlify).
15. **Admin login shows the raw error message without escaping it.** Minor, but it should use the same escaping as the rest of the page.

## Roadmap

- Split JavaScript and CSS into separate shared files and add a configuration file
- Design pass: build the design in a design tool, then bring it over in HTML, CSS and JavaScript
- Replace hardcoded admin emails with an `admins` table
- Add a current-state schema file, including the missing policy
- Private evidence bucket with signed links
- Password reset, edit lock after the reporting week, and bulk student import
- Connect Netlify to GitHub so every merge to `main` deploys automatically

## Code standards

Every file starts with a header comment saying what it does and what it depends on. Comments explain why something is done, not what the line says. Database scripts are numbered in the order they were run.
