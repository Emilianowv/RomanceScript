# RomanceScript para Windows

Ejecuta el instalador en un computador Intel o AMD de 64 bits y confirma el permiso de administrador. El ejecutable está sin firma digital. [Télécharger Windows x64](https://github.com/Emilianowv/RomanceScript/releases/download/v8.1.1/RomanceScript-8.1.1-Windows-x64.exe).

## Ajouter y seleccionar el teclado

Abre **Configuración → Hora e idioma → Idioma y región → Opciones de idioma → Agregar un teclado** y elige **RomanceScript**. Si no aparece, mira en **Español (España)**. Usa **Windows+espacio** para cambiar de teclado. [Guía de Microsoft](https://support.microsoft.com/en-us/windows/hardware/input-devices/manage-the-language-and-keyboard-input-layout-settings-in-windows).

Windows presenta el **idioma de entrada** junto al nombre del **teclado**. RomanceScript es una distribución propia. Su instalador la registra bajo Español (España), con el código `0C0A`. Para verla bajo otro idioma habría que asociarla a otro idioma de entrada. La etiqueta del idioma pertenece a Windows. [Documentación Win32](https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-getkeyboardlayout).

## Disinstallazione

Selecciona otro teclado, retira RomanceScript de las opciones de teclado y desinstálalo desde **Aplicaciones instaladas**.

## Verifica e compilação

Se prueban la instalación, reinstalación, traducción de teclas con Win32 y desinstalación en Windows Server 2022 x64. El diseño está en [RomanceScript.klc](RomanceScript.klc).

Para compilar, instala 7-Zip e Inno Setup 6.3 o posterior y ejecuta `powershell -File windows/build-installer.ps1`. El script descarga MSKLC de Microsoft, verifica su SHA256 y compila las DLL x64 y WOW64.
