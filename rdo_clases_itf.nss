#include "prc_class_const"

const string Classes_DATABASE = "classes";
const string Classes_DB_RANGER_COMBAT_STYLE = "RANGER_COMBAT_STYLE";
const int Ranger_COMBAT_STYLE_BOW           = 1;
const int Ranger_COMBAT_STYLE_TWO_WEAPON    = 2;
const string Ranger_CombatStyle_EFFECT_CREATOR = "CombatStyle_CREATOR";


// Devuelve TRUE si la clase es una clase base (no de prestigio)
int RDO_getIsBaseClass( int classType );
int RDO_getIsBaseClass( int classType )
{
    return ( ( classType <= 10 && classType >= 0 ) ||
             classType == CLASS_TYPE_ARCHER ||
             classType == CLASS_TYPE_SWASHBUCKLER ||
             classType == CLASS_TYPE_ANTI_PALADIN
           );
}
