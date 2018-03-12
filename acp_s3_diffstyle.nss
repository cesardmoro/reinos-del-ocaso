/////////////////////////////////////////////////
// ACP_S3_diffstyle
// Author: Ariel Kaiser
// Creation Date: 13 May 2005
////////////////////////////////////////////////
/*
  In combination with the right feat.2da and spells.2da entries, this script
  allows a player (or possessed NPC with the right feat, I guess) to change
  their fighting style and trade it for different animations. Part of the ACP pack.
*/
#include "Phenos_inc"

object oPC = OBJECT_SELF; //this script is always called by one person.
string sLock = "acp_fightingstyle_lock";

/* This creates a LocalInt - a "lock" - ..we check further down if it exists...
 * if it does, we don't allow phenotype changing. To prevent lag spam. */
void LockThisFeat()
{
    SetLocalInt(oPC, sLock, TRUE);
    DelayCommand(90.0, DeleteLocalInt(oPC, sLock)); //Lock persists 90 seconds at a time
}

void ResetFightingStyle() //Resets the character phenotype to 0
{
    //If we are at phenotype 5,6,7 or 8 we want to reset it to neutral.
    if (GetPhenoType(oPC) == 5 || GetPhenoType(oPC) == 6 ||
        GetPhenoType(oPC) == 7 || GetPhenoType(oPC) == 8)
    {
        SetNaturalPhenoType(0, oPC);
        LockThisFeat(); // Lock use!
    }

    //else if we are at phenotype 0 or 2, we do nothing. Tell the player that.
    else if (GetPhenoType(oPC) == 0 || GetPhenoType(oPC) == 2)
        SendMessageToPC(oPC, "Tu estilo de lucha ya es neutral.");

    //else, warn that the player doesn't have a phenotype which can be reset right now
    else
        SendMessageToPC(oPC, "Tu fenotipo no es estandar y no puede resetearse de esta manera.");

}

void SetCustomFightingStyle(int iStyle) //Sets character phenotype to 5,6,7 or 8
{
    //Maybe we're already using this fighting style? Just warn the player.
    if (GetPhenoType(oPC) == iStyle)
        SendMessageToPC(oPC, "Ya estás usando este estilo de lucha!");

    //If we are at phenotype 0 or one of the styles themselves, we go ahead
    //and set the creature's phenotype accordingly! (safe thanks to previous 'if')
    else if (GetPhenoType(oPC) == 0 || GetPhenoType(oPC) == 5 || GetPhenoType(oPC) == 6 ||
             GetPhenoType(oPC) == 7 || GetPhenoType(oPC) == 8)
    {
        SetNaturalPhenoType(iStyle, oPC);
        LockThisFeat(); // Lock use!
    }

    //At phenotype 2? Tell the player they're too fat!
    else if (GetPhenoType(oPC) == 2)
        SendMessageToPC(oPC, "Eres demasiado gordo para usar otro estilo de lucha!");

    //...we didn't fulfil the above conditions? Warn the player.
    else
        SendMessageToPC(oPC, "Tu fenotipo no es estandar / Incapaz de cambiar de estilo");

}

void main()
{
    if (GetLocalInt(oPC, sLock)) //Feat is still locked? Bad user!
    {
        SendMessageToPC(oPC, "Debes esperar al menos 90 segundos antes de usar esta dote de nuevo.");
        return;
    }

    if (GetSpellId() == 2282) // Normal/Reset
        ResetFightingStyle();

    else if (GetSpellId() == 2278) // Kensai
        SetCustomFightingStyle(5);
    else if (GetSpellId() == 2279) // Assassin
        SetCustomFightingStyle(6);
    else if (GetSpellId() == 2280) // Heavy
        SetCustomFightingStyle(7);
    else if (GetSpellId() == 2281) // Fencing
        SetCustomFightingStyle(8);
}
