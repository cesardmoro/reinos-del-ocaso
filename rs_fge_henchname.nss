/************ on Creature generated handler que renombra a la criatura *********
pakage: RandomSpawn - funciones genaradoras encuentro - onCreatureGeneratedHL renombrador de criaturas
author: Inquisidor
Descripcion: como todo script que haya sido subscripto a la lista de handlers del
evento onCreatureGenerated disparado por el RandomSpawn, este script es ejecutado
para cada criatura generada por el RS.
Subscripto por 'FGE_Humanoid_HOrcOutLaw()'
*******************************************************************************/
#include "vnnpc_inc"

void main() {
    SetName( OBJECT_SELF, VNNPC_generateName( OBJECT_SELF ) + " 'Bandido'" );
//    SendMessageToPC( GetFirstPC(), "nombre cambiado" );
}
