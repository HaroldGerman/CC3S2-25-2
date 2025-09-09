#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Ocurrió un error. Revisar salida y archivos generados." >&2' ERR

# Carpeta reports ya creada, fuera de scripts
OUT_DIR="$(dirname "$0")/../reports"

# 1) HTTP
echo "=== HTTP (curl -Is) ===" > "$OUT_DIR/http.txt"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -I https://example.com || echo "000")
curl -Is https://example.com >> "$OUT_DIR/http.txt" || true
case "$HTTP_STATUS" in
  200) echo "HTTP $HTTP_STATUS: OK — recurso encontrado y servido correctamente." >> "$OUT_DIR/http.txt" ;;
  301|302) echo "HTTP $HTTP_STATUS: Redirección. El recurso fue movido temporal/permanently." >> "$OUT_DIR/http.txt" ;;
  4??) echo "HTTP $HTTP_STATUS: Error cliente — comprobar URL o permisos." >> "$OUT_DIR/http.txt" ;;
  5??) echo "HTTP $HTTP_STATUS: Error servidor — fallo en la petición." >> "$OUT_DIR/http.txt" ;;
  *) echo "HTTP $HTTP_STATUS: Código desconocido o fallo en la conexión." >> "$OUT_DIR/http.txt" ;;
esac

# 2) DNS
echo "=== DNS (dig) ===" > "$OUT_DIR/dns.txt"
for t in A AAAA MX; do
  echo "\n--- dig $t example.com +noall +answer ---" >> "$OUT_DIR/dns.txt"
  dig $t example.com +noall +answer >> "$OUT_DIR/dns.txt" || true
done
TTL_VAL=$(dig A example.com +noall +answer | awk '/IN/ {print $2; exit}') || true
if [ -n "$TTL_VAL" ]; then
  echo "\n# El TTL observado en la respuesta (segundos) es: $TTL_VAL. TTL indica cuánto tiempo pueden cachearse las respuestas DNS." >> "$OUT_DIR/dns.txt"
else
  echo "\n# No se detectó TTL en la salida (posible ausencia de respuesta A)." >> "$OUT_DIR/dns.txt"
fi

# 3) TLS
echo "=== TLS (curl -Iv + openssl) ===" > "$OUT_DIR/tls.txt"
curl -Iv https://example.com 2>&1 | sed -n '1,120p' >> "$OUT_DIR/tls.txt" || true
if command -v openssl >/dev/null 2>&1; then
  echo "\n--- openssl s_client ---" >> "$OUT_DIR/tls.txt"
  echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | sed -n '1,200p' >> "$OUT_DIR/tls.txt" || true
  PROT=$(echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | grep -i "Protocol  :" | head -n1 | awk -F":" '{gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}' || true)
  if [ -n "$PROT" ]; then
    echo "\nVersión TLS observada: $PROT" >> "$OUT_DIR/tls.txt"
  fi
else
  echo "openssl no instalado; no se pudo ejecutar s_client." >> "$OUT_DIR/tls.txt"
fi

# 4) Sockets
echo "=== Sockets (ss -tuln) ===" > "$OUT_DIR/sockets.txt"
ss -tuln 2>/dev/null >> "$OUT_DIR/sockets.txt" || echo "ss no disponible" >> "$OUT_DIR/sockets.txt"
cat >> "$OUT_DIR/sockets.txt" <<'EOF'

# Riesgos comunes:
# 1) Puertos abiertos innecesarios exponen la superficie de ataque.
# 2) Servicios escuchando en todas las interfaces (0.0.0.0) pueden ser accesibles desde redes no confiables.
EOF

echo "Reportes generados en $OUT_DIR: http.txt, dns.txt, tls.txt, sockets.txt"
