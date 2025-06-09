# Feedbacks Reports API

API para gerenciamento de feedbacks de clientes da Incognia, com foco na listagem de resultados processados.

## Principais Tecnologias Utilizadas

- Ruby 3.2.2
- Rails 7
- PostgreSQL 14 (Banco de dados primário)
- Clickhouse (Banco de dados para consultas analíticas)

## Configuração do Ambiente

### Pré-requisitos

- Docker
- Docker Compose

### Instalação

1. Clone o repositório
```bash
git clone https://github.com/dealencarmarcelo/feedback-reports-api.git
cd feedback-reports-api
```

2. Inicie os containers
```bash
docker-compose up --build
```

A aplicação estará disponível em `http://localhost:3000`

## Arquitetura

O projeto utiliza uma arquitetura otimizada para alta performance com:

- **PostgreSQL com Replicação**: 
  - PostgreSQL (Organization, User): porta 5432
  - Clickhouse (Feedback, FeedbackResult): porta 8123
- **Redis**: Cache e filas do Sidekiq
- **Sidekiq**: Processamento assíncrono de feedbacks em massa

## Endpoints

### Listar Feedbacks

```http
GET /api/v1/feedbacks
Content-Type: application/json
```

Parâmetros de Query:
- `organization_id` (obrigatório): ID da organização
- `page_size`: Itens por página (default: 25)
- `account_ids[]`: Filtrar por IDs de conta
- `feedback_types[]`: Filtrar por tipos de feedback (verified, reset, account_takeover, identity_fraud)
- `date_range[start_date]`: Data inicial (formato: YYYY-MM-DD)
- `date_range[end_date]`: Data final (formato: YYYY-MM-DD)
- `date_type`: Tipo de data para filtro (feedback_time)
- `encoded_installation_ids[]`: Filtrar por IDs de instalação codificados

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

### Banco de Dados
- Utilização de uma arquitetura híbrida de PostgreSQL com Clickhouse:
  - A ideia é poder lidar de forma separada com a massa de dados e consultas analíticas.
  - Enquanto o Postgresql lida com registros de usuários e organizações, o Clickhouse é responsável por lidar com feedbacks e feedback_results que movimentam 300M de dados mensais.

> A arquitetura híbrida foi pensada para otimizar as consultas em cenários futuros onde os dados ultrapassarão 1B de registros.
> Durante testes de carga o Clickhouse demonstrou uma performance muito melhor para esse tipo de abordagem.


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

### Pendencias

- Corrigir conflitos existentes entre os bancos de dados da estrutura híbrida.
- Aprimorar fluxo de CI/CD.
- Aprimorar cenários de testes.
- Adicionar filtro por processed_time.
  - Foi removido devido a conflitos na configuração dos bancos de dados da estrutura híbrida.

### Diferenças da documentação inicial

- Foi notado após alguns testes de carga que o PostgreSQL poderia ser uma boa opção para o início, porém com o aumento da carga de registros diários, as consultas nesse banco passaram a ficar lentas, indo de encontro com o requisito de performance.
- Foi escolhido utilizar o Clickhouse como banco colunar pensando na alta carga de dados nos fluxos de leitura e filtragem, devido a sua ótima performance em cenários como esse.