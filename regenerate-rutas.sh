#!/usr/bin/env bash
# regenerate-rutas.sh — escanea RUTAS_BASE y regenera rutas.generated.sh con los
# aliases cd-* actualizados. Cross-platform (ChromeOS, macOS, Linux).
#
# La carpeta a escanear se lee de rutas.config.sh (RUTAS_BASE).
# Ejecutar:  bash regenerate-rutas.sh      ·      o vía función:  rutas-refresh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
CONFIG="$SCRIPT_DIR/rutas.config.sh"

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: falta $CONFIG" >&2
    echo "  Ejecuta primero:  bash \"$SCRIPT_DIR/install.sh\"" >&2
    exit 1
fi
# shellcheck source=/dev/null
. "$CONFIG"

DRIVE="${RUTAS_BASE:?RUTAS_BASE no está definido en rutas.config.sh}"
OUT="$SCRIPT_DIR/rutas.generated.sh"

if [ ! -d "$DRIVE" ]; then
    echo "ERROR: la carpeta base no existe: $DRIVE" >&2
    echo "  Edita RUTAS_BASE en $CONFIG (¿Drive montado?)." >&2
    exit 1
fi

# Normaliza nombres de carpeta a alias-safe (minúsculas; espacios/_ → guión; sin chars raros).
normalize() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' _' '--' | sed 's/^\.//' | sed 's/[^a-z0-9-]//g'
}

# Carpetas que NO generan alias: ocultas, screencast con fecha, Icon\r de Mac, duplicados "(N)".
should_skip() {
    local name="$1"
    [[ "$name" =~ ^\. ]] && return 0
    [[ "$name" =~ ^screencast-[0-9]{4}-[0-9]{2}-[0-9]{2} ]] && return 0
    [[ "$name" == Icon* ]] && return 0
    [[ "$name" =~ \([0-9]+\)$ ]] && return 0
    return 1
}

# Escritura atómica: generar en temporal y mover al final.
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

{
    echo "#!/usr/bin/env bash"
    echo "# rutas.generated.sh — AUTOGENERADO por regenerate-rutas.sh. NO EDITAR."
    echo "# Atajos personales en custom-aliases.sh · Regenerar: rutas-refresh"
    echo ""
    echo "export DRIVE=\"$DRIVE\""
    echo ""
    echo "# === Raíces ==="
    echo "alias cd-drive='cd \"\$DRIVE\"'"

    # Raíces (nivel 1)
    for root in "$DRIVE"/*/; do
        [ -d "$root" ] || continue
        root_name=$(basename "$root")
        should_skip "$root_name" && continue
        alias_root=$(normalize "$root_name")
        echo "alias cd-${alias_root}='cd \"\$DRIVE/${root_name}\"'"
    done

    # Subcarpetas (nivel 2)
    for root in "$DRIVE"/*/; do
        [ -d "$root" ] || continue
        root_name=$(basename "$root")
        should_skip "$root_name" && continue
        alias_root=$(normalize "$root_name")

        has_subs=false
        for sub in "$root"*/; do
            [ -d "$sub" ] || continue
            sub_name=$(basename "$sub")
            should_skip "$sub_name" && continue
            if ! $has_subs; then
                echo ""
                echo "# === ${root_name}/* ==="
                has_subs=true
            fi
            alias_sub=$(normalize "$sub_name")
            echo "alias cd-${alias_root}-${alias_sub}='cd \"\$DRIVE/${root_name}/${sub_name}\"'"
        done
    done
} > "$TMP"

mv "$TMP" "$OUT"
trap - EXIT

echo "✓ Regenerado $OUT ($(grep -c "^alias cd-" "$OUT") aliases)"

# Regenerar también el dashboard web (no bloquea ni falla si node no está instalado).
if command -v node >/dev/null 2>&1; then
    node "$SCRIPT_DIR/generate-dashboard.js" >/dev/null 2>&1 || true
fi
