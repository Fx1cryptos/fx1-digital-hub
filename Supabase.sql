-- Users table
create table users (
  id uuid primary key default gen_random_uuid(),
  wallet_address text unique not null,
  username text,
  created_at timestamp default now()
);

-- Rewards (daily streaks + tasks)
create table rewards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  type text not null, -- "streak", "task", "challenge"
  amount int not null,
  created_at timestamp default now()
);

-- Leaderboard view
create view leaderboard as
select u.username, u.wallet_address, sum(r.amount) as total_rewards
from users u
join rewards r on u.id = r.user_id
group by u.id
order by total_rewards desc;
