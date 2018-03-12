//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

//Modificado por Dragoncin 26/02/07
//Agregadas funcionalidades para la clase de prestigio Bonded Summoner

#include "inc_npc"
#include "prc_class_const"
#include "prc_feat_const"

string SummonMediumCompanion(object oPC) {

    string ResRef;
    if (GetHasFeat(FEAT_BONDED_WATER, oPC))
        ResRef = "summon044";
    else if (GetHasFeat(FEAT_BONDED_AIR, oPC))
        ResRef = "summon045";
    else if (GetHasFeat(FEAT_BONDED_FIRE, oPC))
        ResRef = "summon046";
    else if (GetHasFeat(FEAT_BONDED_EARTH, oPC))
        ResRef = "summon047";
    else
        ResRef = "error";

    return ResRef;

}

string SummonLargeCompanion(object oPC) {

    string ResRef;
    if (GetHasFeat(FEAT_BONDED_WATER, oPC))
        ResRef = "summon056";
    else if (GetHasFeat(FEAT_BONDED_AIR, oPC))
        ResRef = "summon057";
    else if (GetHasFeat(FEAT_BONDED_FIRE, oPC))
        ResRef = "summon058";
    else if (GetHasFeat(FEAT_BONDED_EARTH, oPC))
        ResRef = "summon059";
    else
        ResRef = "error";

    return ResRef;

}

string SummonHugeCompanion(object oPC) {

    string ResRef;
    if (GetHasFeat(FEAT_BONDED_WATER, oPC))
        ResRef = "summon064";
    else if (GetHasFeat(FEAT_BONDED_AIR, oPC))
        ResRef = "summon065";
    else if (GetHasFeat(FEAT_BONDED_FIRE, oPC))
        ResRef = "summon066";
    else if (GetHasFeat(FEAT_BONDED_EARTH, oPC))
        ResRef = "summon067";
    else
        ResRef = "error";

    return ResRef;

}

string SummonGreaterCompanion(object oPC) {

    string ResRef;
    if (GetHasFeat(FEAT_BONDED_WATER, oPC))
        ResRef = "summon072";
    else if (GetHasFeat(FEAT_BONDED_AIR, oPC))
        ResRef = "summon073";
    else if (GetHasFeat(FEAT_BONDED_FIRE, oPC))
        ResRef = "summon074";
    else if (GetHasFeat(FEAT_BONDED_EARTH, oPC))
        ResRef = "summon075";
    else
        ResRef = "error";

    return ResRef;

}

string SummonElderCompanion(object oPC) {

    string ResRef;
    if (GetHasFeat(FEAT_BONDED_WATER, oPC))
        ResRef = "summon079";
    else if (GetHasFeat(FEAT_BONDED_AIR, oPC))
        ResRef = "summon080";
    else if (GetHasFeat(FEAT_BONDED_FIRE, oPC))
        ResRef = "summon081";
    else if (GetHasFeat(FEAT_BONDED_EARTH, oPC))
        ResRef = "summon082";
    else
        ResRef = "error";

    return ResRef;

}

void main()
{

    SummonFamiliar();

    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) > 0) {

        object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
        DestroyObject(oFam, 0.5);

        object oPC = OBJECT_SELF;
        string ResRef;

        if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) >= 9)
            ResRef = SummonElderCompanion(oPC);
        else if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) >= 7)
            ResRef = SummonGreaterCompanion(oPC);
        else if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) >= 5)
            ResRef = SummonHugeCompanion(oPC);
        else if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) >= 3)
            ResRef = SummonLargeCompanion(oPC);
        else if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) >= 1)
            ResRef = SummonMediumCompanion(oPC);

        if (ResRef=="error") {
            SendMessageToPC(oPC, "Te falta la dote que define tu elemento preferido. Por favor, reportalo a un DM o en el foro (http://www.area51experience.com.ar/foro/).");
            return;
        }

        //Crea el familiar junto con su efecto
        effect eFamiliar = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
        object oFamiliar = CreateObject(OBJECT_TYPE_CREATURE, ResRef, GetSpellTargetLocation(), TRUE);
        DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFamiliar, GetLocation(oFamiliar)));
        DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneDominated()), oFamiliar));

        //Desconvocar el familiar luego de 24 horas
        DestroyObject(oFamiliar, 5760.5);
        eFamiliar = EffectVisualEffect(VFX_IMP_UNSUMMON);
        DelayCommand(5760.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFamiliar, GetLocation(oFamiliar)));

        //Esto hace que pueda recibir ordenes como Seguirme, Protegerme, Atacar, etc.
        SetLocalInt(oFamiliar, "merc", 1);

    }

}
