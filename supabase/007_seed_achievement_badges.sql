-- ================================================================
-- 007 - Seed the achievement badges from the approved Figma (FKP-137)
--
-- Optional. Run after 006. Inserts only badges whose title is not
-- already present, so it is safe to re-run and won't touch badges an
-- admin already created. Icons are left NULL (the app shows a default
-- badge); upload artwork from the admin dashboard and set icon_url.
-- ================================================================

INSERT INTO public.badges
  (title, description, category, sort_order, target_count, progress_unit, how_to_earn, earned_message, active)
SELECT v.title, v.description, v.category, v.sort_order, v.target_count, v.progress_unit, v.how_to_earn, v.earned_message, true
FROM (VALUES
  -- Daily Practice
  ('First Solve',          'You solved your first Problem of the Day.',                                   'Daily Practice',        10, 1,  'problems', 'Solve your first Problem of the Day.',                  'This badge marks your first step into daily practice.'),
  ('3-Day Streak',         'You maintained a daily problem-solving streak for three consecutive days.',   'Daily Practice',        11, 3,  'days',     'Solve daily problems for three consecutive days.',      'Consistency is building. Keep the streak going.'),
  ('7-Day Streak',         'You maintained a daily problem-solving streak for seven consecutive days.',   'Daily Practice',        12, 7,  'days',     'Solve daily problems for seven consecutive days.',      'A full week of practice. Great consistency.'),
  ('30-Day Streak',        'You maintained a daily problem-solving streak for thirty consecutive days.',  'Daily Practice',        13, 30, 'days',     'Solve daily problems for thirty consecutive days.',     'A month of daily practice. Outstanding dedication.'),
  ('Consistent Solver',    'You solved 50 Problems of the Day.',                                          'Daily Practice',        14, 50, 'problems', 'Solve 50 Problems of the Day.',                         'You have made problem solving a habit.'),
  -- Participation
  ('First Event',          'You attended your first Flutter Kanpur event.',                               'Participation',         20, 1,  'events',   'Attend your first Flutter Kanpur event.',               'This badge marks your first step into community participation.'),
  ('Contest Participant',  'You took part in your first contest.',                                        'Participation',         21, 1,  'contests', 'Participate in a contest.',                             'Every contest makes you sharper.'),
  ('Contest Finisher',     'You completed every problem in a contest.',                                   'Participation',         22, 1,  'contests', 'Complete all problems in a contest.',                   'You saw a contest through to the end.'),
  ('Active Participant',   'You attended 5 community events.',                                            'Participation',         23, 5,  'events',   'Attend 5 community events.',                            'You are a regular face in the community.'),
  -- Contribution
  ('Contributor',          'You became a Flutter Kanpur contributor.',                                    'Contribution',          30, 1,  '',         'Get your contributor application approved.',            'Thank you for helping the community grow.'),
  ('First Contribution',   'You made your first contribution to the community.',                         'Contribution',          31, 1,  'contributions', 'Make your first contribution.',                   'Your first contribution is in. Many more to come.'),
  ('Active Contributor',   'You made 10 contributions to the community.',                                 'Contribution',          32, 10, 'contributions', 'Make 10 contributions to the community.',         'Your contributions keep the community moving.'),
  -- Community Milestones
  ('Community Member',     'You joined the Flutter Kanpur community.',                                    'Community Milestones',  40, 1,  '',         'Join the Flutter Kanpur community.',                    'Welcome to Flutter Kanpur.'),
  ('Core Member',          'You became a core member of Flutter Kanpur.',                                 'Community Milestones',  41, 1,  '',         'Become a core team member.',                            'You help lead the Flutter Kanpur community.')
) AS v(title, description, category, sort_order, target_count, progress_unit, how_to_earn, earned_message)
WHERE NOT EXISTS (
  SELECT 1 FROM public.badges b WHERE lower(b.title) = lower(v.title)
);
