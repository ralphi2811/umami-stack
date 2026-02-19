.PHONY: help up down logs restart status backup clean validate secrets

help: ## Show this help message
	@echo "Umami Analytics Stack - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: ## Start the stack
	docker compose up -d

down: ## Stop the stack
	docker compose down

logs: ## View logs from all services
	docker compose logs -f

restart: ## Restart all services
	docker compose restart

status: ## Show status of all services
	docker compose ps

backup: ## Backup PostgreSQL database
	@mkdir -p backups
	docker compose exec postgres pg_dump -U umami umami > backups/umami-backup-$$(date +%Y%m%d-%H%M%S).sql
	@echo "Backup created in backups/ directory"

clean: ## Stop and remove all containers and volumes (⚠️  DELETES DATA)
	@echo "⚠️  WARNING: This will delete all data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All data removed."; \
	else \
		echo "Cancelled."; \
	fi

validate: ## Validate docker-compose.yml configuration
	docker compose config --quiet && echo "✓ Configuration is valid"

secrets: ## Generate secure secrets for .env file
	@echo "Generated secrets (add these to your .env file):"
	@echo ""
	@echo "APP_SECRET=$$(openssl rand -base64 32)"
	@echo "POSTGRES_PASSWORD=$$(openssl rand -base64 24)"
	@echo ""
