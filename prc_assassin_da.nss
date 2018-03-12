//::///////////////////////////////////////////////
//:: Name        Assassin Death Attack
//:: FileName    prc_assassin_da
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Death Attack for the assassin

#include "prc_inc_function"
#include "NW_I0_GENERIC"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Gotta be a living critter
    int nType = MyPRCGetRacialType(oTarget);
    if ((nType == RACIAL_TYPE_CONSTRUCT) ||
        (nType == RACIAL_TYPE_UNDEAD) ||
        (nType == RACIAL_TYPE_ELEMENTAL))
    {
        FloatingTextStringOnCreature("El blanco debe estar vivo",OBJECT_SELF);
        return;
    }
    if(GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
    {
    SendMessageToPC(oPC,"Al parecer no posee ninguna debilidad");
    return;
    }
    if(GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY")> 0.0)
    {
    SendMessageToPC(oPC,"ya estas estudiando a alguien");
    return;
    }

    // Assasain must not be seen
/*    if (!( (GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED)  ||
           (GetHasEffect(EFFECT_TYPE_INVISIBILITY,oPC)) ||
           (GetHasEffect(EFFECT_TYPE_SANCTUARY,oPC)) ) )
    {
        FloatingTextStringOnCreature("Your target is aware of you, you can not perform a death attack",OBJECT_SELF);
        return;
    }*/
    // If they are in the middle of a DA or have to wait till times up they are denied
    float fApplyDATime = GetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY");
    if (fApplyDATime > 0.0)
    {
        SendMessageToPC(oPC,"Estas estudiando a tu victima"+IntToString(FloatToInt(fApplyDATime))+ " segundos para realizar el ataque");
        return;
    }

    // Set a variable that tells us we are in the middle of a DA
    // Must study the target for three rounds
    fApplyDATime = RoundsToSeconds(3);
    SetLocalFloat(oPC,"PRC_ASSN_DEATHATTACK_APPLY",fApplyDATime );
    // save the race off so we know what racial type to slay
    SetLocalInt(oPC,"PRC_ASSN_TARGET_RACE",nType);

    // Kick off a function to count down till they get the DA

    SendMessageToPC(oPC,"Comienzas a estudiar a tu victima");
    DelayCommand(6.0,ExecuteScript("prc_assn_da_hb",oPC));

}
