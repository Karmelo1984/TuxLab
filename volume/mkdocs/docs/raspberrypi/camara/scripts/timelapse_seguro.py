#!/usr/bin/env python3
"""Prototipo no validado. Captura periódica al HDD con vigilancia de montaje.
Uso: python3 timelapse_seguro.py 30  # prueba 30 segundos.
"""
from datetime import datetime
from pathlib import Path
import os
import signal
import subprocess
import sys
import time

MOUNT = Path('/mnt/capturas')
UUID_ESPERADO = '98967607-e566-4f45-b381-4960b27610e4'
DESTINO = MOUNT / 'camara' / 'timelapses'
INTERVALO_MS = 5000


def disco_correcto():
    if not os.path.ismount(MOUNT):
        return False
    result = subprocess.run(
        ['findmnt', '-n', '-o', 'UUID', '--mountpoint', str(MOUNT)],
        capture_output=True, text=True, check=False, timeout=3
    )
    return result.returncode == 0 and result.stdout.strip() == UUID_ESPERADO


def main():
    duracion = int(sys.argv[1]) if len(sys.argv) > 1 else 7200
    if duracion < 10:
        raise SystemExit('Usar una duración de al menos 10 segundos')
    if not disco_correcto():
        raise SystemExit('HDD no montado o UUID incorrecto; captura cancelada')

    carpeta = DESTINO / datetime.now().strftime('%Y%m%d_%H%M%S')
    carpeta.mkdir(parents=True, exist_ok=False)
    comando = [
        'rpicam-still', '--nopreview', '--timeout', str(duracion * 1000),
        '--timelapse', str(INTERVALO_MS), '--width', '4608', '--height', '2592',
        '--quality', '90', '--autofocus-mode', 'continuous',
        '--output', str(carpeta / 'foto_%05d.jpg')
    ]
    print(f'Destino: {carpeta}', flush=True)
    proceso = subprocess.Popen(comando)
    motivo = 'tiempo agotado'
    try:
        while proceso.poll() is None:
            if not disco_correcto():
                motivo = 'pérdida de montaje del HDD: se detiene la cámara'
                proceso.terminate()
                break
            time.sleep(1)
        try:
            rc = proceso.wait(timeout=15)
        except subprocess.TimeoutExpired:
            proceso.kill()
            rc = proceso.wait()
    except KeyboardInterrupt:
        motivo = 'interrumpido por usuario'
        proceso.terminate()
        try:
            rc = proceso.wait(timeout=15)
        except subprocess.TimeoutExpired:
            proceso.kill()
            rc = proceso.wait()
    print(f'Fin: {motivo}; retorno cámara: {rc}', flush=True)
    if not disco_correcto():
        return 2
    print(f'Fotografías: {len(list(carpeta.glob("foto_*.jpg")))}', flush=True)
    return 0 if rc == 0 or (rc == -signal.SIGTERM and motivo == 'interrumpido por usuario') else 1


if __name__ == '__main__':
    raise SystemExit(main())
