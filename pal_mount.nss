/******************************************************************
 Special Mount (Sp): Upon reaching 5th level, a paladin gains the service of an
 unusually intelligent, strong, and loyal steed to serve her in her crusade
 against evil (see below). This mount is usually a heavy warhorse (for a Medium
 paladin) or a warpony (for a Small paladin).

 Once per day, as a full-round action, a paladin may magically call her mount
 from the celestial realms in which it resides. This ability is the equivalent
 of a spell of a level equal to one-third the paladin’s class level. The mount
 immediately appears adjacent to the paladin and remains for 2 hours per paladin
 level; it may be dismissed at any time as a free action. The mount is the same
 creature each time it is summoned, though the paladin may release a particular
 mount from service.

 Each time the mount is called, it appears in full health, regardless of any damage
 it may have taken previously. The mount also appears wearing or carrying any gear
 it had when it was last dismissed. Calling a mount is a conjuration (calling) effect.
******************************************************************/

#include "spinc_common"
#include "Horses_inc"
#include "x0_i0_position"

const string caballoPaladin_RN = "caballoPaladin";

void main()
{
    object oCaster = OBJECT_SELF;
    SendMessageToPC( oCaster, "La montura del paladin se encuentra desactivada hasta que Bioware saque el parche v1.69. Este mensaje fue auspiciado por shampoo Todos Emo. Todos Emo, porque los paladines necesitan una cabellera brillante." );
    return;

    location targetLocation = GetFlankingRightLocation( oCaster );
    effect eVis = EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_1 );

    // ---> Destruir algun caballo existente
    if (GetIsMounted( oCaster ))
    {
        object oHorse = Horses_GetMountedHorse( oCaster );
        if (GetTag( oHorse ) == caballoPaladin_RN)
        {
            Horses_disMount( oCaster, FALSE );
            DestroyObject( oHorse );
        }
    }
    int i = 1;
    object criaturaIterada = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oCaster, i );
    while (GetIsObjectValid( criaturaIterada ))
    {
        if (GetTag( criaturaIterada ) == caballoPaladin_RN && GetMaster( criaturaIterada ) == oCaster)
        {
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(criaturaIterada) );
            DestroyObject( criaturaIterada );
        }
        i++;
        criaturaIterada = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oCaster, i );
    }
    // <---

    int nPaladin = GetLevelByClass( CLASS_TYPE_PALADIN, oCaster );
    nPaladin = (nPaladin > 20) ? 20 : nPaladin;

    string resRefCaballo = "palam" + IntToString( nPaladin );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, targetLocation );
    object oMount = CreateObject( OBJECT_TYPE_CREATURE, resRefCaballo, targetLocation, FALSE, caballoPaladin_RN );
    Horses_StartFollowing( oMount, oCaster );
}
