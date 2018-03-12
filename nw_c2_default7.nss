//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "SPC_Cre_onDeath"
#include "RS_inc"
#include "x2_inc_compon"
#include "x0_i0_spawncond"
//#include "prc_inc_clsfunc"  // REMOVIDO porque causa error de compilacion

void main()
{
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    object oKiller = GetLastKiller();

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // Insertado por Inquisidor - begin
    RS_creatureOnDeath( GetLastKiller() );
    SisPremioCombate_onDeath( GetLastKiller() );
    // Insertado por Inquisidor - end

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
    craft_drop_items(oKiller);

/*  REMOVIDO por Inquisidor para evitar error de compilacion en el include "prc_inc_clsfunc" que tambien comente
    if(GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE)>4)
    {
        LolthMeat(oKiller);
    }
*/

}
