
# 🎮 BattleQuest API

Robust API for processing game telemetry, dashboard metrics, and player statistics.

## 🚀 Getting Started

Follow the commands below in order to set up the environment with real data:

```bash
# 1. Clone the repository
git clone https://github.com/ewertoncodes/battlequest-api
cd battlequest-api
cp .env.example .env


# 2. Start the containers
docker compose up -d --build

# 3. Set up the database
docker compose exec web bundle exec rails db:prepare

# 4. Import game logs
docker compose exec web bundle exec rake logs:import

# 5. Generate API key
docker compose exec web bundle exec rake api:generate_key
```

**⚠️ Important:** Save the token generated in step 5. You'll need it to unlock endpoints in Swagger.

## 📊 Documentation & Testing

Interactive documentation (Swagger) is available at: **http://localhost:3000/api-docs**

```bash
# Sync Swagger definitions
docker compose exec web bundle exec rake rswag:specs:swaggerize

# Run tests (RSpec)
docker compose exec web bundle exec rspec
```

## 🛠️ Support Commands

| Action | Command |
|--------|---------|
| View live logs | `docker compose logs -f web` |
| Rails console | `docker compose exec web bundle exec rails c` |
| Restart server | `docker compose restart web` |
| Reset database | `docker compose exec web bundle exec rails db:drop db:create db:migrate` |

## 💡 Testing Tips

1. Click **Authorize** button at the top of Swagger UI
2. Paste your API Key
3. Execute `/api/v1/dashboard` to see consolidated metrics
