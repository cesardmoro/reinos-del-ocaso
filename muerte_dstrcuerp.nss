///////////////////////////////////////////////////////////////////////////////
// Script by Zero
// 06/04/07 - Corregido por Dragoncin
// 04/08/07 - Rehecho de cero por Inquisidor
///////////////////////////////////////////////////////////////////////////////
#include "Muerte_inc"


void main() {
    object pc = GetPCSpeaker();
    object cadaverItem = Muerte_getCadaverItem( pc );
    if( GetIsObjectValid(cadaverItem) ) {
        object cargadorCuerpo = GetItemPossessor(cadaverItem);
        if( GetIsPC(cargadorCuerpo) )
            SendMessageToPC( pc, "Tu cuerpo esta siendo cargado por "+GetName(cargadorCuerpo)+". Debes esperar a ser rescatado.");
        else if( GetLocalInt( cargadorCuerpo, "merc" ) && GetIsPC(GetMaster(cargadorCuerpo)) )
            SendMessageToPC( pc, "Tu cuerpo esta siendo cargado por "+GetName(cargadorCuerpo)+", un asociado de "+GetName(GetMaster(cargadorCuerpo))+". Debes esperar a ser rescatado." );
        else
            AssignCommand( pc, Muerte_resucitar() );
    } else
        AssignCommand( pc, Muerte_resucitar() );
}
