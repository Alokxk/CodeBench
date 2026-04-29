# CodeBench

A code judge that doesn't just check your output — it checks if you understand your solution. Submit Python code, run it in an isolated Docker container, get evaluated against multiple test cases. On accepted, Gemini generates follow-up questions specific to your code and evaluates your answers.


## How It Works

1. User submits Python code via the React frontend
2. Rails saves the submission and enqueues a Sidekiq job — returns 202 immediately
3. Sidekiq worker runs the code inside an isolated Docker container with strict resource limits
4. Output is compared against all test cases — partial results tracked (e.g. 3/4 passed)
5. Frontend polls until status is terminal
6. On accepted: Gemini generates 3 short follow-up questions specific to the user's code
7. User has 3 minutes to answer — Gemini evaluates leniently and explains each result


## Submission Statuses

- `accepted`: All test cases passed
- `wrong_answer`: Output mismatch on at least one test case
- `runtime_error`: Non-zero exit code
- `compile_error`: Python SyntaxError detected
- `time_limit_exceeded`: Execution exceeded 10 seconds


## Stack

- **API:** Ruby on Rails 7.2 (API mode)
- **Background jobs:** Sidekiq + Redis
- **Database:** PostgreSQL
- **Execution sandbox:** Docker (python:3.11-alpine)
- **AI follow-up:** Google Gemini 2.5 Flash
- **Frontend:** React + Vite


## Run Locally

**Prerequisites:** Ruby 3.2.2, Rails 7.2, PostgreSQL, Redis, Docker

```bash
git clone https://github.com/Alokxk/CodeBench.git
cd CodeBench
bundle install
rails db:create db:migrate db:seed
docker pull python:3.11-alpine
```

Create `.env` in the project root:

```
GEMINI_API_KEY=your_key_here
SIDEKIQ_WEB_PASSWORD=any_password_you_want
SIDEKIQ_WEB_SECRET=run `ruby -e "require 'securerandom'; puts SecureRandom.hex(32)"` and paste output here
```

Get a free Gemini API key at [aistudio.google.com](https://aistudio.google.com).

```bash
# Terminal 1
rails server

# Terminal 2
bundle exec sidekiq -C config/sidekiq.yml

# Terminal 3
cd frontend && npm install && npm run dev
```

Open `http://localhost:5173`


## NOTE

See [ARCHITECTURE.md](./ARCHITECTURE.md) for engineering decisions.