
int GetIsPolyMorphedOrShifted(object oCreature);
void DoDisguise(int nRace, object oTarget = OBJECT_SELF);
void ShifterCheck(object oPC);

#include "pnp_shft_main"

void ShifterCheck(object oPC)
{
    if (!GetIsPC(oPC))
        return;
    int iShifterLevels = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);
    if (iShifterLevels>0)
    {
        object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
        int iTemp = GetLocalInt(oHidePC,"nPCShifted");

        if (iTemp)
        {
        SetShiftTrueForm(oPC);
        }
        //by adding this var the shifter will unpolymorph before shapeshifting
        SetLocalInt(oHidePC,"nPCShifted",TRUE);
    }
}


//changes portrait, head, and appearance
//based on the target race with a degree of randomization.
void DoDisguise(int nRace, object oTarget = OBJECT_SELF)
{
    //store current appearance to be safe
    StoreAppearance(oTarget);
    int nAppearance; //appearance to change into
    int nHeadMax;    //max head ID, changed to random 1-max
    int nGender = GetGender(oTarget);
    int nPortraitMin;//minimum row in portraits.2da
    int nPortraitMax;//maximum row in portraits.2da
    switch(nRace)
    {
        case RACIAL_TYPE_DWARF:
            nAppearance = APPEARANCE_TYPE_DWARF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =   9;  nPortraitMax =  17; }
            else
            {   nHeadMax = 12; nPortraitMin =   1;  nPortraitMax =   8; }
            break;
        case RACIAL_TYPE_ELF:
            nAppearance = APPEARANCE_TYPE_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 10; nPortraitMin =  31;  nPortraitMax =  40; }
            else
            {   nHeadMax = 16; nPortraitMin =  18;  nPortraitMax =  30; }
            break;
        case RACIAL_TYPE_HALFELF:
            nAppearance = APPEARANCE_TYPE_HALF_ELF;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin =  93;  nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin =  67;  nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFORC:
            nAppearance = APPEARANCE_TYPE_HALF_ORC;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 134;  nPortraitMax = 139; }
            else
            {   nHeadMax = 1;  nPortraitMin = 130;  nPortraitMax = 133; }
            break;
        case RACIAL_TYPE_HUMAN:
            nAppearance = APPEARANCE_TYPE_HUMAN;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 18; nPortraitMin = 93;   nPortraitMax = 112; }
            else
            {   nHeadMax = 15; nPortraitMin = 67;   nPortraitMax = 92;  }
            break;
        case RACIAL_TYPE_HALFLING:
            nAppearance = APPEARANCE_TYPE_HALFLING;
            if(nGender == GENDER_MALE)
            {   nHeadMax =  8; nPortraitMin = 61;   nPortraitMax = 66; }
            else
            {   nHeadMax = 11; nPortraitMin = 54;   nPortraitMax = 59;  }
            break;
        case RACIAL_TYPE_GNOME:
            nAppearance = APPEARANCE_TYPE_GNOME;
            if(nGender == GENDER_MALE)
            {   nHeadMax = 11; nPortraitMin = 47;   nPortraitMax = 53; }
            else
            {   nHeadMax =  9; nPortraitMin = 41;   nPortraitMax = 46;  }
            break;
        default: //not a normal race, abort
            return;
    }
    //change the appearance
    SetCreatureAppearanceType(oTarget, nAppearance);

    //need to be delayed a bit otherwise you get "supergnome" and "exploded elf" effects
    DelayCommand(1.1, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,       d2(), oTarget));
    DelayCommand(1.2, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,        d2(), oTarget));
    DelayCommand(1.3, SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,      d2(), oTarget));
    DelayCommand(1.4, SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,       d2(), oTarget));
    DelayCommand(1.5, SetCreatureBodyPart(CREATURE_PART_TORSO,            d2(), oTarget));
    DelayCommand(1.6, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,    d2(), oTarget));
    DelayCommand(1.7, SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,     d2(), oTarget));
    DelayCommand(1.8, SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,      d2(), oTarget));
    DelayCommand(1.9, SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,       d2(), oTarget));
    
    //dont do these body parts, they dont have tattoos and weird things could happen
    //SetCreatureBodyPart(CREATURE_PART_BELT,             d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_NECK,             d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER,   d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,    d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,       d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_HAND,        d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_PELVIS,           d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,       d2(), oTarget);
    //SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,        d2(), oTarget);
    //randomise the head
    DelayCommand(2.0, SetCreatureBodyPart(CREATURE_PART_HEAD, Random(nHeadMax)+1, oTarget));
    
    //remove any wings/tails
    SetCreatureWingType(CREATURE_WING_TYPE_NONE, oTarget);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oTarget);

    int nPortraitID = Random(nPortraitMax-nPortraitMin+1)+nPortraitMin;
    string sPortraitResRef = Get2DACache("portraits", "BaseResRef", nPortraitID);
    sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1); //trim the trailing _
    SetPortraitResRef(oTarget, sPortraitResRef);
    SetPortraitId(oTarget, nPortraitID);
}

// Determine whether the character is polymorphed or shfited.
int GetIsPolyMorphedOrShifted(object oCreature)
{
    int bPoly = FALSE;

    object oHide = GetPCSkin(oCreature);

    effect eChk = GetFirstEffect(oCreature);

    while (GetIsEffectValid(eChk))
    {
        if (GetEffectType(eChk) == EFFECT_TYPE_POLYMORPH)
            bPoly = TRUE;

        eChk = GetNextEffect(oCreature);
    }

    if (GetLocalInt(oHide, "nPCShifted"))
        bPoly = TRUE;

    return bPoly;
}

//utility functions to make sure characters that gain wings/tails permanently
//interact with the polymorph system by overwriting the default form


void DoWings(object oPC, int nWingType)
{
    //wing invalid, abort
    if(nWingType <= 0) 
        return;
    //already has wings, keep them
    if(GetCreatureWingType(oPC) != CREATURE_WING_TYPE_NONE) 
        return;   
    //already has a default wings, keep them   
    if(GetPersistantLocalInt(oPC,    "AppearanceStoredWing"))
        return;
    //if polymorphed or shifted, dont do the real change
    if(!GetIsPolyMorphedOrShifted(oPC)) 
        SetCreatureWingType(nWingType, oPC);
    //override any stored default appearance
    SetPersistantLocalInt(oPC,    "AppearanceStoredWing", nWingType);    
}

void DoTail(object oPC, int nTailType)
{
    //tail invalid, use current
    if(nTailType == -1) 
        return;
    //already has tail, keep it
    if(GetCreatureTailType(oPC)) 
        return;
    //already has a default tail, keep it   
    if(GetPersistantLocalInt(oPC,    "AppearanceStoredTail"))
        return;
    //if polymorphed or shifted, dont do the real change
    if(!GetIsPolyMorphedOrShifted(oPC)) 
        SetCreatureTailType(nTailType, oPC);
    //override any stored default appearance
    SetPersistantLocalInt(oPC,    "AppearanceStoredTail", nTailType);
}