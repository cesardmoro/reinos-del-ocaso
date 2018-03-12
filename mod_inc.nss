#include "Experience_inc"
#include "Item_inc"

///////////// constantes y operaciones usadas por mas de un mod_* //////////////


//////////////////////////// Constants /////////////////////////////////////////

const string Mod_IS_PC_INITIALIZED_REF_PREFIX = "ModIPI#";
const string Mod_GATE_WAYPOINT_TAG = "ModGateAreaWP"; // tag of a waypoint that lays in the gate area of the module.

//////////////////////////// PC variable names /////////////////////////////////

const string Mod_WAS_FIRST_PC_INITIALIZATION_AFTER_MODULE_RESET_DONE = "ModWFIAMRD"; // [boolean] Se asume que se pone en FALSE cuando se resetea el módulo. Es puesto en TRUE al comienzo de "Mod_onEnter"
const string Mod_ON_PC_ENTERS_WORLD_LATCH = "ModOPCEWL"; // [boolean] puesto en TRUE por Mod_onEnter y en FALSE por Mod_onWorldEnter
const string Mod_isResting_VN = "ModIR"; // [boolean] esta en TRUE mientras el PJ esta durmiendo.

//////////////////////////// Operations ////////////////////////////////////////


// Da TRUE cuando 'pc' ya disparó el evento onClientEnter (cuyo hanler es "Mod_onEnter").
// Este booleano se pone en TRUE al comienzo del handler del evento onClientEnter, y en FALSE al comienzo del handler del evento onClientLeave
// Es usado en los handlers de los eventos onAcquire y onEquip para distinguir entre lo que se adquiere/equipa del vault de personajes al entrar al módulo, de lo que se adquiere/equipa durante el juego.
int Mod_isPcInitialized( object pc );
int Mod_isPcInitialized( object pc ) {
    return GetLocalInt( GetModule(), Mod_IS_PC_INITIALIZED_REF_PREFIX + GetName(pc) );
}


// Debe ser llamada desde el onEnter event handler de todas las áreas que formen parte del mundo, cuando entra un personaje controlado por un jugador o DM.
// IMPORTANTE: Debe ser la primer operacion ejecutada por el handler cuando quien entra es un PC (personaje controlado por un jugador o DM).
// No debe ser llamado desde areas de servicio ni del área de inicio.
// Se asume que GetIsPC(pc) da TRUE
void Mod_onPcEntersArea( object pc );
void Mod_onPcEntersArea( object pc ) {
    if( GetLocalInt( pc, Mod_ON_PC_ENTERS_WORLD_LATCH ) && Experience_pasaControlYAjuste( pc ) ) {
        SetLocalInt( pc, Mod_ON_PC_ENTERS_WORLD_LATCH, FALSE );
        ExecuteScript( "Mod_onWorldEnter", pc );
    }
}


// funcion privada usada por el main de Mod_onAcquire, y Mod_onEquip
// Se asume que 'item' no es adepto al IPS
int Mod_esItemHabilitadoEquipar( object item );
int Mod_esItemHabilitadoEquipar( object item ) {
    if(
        !Item_tieneItemAlgunaPropiedadPermanente( item )
        || GetTag( item ) == "base_prc_skin"
        || GetTag( item ) == "VardaMeDeja"
    ) {
        return TRUE;
    }
    else {
        int itemType = GetBaseItemType( item );
        return
            itemType == BASE_ITEM_SPELLSCROLL
            || itemType == BASE_ITEM_MAGICROD
            || itemType == BASE_ITEM_MAGICSTAFF
            || itemType == BASE_ITEM_MAGICWAND
            || itemType == BASE_ITEM_ENCHANTED_WAND
            || itemType == BASE_ITEM_ENCHANTED_POTION
            || itemType == BASE_ITEM_ENCHANTED_SCROLL
        ;
    }
}
