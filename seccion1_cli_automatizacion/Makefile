.PHONY: help tools report all


help:
@echo "Targets disponibles: help, tools, report, all"


# tools: verifica presencia de herramientas necesarias
tools:
@for cmd in git bash make python3 pytest curl dig ss jq; do \
if command -v $$cmd >/dev/null 2>&1; then \
printf "%-10s ok\n" $$cmd; \
else \
printf "%-10s MISSING\n" $$cmd; \
fi; \
done


report: tools
@mkdir -p reports
@./scripts/syscheck.sh
@echo "Ejecutando curl para example.html..."
@curl -sS https://example.com -o reports/example.html || true
@echo "Ejecutando dig ANY google.com..."
@dig google.com ANY +noall +answer > reports/dig_output.txt || true
@curl -sS https://jsonplaceholder.typicode.com/posts/1 -o reports/api_response.json || true
@jq -r '.title' reports/api_response.json > reports/api_title.txt || true
@echo "Para cobertura, ejecutar: make coverage"


all: report
@echo "Todo generado. Archivos en reports/"


coverage:
@python3 -m coverage run -m pytest || true
@python3 -m coverage report --omit='*/venv/*' > coverage.txt || true
@echo "Coverage guardada en coverage.txt"