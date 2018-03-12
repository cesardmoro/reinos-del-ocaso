////////////////////////
// OnPlayerHeartbeat
//
// Este script es llamado desde el evento OnClientEnter
// No se ejecuta directamente en OnClientEnter para ser mas facil de debugear
////////////////////////

#include "heartbeat_inc"

void main()
{
    heartbeat_ejecutar();
}
