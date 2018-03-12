//::///////////////////////////////////////////////
//:: Summon Creature Series
//:: NW_S0_Summon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Carries out the summoning of the appropriate
creature for the Summon Monster Series of spells
1 to 9
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

effect SetSummonEffect(int nSpellID);

#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
    /*
    Spellcast Hook Code
    Added 2003-06-23 by GeorgZ
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook
    int nSpellID = GetSpellId();
    int nFNF_Effect;
    int nRoll = d3();
    string sSummon;
    int nNumero;
    if(!((GetIsPC(OBJECT_SELF) == FALSE || GetIsObjectValid(GetMaster(OBJECT_SELF))) == FALSE || GetIsDM(OBJECT_SELF) == FALSE ))
    {
        return;
    }

    if(nSpellID == SPELL_SUMMON_CREATURE_I)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;

        sSummon = IntToString(GetCampaignInt("summons", "1", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "1", OBJECT_SELF);
        // SendMessageToPC(OBJECT_SELF, "1");
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_II)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = IntToString(GetCampaignInt("summons", "2", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "2", OBJECT_SELF);
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_III)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_1;
        sSummon = IntToString(GetCampaignInt("summons", "3", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "3", OBJECT_SELF);
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_IV)
    {
        sSummon = IntToString(GetCampaignInt("summons", "4", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "4", OBJECT_SELF);
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_V)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_2;
        sSummon = IntToString(GetCampaignInt("summons", "5", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "5", OBJECT_SELF);
    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_VI)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
        sSummon = IntToString(GetCampaignInt("summons", "6", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "6", OBJECT_SELF);

    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_VII)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
        sSummon = IntToString(GetCampaignInt("summons", "7", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "7", OBJECT_SELF);

    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_VIII)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
        sSummon = IntToString(GetCampaignInt("summons", "8", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "8", OBJECT_SELF);

    }
    else if(nSpellID == SPELL_SUMMON_CREATURE_IX)
    {
        nFNF_Effect = VFX_FNF_SUMMON_MONSTER_3;
        sSummon = IntToString(GetCampaignInt("summons", "9", OBJECT_SELF));
        nNumero = GetCampaignInt("summons2", "9", OBJECT_SELF);

    }

    if(StringToInt(sSummon) < 100)
    {
        sSummon = "0"+sSummon;
    }
    if(StringToInt(sSummon) < 10)
    {
        sSummon = "0"+sSummon;
    }
    if(nNumero == 2)
    {
        nNumero = d4(1)+1;
    }

    SendMessageToPC(OBJECT_SELF, IntToString(nNumero));

    string sSumon = "summon"+sSummon;
    //SendMessageToPC(OBJECT_SELF, sSumon);
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    if(GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF) > 0)
    {

        nFNF_Effect = 793;
        sSumon = "natural"+sSummon;

    }
    SendMessageToPC(OBJECT_SELF, sSumon);
    effect eVis = EffectVisualEffect(nFNF_Effect);
    //Declare major variables

    float nDuration = RoundsToSeconds(10+PRCGetCasterLevel(OBJECT_SELF));
    if(GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF) == TRUE)
    {
        nDuration = nDuration + 60.0;
    }
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF) == TRUE)
    {
        nDuration = nDuration + 60.0;
    }
    SendMessageToPC(OBJECT_SELF, FloatToString(nDuration) );
    effect eSummon = eVis;


    //Make metamagic check for extend
    int nMetaMagic = GetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetSpellTargetLocation());
    //SendMessageToPC(OBJECT_SELF, "Test");

    if(nNumero > 0)
    {
        SendMessageToPC(OBJECT_SELF, "summon1");
        object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sSumon, GetSpellTargetLocation(), FALSE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetLocation(oSummon)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon));
        if(GetIsObjectValid(GetMaster(OBJECT_SELF)) == TRUE)
        {
            AssignCommand(GetMaster(OBJECT_SELF), DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon)));
        }
        //DelayCommand( nDuration, AssignCommand(oSummon, ActionJumpToLocation(GetLocation(GetObjectByTag("outsider")))));
        AssignCommand(oSummon, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oSummon, nDuration);
    }

    if(nNumero > 1)
    {
        //SendMessageToPC(OBJECT_SELF, "2");
        //SendMessageToPC(OBJECT_SELF, "summon2");
        object oSummon2 = CreateObject(OBJECT_TYPE_CREATURE, sSumon, GetSpellTargetLocation(), FALSE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetLocation(oSummon2)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon2));
        if(GetIsObjectValid(GetMaster(OBJECT_SELF)) == TRUE)
        {
            AssignCommand(GetMaster(OBJECT_SELF), DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon2)));
        }
        //DelayCommand( nDuration, AssignCommand(oSummon2, ActionJumpToLocation(GetLocation(GetObjectByTag("outsider")))));
        AssignCommand(oSummon2, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oSummon2, nDuration);
    }
    if(nNumero > 2)
    {
        //SendMessageToPC(OBJECT_SELF, "summon3");
        object oSummon3 = CreateObject(OBJECT_TYPE_CREATURE, sSumon, GetSpellTargetLocation(), FALSE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetLocation(oSummon3)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon3));
        //DelayCommand( nDuration, AssignCommand(oSummon3, ActionJumpToLocation(GetLocation(GetObjectByTag("outsider")))));
        if(GetIsObjectValid(GetMaster(OBJECT_SELF)) == TRUE)
        {
            AssignCommand(GetMaster(OBJECT_SELF), DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon3)));
        }
        AssignCommand(oSummon3, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oSummon3, nDuration);
    }
    if(nNumero > 3)
    {
        object oSummon4 = CreateObject(OBJECT_TYPE_CREATURE, sSumon, GetSpellTargetLocation(), FALSE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetLocation(oSummon4)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon4));
        if(GetIsObjectValid(GetMaster(OBJECT_SELF)) == TRUE)
        {
            AssignCommand(GetMaster(OBJECT_SELF), DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon4)));
        }
        //DelayCommand( nDuration, AssignCommand(oSummon4, ActionJumpToLocation(GetLocation(GetObjectByTag("outsider")))));
        AssignCommand(oSummon4, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oSummon4, nDuration);
    }
    if(nNumero > 4)
    {
        object oSummon5 = CreateObject(OBJECT_TYPE_CREATURE, sSumon, GetSpellTargetLocation(), FALSE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, GetLocation(oSummon5)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon5));
        if(GetIsObjectValid(GetMaster(OBJECT_SELF)) == TRUE)
        {
            AssignCommand(GetMaster(OBJECT_SELF), DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oSummon5)));
        }
        //DelayCommand( nDuration, AssignCommand(oSummon5, ActionJumpToLocation(GetLocation(GetObjectByTag("outsider")))));
        AssignCommand(oSummon5, SetIsDestroyable(TRUE, FALSE, FALSE));
        DestroyObject(oSummon5, nDuration);
    }



    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the integer used to hold the spells spell school
}

