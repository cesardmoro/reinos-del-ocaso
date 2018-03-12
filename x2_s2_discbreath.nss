
/*
This is the edited script I had made changes to before Silver reverted to
the original. It has:

Round delays for metabreath/multiple uses
Line breath (working)
Pyroclastic being 50% of each
PRCGetReflexAdjustedDamage to interact better with other systems
Range dependant on size
Less code duplication by using dedicated functions. Easier to fix/find bugs.
Moved breath VFX so when different ones for different colors are done they can be easily implemented


Moved to a new script so its not lost permanently. Feel free to refer to this if you want.

Primogenitor



//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller (modified by Silver)
//:: Created On: June, 17, 2003 (June, 7, 2005)
//:://////////////////////////////////////////////
*/
#include "prc_alterations"
#include "inc_dradis"
#include "inc_vfx_const"


//////////////////////////
// Constant Definitions //
//////////////////////////

const string DDISBREATHLOCK = "DragonDiscipleBreathLock";


int IsLineBreath()
{
    if(GetHasFeat(FEAT_BLACK_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BLUE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRASS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BRONZE_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_COPPER_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_AMETHYST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_BROWN_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_CHAOS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_OCEANUS_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RADIANT_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_RUST_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_STYX_DRAGON, OBJECT_SELF)
        || GetHasFeat(FEAT_TARTIAN_DRAGON, OBJECT_SELF)
        )
        return TRUE;
    return FALSE;
}

float GetRangeFromSize(int nSize)
{
    float fRange = 10.0;
    switch(nSize)
    {
        case CREATURE_SIZE_TINY:        fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_SMALL:       fRange = FeetToMeters(30.0); break;
        case CREATURE_SIZE_MEDIUM:      fRange = FeetToMeters(30.0); break;
        //PnP says 30, but I think this doesnt fit the progression so Ive made it 40
        //Primogenitor
        case CREATURE_SIZE_LARGE:       fRange = FeetToMeters(40.0); break;
        case CREATURE_SIZE_HUGE:        fRange = FeetToMeters(50.0); break;
    }
    return fRange;
}

//This is the main breath attack script.  33 out of 38 Dragon Disciple
//types use this script for breath attacks.  All basic breath attacks
//which deal 1 type of damage with a reflex saving throw.
void BreathAttack(object oPC ,object oSkin ,int DBREED ,int nSaveDC ,int nLevel ,int nDamage)
{
    //Sets what type of saving throw is to be made by those caught in the dragon disciples
    //breath weapon.
    int SAVETH;
    switch (DBREED) {
        case DAMAGE_TYPE_ACID:              SAVETH = SAVING_THROW_TYPE_ACID; break;
        case DAMAGE_TYPE_FIRE:              SAVETH = SAVING_THROW_TYPE_FIRE; break;
        case DAMAGE_TYPE_COLD:              SAVETH = SAVING_THROW_TYPE_COLD; break;
        case DAMAGE_TYPE_ELECTRICAL:       SAVETH = SAVING_THROW_TYPE_ELECTRICITY; break;
    }

    //Sets visual effect for object struck, varying based on the element or nature of the
    //Dragon Disciples type.
    int VISUAL;
    switch (DBREED) {
        case DAMAGE_TYPE_ACID:          VISUAL = VFX_IMP_ACID_S; break;
        case DAMAGE_TYPE_FIRE:          VISUAL = VFX_IMP_FLAME_M; break;
        case DAMAGE_TYPE_COLD:          VISUAL = VFX_IMP_FROST_S; break;
        case DAMAGE_TYPE_ELECTRICAL:   VISUAL = VFX_IMP_LIGHTNING_S; break;
    }

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;

    float fRange = 10.0;//meters not feet!
    int nSize = GetCreatureSize(oPC);
    fRange = GetRangeFromSize(nSize);

    int nBreathShape = SHAPE_SPELLCONE;

    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,
                                    OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE,
                                    GetPosition(oPC));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(oPC, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, SAVETH);

            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, DBREED);
                eVis = EffectVisualEffect(VISUAL);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}





//This is the main breath attack script for the Chaos Dragon Disciple.
//It is almost exactly the same script as the main dragon disciples,
//but the element caused by the breath attack is unpredictable to the
//player.  Each time they breath, a new element might results.
void RandomBreath(object oPC ,object oSkin ,int dChaos ,int nSaveDC ,int nLevel ,int nDamage)
{
    int eleBreath;
    int chSaveth;
    int chVisual;
    int eleRoll;

    int nNumDice = d10();
    //Sets the random Element factor of the Chaos Dragons Breath Weapon.
    //Affects damage, saving throw, and impact visual.
    if (nNumDice==1)
    {
        eleBreath = DAMAGE_TYPE_COLD;
        chSaveth = SAVING_THROW_TYPE_COLD;
        chVisual = VFX_IMP_FROST_S;
    }
    else if (nNumDice==2)
    {
        eleBreath = DAMAGE_TYPE_COLD;
        chSaveth = SAVING_THROW_TYPE_COLD;
        chVisual = VFX_IMP_FROST_S;
    }
    else if (nNumDice==3)
    {
        eleBreath = DAMAGE_TYPE_ACID;
        chSaveth = SAVING_THROW_TYPE_ACID;
        chVisual = VFX_IMP_ACID_S;
    }
    else if (nNumDice==4)
    {
        eleBreath = DAMAGE_TYPE_ACID;
        chSaveth = SAVING_THROW_TYPE_ACID;
        chVisual = VFX_IMP_ACID_S;
    }
    else if (nNumDice==5)
    {
        eleBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }
    else if (nNumDice==6)
    {
        eleBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }
    else if (nNumDice==7)
    {
        eleBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==8)
    {
        eleBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==9)
    {
        eleBreath = DAMAGE_TYPE_ELECTRICAL;
        chSaveth = SAVING_THROW_TYPE_ELECTRICITY;
        chVisual = VFX_IMP_LIGHTNING_S;
    }
    else if (nNumDice==10)
    {
        eleBreath = DAMAGE_TYPE_ELECTRICAL;
        chSaveth = SAVING_THROW_TYPE_ELECTRICITY;
        chVisual = VFX_IMP_LIGHTNING_S;
    }

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;

    float fRange = 10.0;//meters not feet!
    int nSize = GetCreatureSize(oPC);
    fRange = GetRangeFromSize(nSize);

    int nBreathShape = SHAPE_SPELLCYLINDER;
/*
    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }
*/
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,
                                    OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE,
                                    GetPosition(oPC));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(oPC, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, chSaveth);
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, eleBreath);
                eVis = EffectVisualEffect(chVisual);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}









//Pyroclastic Dragons Breath Attack.  This should be half fire and half sonic damage
//But any attempts I made to produce that effect would not function properly.  Instead,
//for now, the Pyroclastic Dragon has a 50/50 chance of breathing either fire or sonic.
void sonfireBreath(object oPC ,object oSkin ,int dPyCla ,int nSaveDC ,int nLevel ,int nDamage)
{
//    int pyclBreath;
    int chSaveth;
    int chVisual;
    int eleRoll;

    int nNumDice = d2();
    //Sets the random Element factor of the Chaos Dragons Breath Weapon.
    //Affects damage, saving throw, and impact visual.
    if (nNumDice==1)
    {
//        pyclBreath = DAMAGE_TYPE_SONIC;
        chSaveth = SAVING_THROW_TYPE_SONIC;
        chVisual = VFX_IMP_SILENCE;
    }
    else if (nNumDice==2)
    {
//        pyclBreath = DAMAGE_TYPE_FIRE;
        chSaveth = SAVING_THROW_TYPE_FIRE;
        chVisual = VFX_IMP_FLAME_M;
    }

    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    int nPersonalDamage;
    float fRange = 10.0;//meters not feet!
    int nSize = GetCreatureSize(OBJECT_SELF);
    fRange = GetRangeFromSize(nSize);

    int nBreathShape = SHAPE_SPELLCONE;

    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            nPersonalDamage = PRCGetReflexAdjustedDamage(nPersonalDamage, oTarget, nSaveDC, chSaveth);
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                //eBreath = EffectDamage(nPersonalDamage, pyclBreath);
                effect eBreath1 = EffectDamage(nPersonalDamage/2, DAMAGE_TYPE_FIRE);
                effect eBreath2 = EffectDamage(nPersonalDamage/2, DAMAGE_TYPE_SONIC);
                //eBreath = EffectLinkEffects(eBreath2, eBreath1);
                eVis = EffectVisualEffect(chVisual);
                //Apply the VFX impact and effects

                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath1, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath2, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}

//Shadow Dragon Breath Attack.  Does not inflict damage, but rather bestows
//those caught in its breath with 1 negative level.  This is still a reflex save
//apparently.
void ShadowBreath(object oPC ,object oSkin ,int dShadow ,int nSaveDC ,int nLevel)
{
    //Declare major variables
    float fDelay;
    object oTarget;
    effect eVis, sDrain;

    int shadowDrain;
    float fRange = 10.0;//meters not feet!
    int nSize = GetCreatureSize(OBJECT_SELF);
    fRange = GetRangeFromSize(nSize);

    int nBreathShape = SHAPE_SPELLCONE;

    //these are lines not cones
    if(IsLineBreath())
    {
        nBreathShape = SHAPE_SPELLCYLINDER;
        fRange *= 2.0; //double the range
    }

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        shadowDrain = 1;
        if(oTarget != oPC && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(oPC, oTarget)/20;
            shadowDrain = PRCGetReflexAdjustedDamage(shadowDrain, oTarget, nSaveDC, SAVING_THROW_TYPE_NEGATIVE);
            if (shadowDrain > 0)
            {
                //Set Damage and VFX
                sDrain = EffectNegativeLevel(shadowDrain);
                eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, sDrain, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(nBreathShape, fRange, PRCGetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
    }
}

void main()
{
    //Declare main variables.
    object oPC   = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    // Check the dragon breath delay lock
    if(GetLocalInt(oPC, DDISBREATHLOCK))
    {
        SendMessageToPC(oPC, "You cannot use your breath weapon again so soon"); /// TODO: TLKify
        IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
        return;
    }
    // Set the lock
    SetLocalInt(oPC, DDISBREATHLOCK, TRUE);

    // Schedule opening the delay lock
    float fDelay = RoundsToSeconds(d4());
    /// TODO: When metabreath is implemented, but the additional delay calculation here


    DelayCommand(fDelay, DeleteLocalInt(oPC, DDISBREATHLOCK));
    DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now")); /// TODO: TLKify

    int nConBoost = GetAbilityModifier(ABILITY_CONSTITUTION);
    if (nConBoost < 0) nConBoost = 0;
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    int nDamageDice;

    //Sets the save DC for Dragon Breath attacks.  This is a reflex save to halve the damage.
    //Save is 10+CON+1/2 DD level.  Gains +1 at level 13, and every 3 levels after.
    int nSaveDC = 10 + nConBoost + ((nLevel)/2);
    nSaveDC += ((nLevel - 10) / 3 < 0) ? 0 : ((nLevel - 10) / 3);
    /*
    if      (nLevel <13)   nSaveDC = (10 + ((nLevel)/2) + nConBoost);
    else if (nLevel <16)   nSaveDC = (11 + ((nLevel)/2) + nConBoost);
    else if (nLevel <19)   nSaveDC = (12 + ((nLevel)/2) + nConBoost);
    else if (nLevel <22)   nSaveDC = (13 + ((nLevel)/2) + nConBoost);
    else if (nLevel <25)   nSaveDC = (14 + ((nLevel)/2) + nConBoost);
    else if (nLevel <28)   nSaveDC = (15 + ((nLevel)/2) + nConBoost);
    else                   nSaveDC = (16 + ((nLevel)/2) + nConBoost);
    */

    //Sets damage levels for Dragon Breath attacks.  2d10 at level 3,
    //4d10 at level 7, and then an additional 2d10 every 3 levels (10, 13, 16, ect)
    nDamageDice = ((nLevel < 7) ? 2 : 4);
    nDamageDice += ((nLevel - 7) / 3 < 0) ? 0 : ((nLevel - 7) / 3);// Special handling of the 4 level jump

    /*
    if      (nLevel <7)   nDamageDice = 2;
    else if (nLevel <10)  nDamageDice = 4;
    else if (nLevel <13)  nDamageDice = 6;
    else if (nLevel <16)  nDamageDice = 8;
    else if (nLevel <19)  nDamageDice = 10;
    else if (nLevel <22)  nDamageDice = 12;
    else if (nLevel <25)  nDamageDice = 14;
    else if (nLevel <28)  nDamageDice = 16;
    else                  nDamageDice = 18;
    */
    int nDamage = d10(nDamageDice);
    if(DEBUG) DoDebug("x2_s2_discbreath: Rolling damage: " + IntToString(nDamageDice) + "d10 = " + IntToString(nDamage));

    int dragonType = GetCampaignInt(DraDis_DATABASE, DraDis_DRAGON_TYPE, oPC);
    int DBREED;
    switch (dragonType) {
        case DRAGON_TYPE_BLACK:             DBREED = DAMAGE_TYPE_ACID; break;
        case DRAGON_TYPE_BLUE:              DBREED = DAMAGE_TYPE_ELECTRICAL; break;
        case DRAGON_TYPE_BRASS:             DBREED = DAMAGE_TYPE_FIRE; break;
        case DRAGON_TYPE_BRONZE:            DBREED = DAMAGE_TYPE_ELECTRICAL; break;
        case DRAGON_TYPE_COPPER:            DBREED = DAMAGE_TYPE_ACID; break;
        case DRAGON_TYPE_GOLD:              DBREED = DAMAGE_TYPE_FIRE; break;
        case DRAGON_TYPE_GREEN:             DBREED = DAMAGE_TYPE_ACID; break;
        case DRAGON_TYPE_RED:               DBREED = DAMAGE_TYPE_FIRE; break;
        case DRAGON_TYPE_SILVER:            DBREED = DAMAGE_TYPE_COLD; break;
        case DRAGON_TYPE_WHITE:             DBREED = DAMAGE_TYPE_COLD; break;
    }
    int dChaos  = GetHasFeat(FEAT_CHAOS_DRAGON,       oPC);
    int dPyCla  = GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC);
    int dShadow = GetHasFeat(FEAT_SHADOW_DRAGON,      oPC);

    if (DBREED > 0)  BreathAttack (oPC, oSkin, DBREED,  nSaveDC, nLevel, nDamage);
    else if (dChaos > 0)  RandomBreath (oPC, oSkin, dChaos,  nSaveDC, nLevel, nDamage);
    else if (dPyCla > 0)  sonfireBreath(oPC, oSkin, dShadow, nSaveDC, nLevel, nDamage);
    else if (dShadow > 0) ShadowBreath (oPC, oSkin, dShadow, nSaveDC, nLevel);

    //breath VFX
    effect eVis = EffectVisualEffect(VFX_FNF_DRAGBREATHGROUND);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());
}

