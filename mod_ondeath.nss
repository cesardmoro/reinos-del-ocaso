#include "matasumon"
#include "sacahench"
#include "nigromancia_inc"
#include "Horses_inc"
#include "arena"

void main()
{
    object pjMatado = GetLastPlayerDied();
    object oPC = pjMatado;
    int nHD = GetHitDice(oPC);
    int nNewXP = ((nHD+1 * (nHD)) / 2 * 1000);
    int nCurrXP = GetXP(oPC);
    int nOverflow = nCurrXP-nNewXP;
    if (nOverflow > 100)
        nOverflow = 100;

    // Borra la cantidad de HDs que el nigromante ha controlado
    DeleteLocalInt(pjMatado, HD_CONTROLADOS_POR_ANIMATEDEAD);

    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC));

    Horses_onPlayerDeath( pjMatado );

    object oSummon = GetFirstFactionMember(oPC, FALSE);
    while(GetIsObjectValid(oSummon))
    {
        if (GetAssociateType(oSummon)==ASSOCIATE_TYPE_HENCHMAN) {
            RemoveHenchman(oPC, oSummon);
            SetLocalInt(oSummon, "merc", 0);
        } else {
            matasumon(oSummon, oPC, TRUE);
        }
        oSummon = GetNextFactionMember(oPC, FALSE);
    }
           if(GetLocalInt(oPC, "ArenaMode") == 1)
           {
           accionesarena(oPC);
           return;
           }

    ExecuteScript("newdeath", pjMatado);

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

