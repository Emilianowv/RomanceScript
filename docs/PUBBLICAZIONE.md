# Publicación

Repositorio: [Emilianowv/RomanceScript](https://github.com/Emilianowv/RomanceScript).

Los commits del proyecto utilizan la identidad pública de GitHub. No deben incluirse correos personales, credenciales, archivos de configuración de usuarios ni respaldos. `scripts/audit.py` comprueba los archivos distribuidos.

```bash
make check
make build
python3 scripts/test_deb.py
```

El flujo de publicación adjunta el paquete Debian y el instalador Windows x64. GitHub añade automáticamente sus enlaces a los archivos del código fuente.

- Linux genera `dist/romancescript_8.1.1_all.deb` con `make build`.
- Windows genera `dist/RomanceScript-8.1.1-Windows-x64.exe` con `windows/build-installer.ps1`.

El workflow de verificación construye y prueba el paquete en un contenedor Debian 13. El workflow de etiquetas crea una **versión pública** después de comprobar que la etiqueta coincide con VERSION:

```bash
git tag v8.1.1
git push origin v8.1.1
```

Revisa los resultados, los archivos y las sumas antes de publicar una versión. Un resultado local no implica que el workflow remoto haya pasado. El instalador Windows se publica si pasan las pruebas de compilación, instalación, teclas y retirada en el runner Windows x64.
