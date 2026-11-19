# RomanceScript

RomanceScript es un **teclado QWERTY** para escribir en español, português, français, italiano, română i català. La même tastiera reúne acentos, ligaduras y signos de las seis lenguas. También incluye ß y ẞ para el alemán.

## Descargar · télécharger · scaricare

- [Linux (.deb)](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/romancescript_8.1.1_all.deb)
- [Windows x64 (.exe)](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/RomanceScript-8.1.1-Windows-x64.exe)

## Seis lenguas, un teclado

| Lingua | Exemple |
|---|---|
| Español | ¿Mañana habrá música en la plaza? ¡Sí! |
| Português | A manhã começou com pão, café e uma canção. |
| Français | À Noël, le cœur de Lucie était plein de joie. |
| Italiano | Cos'è? È un caffè, ma non è per me. |
| Română | Ștefan își cumpără pâine și înghețată. |
| Català | La col·laboració va començar a la plaça. |

## Teclas · touches · tasti

Con una tecla de acento, pulsa el acento, suelta y escribe la letra. **AltGr** es el Alt de la derecha. **Shift** es la tecla de mayúsculas.

| Combinaison | Resultato |
|---|---|
| Tecla a la derecha de L | ñ / Ñ |
| Tecla debajo de Escape | ¿ / ¡ |
| Grave, después espacio | `'`, como en `cos'è` |
| Grave, después c/C o s/S | ç / Ç o ß / ẞ |
| Shift+grave, después a/o | ã / õ |
| Shift+6, después una vocal | â ê î ô û |
| Tecla del breve, después a/A | ă / Ă |
| Shift+tecla del breve, después s/S o t/T | ș / Ș o ț / Ț |
| AltGr+O / AltGr+A | œ / æ. Con Shift, Œ / Æ |
| AltGr+coma / AltGr+punto | `<` / `>` |
| Shift+AltGr+coma / Shift+AltGr+punto | • / · |
| AltGr+= / Shift+AltGr+= | × / ÷ |

## Installazione y verifica

- **Linux.** Paquete Debian, XKB y Compose. Probado en Debian 13 con KDE Plasma 6, Wayland y X11 mediante Xwayland. El identificador XKB es `rom`. [Guía Linux](docs/INSTALACION.md).
- **Windows.** Instalador para Intel y AMD de 64 bits. Añade RomanceScript en las opciones de teclado y selecciónalo con **Windows+espacio**. [Guía Windows](windows/README.md).

La verifica de Linux cubre las letras principales de las seis lenguas, con mayúsculas. Los signos auxiliares y la puntuación se cuentan por separado. [Cobertura](docs/LENGUAS.md) · [Pruebas](docs/VERIFICA.md).

## Développement

```sh
make check
make build
python3 scripts/test_deb.py
```

[Mapa de teclas](docs/TECLAS.md) · [Disegno](docs/DISENO.md) · [Notas de versión](docs/CHANGELOG.md) · [Publication](docs/PUBBLICAZIONE.md) · [Procedencia y derechos](docs/PROVENIENZA.md) · [Incidencias](https://github.com/Emilianowv/RomanceScript/issues)
