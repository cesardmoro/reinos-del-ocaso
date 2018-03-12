#include "muerte_inc"



void main()
{
    object matador = GetLastKiller();
    object pjMatado = GetLastPlayerDied();
    ExecDeathActions(matador, pjMatado);
}


/* Zero, te voy a ser sincero. Aun sigue andando mal y estando muy
desordenado el codigo. Tenes que dividir la funcionalidad en partes tales que
la interaccion entre ellas sea minima.
Para este caso hay que separar el sistema de PvP, el sistema de manejo de
cuerpos de PJs, y el sistema muerte de PJ propiamente dicho.

Como se empieza? Sin escribir ninguna implementacion, escribis las interfaces
de cada subsistema:

Sistema de PvP - penas:
void PVP_registrarMatanzaEntrePJs( object pjMatado, object pjMatador );
void PVP_registrarPeleaConGuardias( object pjRebelde );
float PVP_getDuracionPenitenciaEnCarcel( object pjPreso );

Sistema de cuerpos:
void CPJ_crearCuerpoPj( object pjMuerto, location ubicacionCuerpo );
void CPJ_destruirCuerposCargados( object criaturaCargadora );
void CPJ_soltarCuerposCargados( objcet criaturaCargadora, location ubicacionCuerpos );
object CPJ_getCuerpoPjSiExiste( string nombrePJ );

Sistema de muerte de PJ:
void MPJ_trasladarPjMuertoAlFugue( object pjMuerto );
void MPJ_revivirCuerpoPj( object cuerpoPj );
void MPJ_getCuerpoCercanoA( location ubicacion, int indiceCercania );

Seguramente, a medida que las implementes, descubriras que hacen falta mas
funciones, o que haya que modificarlas. Eso es normal.

*/

