# RomanceScript

Distribución de teclado QWERTY para escribir en **español, portugués, francés, italiano, rumano y catalán**. Conserva **ß/ẞ** como compatibilidad adicional con el alemán.

## Descargas

- **[Linux (.deb)](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/romancescript_8.1.1_all.deb)**
- **[Windows x64 (.exe)](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/RomanceScript-8.1.1-Windows-x64.exe)**.

La abreviatura y el identificador XKB son **rom**. Al actualizar desde wst, instala el paquete y ejecuta `romancescript user-install` y `romancescript kde-select` desde cada cuenta KDE. Después cierra sesión y vuelve a entrar.

## Distribución

La **ñ/Ñ** está en su posición española. **Mayús+coma** escribe **;** y **Mayús+punto** escribe **:**.

| Tecla o combinación | Resultado |
|---|---|
| Debajo de Escape, sin/con Mayús | ¿ / ¡ |
| Grave, después c/C | ç / Ç |
| Grave, después s/S | ß / ẞ |
| Mayús+grave, después a/o | ã / õ |
| Mayús+6, después vocal | â ê î ô û |
| Tecla junto a la barra inversa, después a/A | ă / Ă |
| Mayús+esa tecla, después s/S o t/T | ș / Ș / ț / Ț |
| AltGr+O / AltGr+A | œ / æ; con Mayús, Œ / Æ |
| Grave, después Espacio | `'`, como en `cos'è` |
| AltGr+coma / AltGr+punto | `<` / `>` |
| Mayús+AltGr+coma / Mayús+AltGr+punto | • / · |
| AltGr+= / Mayús+AltGr+= | × / ÷ |

El agudo y la diéresis se conservan a la derecha de Ñ. Para formar una letra acentuada, pulsa el acento, suéltalo y pulsa la letra. La [guía de teclas](docs/TECLAS.md) describe las posiciones y las mayúsculas.

## Sistemas

- **Linux:** instalación XKB, reglas Compose para los acentos y selección desde KDE. Se prueba en Debian 13 con KDE Plasma 6, KWin Wayland y un servidor X11 independiente. Incluye copias de seguridad, actualización y desinstalación.
- **Windows:** instalador precompilado para equipos Intel y AMD de 64 bits. Después de instalar, añade RomanceScript desde las opciones de teclado de Windows.

[Instalar en Linux](docs/INSTALACION.md) · [Guía de Windows](windows/README.md)

## Alcance y comprobaciones

Las pruebas del motor Linux cubren las letras principales de los seis idiomas indicados, incluidas sus mayúsculas. Esto no implica cobertura de todos los signos tipográficos ni pruebas de escritura en todas las aplicaciones. Los caracteres que faltan se indican en el [informe de idiomas](docs/LENGUAS.md).

[Pruebas y límites](docs/VERIFICA.md) · [Diseño](docs/DISENO.md) · [Cambios](docs/CHANGELOG.md) · [Problemas y propuestas](https://github.com/Emilianowv/RomanceScript/issues)

## Desarrollo

```bash
make check
make build
python3 scripts/test_deb.py
```

En Linux, el build genera el paquete Debian. El instalador Windows se genera en Windows mediante el flujo de GitHub Actions. Los detalles de instalación están en [Integración Linux](docs/LINUX.md); los de distribución, en [Publicación](docs/PUBBLICAZIONE.md). Los derechos y la procedencia se describen en [COPYRIGHT](COPYRIGHT) y [Procedencia](docs/PROVENIENZA.md).
