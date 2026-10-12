#!/usr/bin/env bash
# Prototipo NO VALIDADO en el NUC: montaje no bloqueante cuando Raspberry está apagada.
set -u
HOST="pi@192.168.1.20"
MOUNT="${HOME}/RaspberryPi/raiz"
KEY="${HOME}/.ssh/id_rsa"
mkdir -p "$MOUNT"

reachable() {
  timeout 5 ssh -i "$KEY" -o BatchMode=yes -o ConnectTimeout=3 \
    -o ConnectionAttempts=1 -o StrictHostKeyChecking=yes \
    "$HOST" true >/dev/null 2>&1
}

# El montaje puede persistir tras un apagado; evita operaciones largas por FUSE obsoleto.
if mountpoint -q "$MOUNT"; then
  if reachable; then exit 0; fi
  fusermount3 -u "$MOUNT" >/dev/null 2>&1 || \
    fusermount3 -uz "$MOUNT" >/dev/null 2>&1 || true
fi

# Offline es esperado. No producir error para systemd.
reachable || exit 0

sshfs "${HOST}:/" "$MOUNT" \
  -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user \
  -o BatchMode=yes,ConnectTimeout=3,ConnectionAttempts=1 \
  -o StrictHostKeyChecking=yes,IdentityFile="$KEY" >/dev/null 2>&1 || exit 0
