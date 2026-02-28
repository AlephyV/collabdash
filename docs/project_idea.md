# CollabDash — Ideia do Projeto

CollabDash é uma plataforma de gerenciamento de projetos e tarefas colaborativa multi-tenant, construída para aprender e demonstrar práticas profissionais de desenvolvimento Rails.

## Funcionalidades Planejadas

### 1. Autenticação e Perfil
- Cadastro, confirmação de e-mail, recuperação de senha e "Lembrar-me" via **Devise**
- Login social com Google e GitHub via **OmniAuth**

### 2. Multi-tenancy (Organizações)
- Um `User` pertence a uma `Account` (organização/time)
- Isolamento estrito de dados entre organizações
- Autorização granular com **Pundit** (controle de quem pode editar o quê)

### 3. CRUDs Complexos e Nested Resources
Hierarquia de recursos:
```
Organization → Project → Task → Comment
```
- Rotas aninhadas Rails (ex: `/projects/1/tasks/new`)
- CRUDs completos em cada nível da hierarquia

### 4. Upload de Arquivos
- Anexos de imagens e PDFs às tarefas via **Active Storage**
- Armazenamento em Amazon S3 ou DigitalOcean Spaces
- Interface com **Tailwind CSS**

### 5. Background Jobs e Monitoramento
- Notificações por e-mail processadas em segundo plano com **Sidekiq + Redis**
- Logs estruturados para rastreamento de erros em produção

### 6. Dashboards em Tempo Real
- Comentários aparecem instantaneamente para todos os usuários da tarefa via **Turbo Streams** (sem refresh de página)
- Action Cable via Solid Cable em desenvolvimento; Redis em produção

## Stack Técnica Alvo

| Camada | Tecnologia |
|---|---|
| Autenticação | Devise + OmniAuth |
| Autorização | Pundit |
| Frontend | Tailwind CSS + Hotwire (Turbo + Stimulus) |
| Upload | Active Storage + S3 |
| Jobs | Sidekiq + Redis (ou Solid Queue em dev) |
| Real-time | Turbo Streams + Action Cable |
| Deploy | Kamal + Docker |
