# RomanceScript para Windows

Ejecuta el instalador en un equipo Intel o AMD de 64 bits y confirma la solicitud de administrador. El ejecutable está sin firma digital. [Descargar para Windows x64](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/RomanceScript-8.1.1-Windows-x64.exe).

En **Configuración → Hora e idioma → Idioma y región → Opciones de idioma**, abre **Agregar un teclado** y elige **RomanceScript**. Si no aparece, busca en las opciones de **Español (España)**. Cambia de teclado con **Windows+Espacio**. [Ayuda de Microsoft](https://support.microsoft.com/en-us/windows/hardware/input-devices/manage-the-language-and-keyboard-input-layout-settings-in-windows).

Para desinstalar, cambia a otro teclado, quita RomanceScript de tus opciones de teclado y desinstálalo desde **Aplicaciones instaladas**.

La instalación, reinstalación, traducción de teclas con Win32 y desinstalación se prueban en Windows Server 2022 x64. El código fuente del teclado es [RomanceScript.klc](RomanceScript.klc).

Para compilar en Windows, instala 7-Zip e Inno Setup 6.3 o posterior y ejecuta `powershell -File windows/build-installer.ps1`. El script descarga MSKLC de Microsoft, verifica su SHA256 y compila las DLL x64 y WOW64. La descarga para el usuario contiene las DLL y el instalador, sin las herramientas de compilación.
