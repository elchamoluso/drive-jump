#!/usr/bin/env bash
# custom-aliases.example.sh — plantilla de atajos personales.
#
# Copia este archivo a  custom-aliases.sh  y pon TUS atajos.
# custom-aliases.sh está en .gitignore (es tuyo, no se publica) y se carga
# DESPUÉS de los aliases autogenerados, así que puedes acortar nombres largos.
#
# $DRIVE apunta a tu RUTAS_BASE (lo exporta rutas.generated.sh).
# Tras editar este archivo, recarga la terminal o ejecuta:  rutas-refresh

# Atajos cortos (sobrescriben los nombres largos autogenerados cd-<raiz>-<sub>)
alias cd-proj='cd "$DRIVE/proyectos"'
alias cd-docs='cd "$DRIVE/documentos"'

# Enlaces profundos a carpetas que visitas mucho
alias cd-cliente-x='cd "$DRIVE/proyectos/cliente-x/entregables"'

# Carpetas locales (fuera del Drive)
alias cd-home='cd "$HOME"'
alias cd-downloads='cd "$HOME/Downloads"'
