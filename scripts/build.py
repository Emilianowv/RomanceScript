#!/usr/bin/env python3
"""Build the Debian package."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

from audit import ROOT, audit, source_files


def main():
    audit()
    subprocess.run(['python3', '-m', 'unittest', 'discover', '-s', 'tests', '-v'], cwd=ROOT, check=True)
    subprocess.run(['python3', 'scripts/check_windows_klc.py'], cwd=ROOT, check=True)
    subprocess.run([str(ROOT/'romancescript'), 'test'], cwd=ROOT, check=True)
    version = (ROOT/'VERSION').read_text().strip()
    epoch = int(os.environ.get('SOURCE_DATE_EPOCH', '0'))
    out = ROOT/'dist'
    out.mkdir(exist_ok=True)
    files = list(source_files())
    with tempfile.TemporaryDirectory(prefix='romancescript-package-') as t:
        stage = Path(t)/'package'
        payload = stage/'usr/share/romancescript'
        for p in files:
            target = payload/p.relative_to(ROOT)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(p, target)
            target.chmod(0o755 if p.stat().st_mode & 0o111 else 0o644)
        binpath = stage/'usr/bin/romancescript'
        binpath.parent.mkdir(parents=True, exist_ok=True)
        binpath.write_text('#!/bin/sh\nexec python3 /usr/share/romancescript/romancescript "$@"\n')
        binpath.chmod(0o755)
        meta = stage/'DEBIAN'
        meta.mkdir()
        size = sum(p.stat().st_size for p in stage.rglob('*') if p.is_file())//1024+1
        (meta/'control').write_text(f'''Package: romancescript
Version: {version}
Section: x11
Priority: optional
Architecture: all
Maintainer: Emilianowv <309815527+Emilianowv@users.noreply.github.com>
Depends: python3 (>= 3.11), xkb-data, libxkbcommon0, libxkbcommon-tools
Recommends: x11-xkb-utils
Replaces: occidentale (<< 8.0.0)
Homepage: https://github.com/Emilianowv/RomanceScript
Installed-Size: {size}
Description: RomanceScript keyboard layout for Romance languages (rom)
 XKB layout for Spanish, Portuguese, French, Italian, Romanian and Catalan.
 Includes Compose rules, KDE configuration, backups and removal tools.
''')
        for name in ('postinst', 'prerm'):
            dest = meta/name
            shutil.copyfile(ROOT/'packaging'/name, dest)
            dest.chmod(0o755)
        doc = stage/'usr/share/doc/romancescript'
        doc.mkdir(parents=True)
        shutil.copyfile(ROOT/'COPYRIGHT', doc/'copyright')
        env = dict(os.environ, SOURCE_DATE_EPOCH=str(epoch))
        subprocess.run(['dpkg-deb', '--root-owner-group', '--threads-max=1', '-Zxz', '--build',
                        str(stage), str(out/f'romancescript_{version}_all.deb')], check=True, env=env)
    print('Pacchetti verificati e creati in dist/.')


if __name__ == '__main__':
    main()
