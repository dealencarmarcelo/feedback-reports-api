# Feedbacks Reports API

API for managing customer feedbacks from Incognia, focused on listing processed results.

## Main Technologies Used
- Ruby 3.2.2
- Rails 7
- PostgreSQL 14 (Primary database)
- Clickhouse (Database for analytical queries)

## Environment Setup
### Prerequisites
- Docker
- Docker Compose

### Installation
1. Clone the repository

```bash
git clone https://github.com/dealencarmarcelo/feedback-reports-api.git
cd feedback-reports-api
```

2. Start the containers
```bash
docker-compose up --build
```

The application will be available at `http://localhost:3000`

## Architecture

The project uses an architecture optimized for high performance with:

- **Banco de dados**: 
  - PostgreSQL (Organization, User): port 5432
  - Clickhouse (Feedback, FeedbackResult): port 8123
- **API Only**: Exposes only JSON endpoints; no MVC views. Models represent entities, and serializers format JSON
responses.
- **Service Objects**: Handle complex business logic outside controllers/models.

## Endpoints

### Listar Feedbacks

```http
GET /api/v1/feedbacks
Content-Type: application/json
```

Parâmetros de Query:
- `organization_id` (required): Organization ID
- `page_size`:  Items per page (default: 25)
- `account_ids[]`: Filter by account IDs
- `feedback_types[]`: Filter by feedback types (verified, reset, account_takeover, identity_fraud)
- `date_range[start_date]`: Start date (format: YYYY-MM-DD)
- `date_range[end_date]`: End date (format: YYYY-MM-DD)
- `date_type`: Type of date to filter (feedback_time)
- `encoded_installation_ids[]`: Filter by encoded installation IDs

Response (200 OK):
```json
{
  "feedbacks": [
    {
      "id": "07a393c9-9bee-4f8a-8ac6-026d893308a3",
      "organization_id": "dc20ec6d-b822-40a2-8a31-f3105fdc45ac",
      "reported_by_user_id": "da565ad9-101d-4fe7-96eb-a939af4599a5",
      "account_id": "93b4f961-5f9c-4796-a7a6-4117088a61ff",
      "installation_id": "b19d5215-51a5-40cc-9258-9c12dfcddd42",
      "encoded_installation_id": "YjE5ZDUyMTUtNTFhNS00MGNjLTkyNTgtOWMxMmRmY2RkZDQyOjA3MmIwOGI0LTg5ZWYtNDViYy1iODJmLTk3NGRkZjA0MjE1NQ==",
      "feedback_type": "reset",
      "feedback_time": "2025-05-28T02:59:26.000Z",
      "feedback_type_label": "Reset",
      "user": {
        "name": "Blaine Abernathy Ret.",
        "email": "horacio@monahan.test"
      },
      "feedback_result": {
        "affected_devices": 13,
        "estimated_affected_accounts": 7
      }
    },
  ],
  "meta": {
    "page_size": 50,
    "cursor": "2025-05-28T02:52:02.000Z"
  }
}
```

## Otimizações

### Database
- Uses a hybrid architecture with PostgreSQL and Clickhouse:
  - The idea is to separate transactional data from analytical queries.
  - While PostgreSQL manages user and organization records, Clickhouse handles feedbacks and feedback_results, which process around 300M records per month.

> The hybrid architecture was designed to optimize queries in future scenarios where data volume exceeds 1B records.
> During load testing, Clickhouse showed significantly better performance for this use case.


## Desenvolvimento

### Executar Testes

```bash
docker-compose run --rm web bundle exec rspec
```

### Console

```bash
docker-compose run --rm web rails console
```

### Logs

```bash
# Aplicação
docker-compose logs -f web
```

### Pending Tasks

- Add API documentation (e.g. Swagger)
- Fix existing conflicts between databases in the hybrid structure.
- Improve CI/CD flow.
- Improve test coverage.
- Add filtering by processed_time.
    > It was removed due to database configuration conflicts in the hybrid structure.

### Differences from the Initial Documentation
- After load testing, it was observed that PostgreSQL could work well initially, but as daily record volume increased, queries became slower, conflicting with performance requirements.
- Clickhouse was chosen as a columnar database for handling high data volumes in read/filter flows, thanks to its excellent performance in such scenarios.