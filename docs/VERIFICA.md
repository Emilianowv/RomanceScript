# Pruebas de RomanceScript

Las comprobaciones usan el motor real libxkbcommon y las tablas Compose de Linux. El entorno de referencia es Debian 13 con KDE Plasma 6. Las pruebas no instalan el teclado en el escritorio abierto.

## Qué se comprueba

- Las 49 posiciones en cuatro niveles: 196 estados contra el manifiesto.
- ñ/Ñ, ;/:, ¿/¡ y los niveles AltGr conservados.
- Los acentos de vocales, las ligaduras œ/Œ y æ/Æ, ç/Ç y ß/ẞ.
- Breve+a/A → ă/Ă y Mayús+esa tecla seguido de s/S o t/T → ș/Ș y ț/Ț.
- Bloq Mayús, Control y las secuencias de Compose. Grave seguido de Espacio produce el apóstrofo recto y grave dos veces produce el grave literal.
- Las letras principales de español, portugués, francés, italiano, rumano y catalán, incluidas las mayúsculas. La puntuación y los caracteres auxiliares se muestran aparte.
- Instalación, repetición, actualización del bloque anterior, respaldo, recuperación, conflictos y retirada en directorios temporales.
- Compilación X11 y comparación del mapa exportado por un KWin Wayland aislado y de un mapa cargado y releído en un servidor Xwayland independiente.
- Instalación, reinstalación y retirada del paquete con dpkg en una raíz temporal. El workflow Debian añade un ciclo en un contenedor desechable.
- En Windows Server 2022 x64, los controles estáticos del KLC, la compilación, la instalación, la reinstalación, las teclas mediante la API Win32 y la desinstalación.

## Reproducir las pruebas

```bash
sudo apt install make python3 libxkbcommon-tools xkb-data x11-xkb-utils dpkg-dev fakeroot
make check
make build
python3 scripts/test_deb.py
```

El test dpkg temporal utiliza fakeroot y las herramientas del sistema anfitrión. El modo `--live` está reservado a contenedores desechables: no debe ejecutarse en el sistema del usuario.

Para KWin y X11 aislados:

```bash
sudo apt install kwin-wayland xwayland dbus gcc pkg-config libwayland-dev fuse3
python3 scripts/test_kwin.py
```

Estos tests necesitan sockets e IPC que algunos entornos aislados bloquean. Los procesos y los archivos temporales se retiran al terminar.

## Límites

No se ha abierto una sesión completa Plasma Xorg para estas pruebas: X11 se comprueba mediante un servidor Xwayland independiente. El catálogo se comprueba con libxkbregistry; esto no equivale a completar una selección manual en cada interfaz de escritorio.

La compilación y el mapa correcto no garantizan la escritura en todas las aplicaciones, especialmente si utilizan su propio método de entrada. Tras instalar, cerrar sesión y volver a entrar, conviene escribir en las aplicaciones habituales:

```text
ñ Ñ ç Ç ß ẞ œ Œ æ Æ
á é í ó ú À È Ì Ò Ù
ã õ â ê î ô û ä ë ï ö ü ÿ
ă Ă ș Ș ț Ț l·l ¿ ¡ ; : < > × ÷
cos'è
```

Las pruebas de Windows usan la API de traducción de teclas y comprueban los archivos y el registro instalados. La selección en la interfaz de Windows y la escritura en aplicaciones de escritorio quedan fuera de esa prueba.

Los resultados remotos se consultan en [GitHub Actions](https://github.com/Emilianowv/RomanceScript/actions). El [informe de idiomas](LENGUAS.md) se regenera sin red mediante `python3 scripts/language_audit.py --write`.
