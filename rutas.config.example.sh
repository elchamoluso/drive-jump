# rutas.config.example.sh — plantilla de configuración.
#
# Copia este archivo a  rutas.config.sh  y edítalo (install.sh lo crea por ti).
# rutas.config.sh está en .gitignore: es TUYO, no se publica.
#
# Lo leen tanto los scripts de shell (lo sourcean) como el generador de Node,
# así que mantén el formato simple  CLAVE="valor".

# --- Carpeta base que quieres navegar y escanear -----------------------------
# Puede ser tu Google Drive o CUALQUIER carpeta. Pon la ruta ABSOLUTA.
# Ejemplos:
#   ChromeOS (Crostini): /mnt/chromeos/GoogleDrive/MyDrive
#   macOS (Google Drive): /Users/TU_USUARIO/Library/CloudStorage/GoogleDrive-TUCORREO@gmail.com/My Drive
#   Linux (rclone, etc.): /home/TU_USUARIO/GoogleDrive
#   Cualquier carpeta:    /home/TU_USUARIO/Documentos
RUTAS_BASE="$HOME"

# --- Puerto del dashboard web local ------------------------------------------
RUTAS_PORT="7777"

# --- Branding del dashboard (opcional) ---------------------------------------
RUTAS_TITLE="Rutas"
RUTAS_EMOJI="🗂️"
RUTAS_ACCENT="#0070f3"
