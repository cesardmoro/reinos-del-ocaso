//
//  Wrapper Functions for the Archmage Class and Feats
//

//
//  Notes:  Normal use is to include prc_alterations.
//          If this file if to be included elsewhere add the following lines
//          to the target file:
//              #include "prcsp_reputation"
//              #include "prcsp_archmaginc"
//

//#include "prcsp_reputation"

const string MASTERY_OF_ELEMENTS_TAG = "archmage_mastery_elements";
const string MASTERY_OF_ELEMENTS_NAME_TAG = "archmage_mastery_elements_name";
const string MASTERY_OF_SHAPE_TAG = "archmage_mastery_shaping";
const string MASTERY_OF_SHAPE_ON = "Shaping spells to protect allies.";
const string MASTERY_OF_SHAPE_OFF = "Spell shaping is disabled, allies may be effected.";
const string MASTERY_OF_ELEMENTS_ACID = "Elemental spell damage set to acid.";
const string MASTERY_OF_ELEMENTS_COLD = "Elemental spell damage set to cold.";
const string MASTERY_OF_ELEMENTS_ELECTRICAL = "Elemental spell damage set to electrical.";
const string MASTERY_OF_ELEMENTS_FIRE = "Elemental spell damage set to fire.";
const string MASTERY_OF_ELEMENTS_SONIC = "Elemental spell damage set to sonic.";
const string MASTERY_OF_ELEMENTS_OFF = "Elemental spell damage returned to normal.";

const int FEAT_INACTIVE = 0;
const int FEAT_ACTIVE = 1;

const int MASTERY_OF_SHAPE_EFFECT = 460;
const int MASTERY_OF_ELEMENTS_EFFECT_ACID = 448;
const int MASTERY_OF_ELEMENTS_EFFECT_ELECTRICAL = 463;
const int MASTERY_OF_ELEMENTS_EFFECT_OFF = 460;

const int SPELL_MASTERY_ELEMENTS_NORMAL = 2000;
const int SPELL_MASTERY_ELEMENTS_ACID = 2003;
const int SPELL_MASTERY_ELEMENTS_COLD = 2002;
const int SPELL_MASTERY_ELEMENTS_ELECTRICITY = 2004;
const int SPELL_MASTERY_ELEMENTS_FIRE = 2001;
const int SPELL_MASTERY_ELEMENTS_SONIC = 2005;

const int TIME_1_ROUND = 1;

//
//  Check if the Mastery of Shapes feat applies
//
int
CheckMasteryOfShapes(object oCaster, object oTarget)
{
    int bRetVal = FALSE;

    // This variable should not be set without the feat being available.
    // If someone wants to cheat, let them.
    if (GetLocalInt(oCaster, MASTERY_OF_SHAPE_TAG) == FEAT_ACTIVE && !GetIsReactionTypeHostile(oTarget, oCaster))
    {
         bRetVal = TRUE;
    }

    return bRetVal;
}

//
//  Help with Visual Effects when setting feats
//
void
SetFeatVisualEffects(object oCaster, int nEffect, string sMessage)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nEffect),
            oCaster, RoundsToSeconds(TIME_1_ROUND));

    FloatingTextStringOnCreature(sMessage, OBJECT_SELF, FALSE);
}

//
//  Enable/Disable Mastery of Shapes
//
void
ToggleMasteryOfShapes(object oCaster)
{
    if (GetLocalInt(OBJECT_SELF, MASTERY_OF_SHAPE_TAG) == FEAT_INACTIVE) {
        SetLocalInt(OBJECT_SELF, MASTERY_OF_SHAPE_TAG, FEAT_ACTIVE);
        SetFeatVisualEffects(oCaster, MASTERY_OF_SHAPE_EFFECT, MASTERY_OF_SHAPE_ON);
    }
    else {
        SetLocalInt(OBJECT_SELF, MASTERY_OF_SHAPE_TAG, FEAT_INACTIVE);
        SetFeatVisualEffects(oCaster, MASTERY_OF_SHAPE_EFFECT, MASTERY_OF_SHAPE_OFF);
    }
}

//
//  This function sets the Mastery of Elements feat to a specific element
//
void
SetMasteryOfElements()
{
    string msg = MASTERY_OF_ELEMENTS_OFF;
    string sElem = "";
    int nEffect = MASTERY_OF_ELEMENTS_EFFECT_OFF;
    int dmgType = FEAT_INACTIVE;

    switch (GetSpellId()) {
        case SPELL_MASTERY_ELEMENTS_ACID:
            nEffect = MASTERY_OF_ELEMENTS_EFFECT_ACID;
            dmgType = DAMAGE_TYPE_ACID;
            msg = MASTERY_OF_ELEMENTS_ACID;
            sElem = "Acid";
            break;

        case SPELL_MASTERY_ELEMENTS_COLD:
            nEffect = VFX_IMP_AC_BONUS;
            dmgType = DAMAGE_TYPE_COLD;
            msg = MASTERY_OF_ELEMENTS_COLD;
            sElem = "Cold";
            break;

        case SPELL_MASTERY_ELEMENTS_ELECTRICITY:
            nEffect = MASTERY_OF_ELEMENTS_EFFECT_ELECTRICAL;
            dmgType = DAMAGE_TYPE_ELECTRICAL;
            msg = MASTERY_OF_ELEMENTS_ELECTRICAL;
            sElem = "Electricity";
            break;

        case SPELL_MASTERY_ELEMENTS_FIRE:
            nEffect = VFX_IMP_ELEMENTAL_PROTECTION;
            dmgType = DAMAGE_TYPE_FIRE;
            msg = MASTERY_OF_ELEMENTS_FIRE;
            sElem = "Fire";
            break;

        case SPELL_MASTERY_ELEMENTS_SONIC:
            nEffect = VFX_FNF_SOUND_BURST;
            dmgType = DAMAGE_TYPE_SONIC;
            msg = MASTERY_OF_ELEMENTS_SONIC;
            sElem = "Sonic";
            break;

        default:
            // Use the default initialized variables
            break;
    }

    SetLocalInt(OBJECT_SELF, MASTERY_OF_ELEMENTS_TAG, dmgType);
    SetLocalString(OBJECT_SELF, MASTERY_OF_ELEMENTS_NAME_TAG, sElem);
    SetFeatVisualEffects(GetSpellTargetObject(), nEffect, msg);
}

//
//  This function determines if spell damage is elemental
//
int IsSpellDamageElemental(int nDamageType)
{
    return nDamageType == DAMAGE_TYPE_ACID
        || nDamageType == DAMAGE_TYPE_COLD
        || nDamageType == DAMAGE_TYPE_ELECTRICAL
        || nDamageType == DAMAGE_TYPE_FIRE
        || nDamageType == DAMAGE_TYPE_SONIC;
}

//
//  This function converts spell damage into the correct type
//  TODO: Change the name to consistent (large churn project).
//
int ChangedElementalDamage(object oCaster, int nDamageType);
int ChangedElementalDamage(object oCaster, int nDamageType){
    // Check if an override is set
    int nNewType = GetLocalInt(oCaster, MASTERY_OF_ELEMENTS_TAG);

    // If so, check if the spell qualifies for a change
    if (!nNewType || !IsSpellDamageElemental(nDamageType))
        nNewType = nDamageType;

    return nNewType;
}

int IsSpellSavingThrowElemental(int nSavingThrowType)
{
    return nSavingThrowType == SAVING_THROW_TYPE_ACID
        || nSavingThrowType == SAVING_THROW_TYPE_COLD
        || nSavingThrowType == SAVING_THROW_TYPE_ELECTRICITY
        || nSavingThrowType == SAVING_THROW_TYPE_FIRE
        || nSavingThrowType == SAVING_THROW_TYPE_SONIC;
}

int ChangedElementalSavingThrow(object oCaster, int nSavingThrowType);
int ChangedElementalSavingThrow(object oCaster, int nSavingThrowType){
    // Check if an override is set
    int nNewType = GetLocalInt(oCaster, MASTERY_OF_ELEMENTS_TAG);

    switch (nNewType) {
        case DAMAGE_TYPE_ACID:          nNewType = SAVING_THROW_TYPE_ACID; break;
        case DAMAGE_TYPE_COLD:          nNewType = SAVING_THROW_TYPE_COLD; break;
        case DAMAGE_TYPE_ELECTRICAL:    nNewType = SAVING_THROW_TYPE_ELECTRICITY; break;
        case DAMAGE_TYPE_FIRE:          nNewType = SAVING_THROW_TYPE_FIRE; break;
        case DAMAGE_TYPE_SONIC:         nNewType = SAVING_THROW_TYPE_SONIC; break;
        default:                        nNewType = nSavingThrowType; break;
    }
    // If so, check if the spell qualifies for a change
    if (!nNewType || !IsSpellSavingThrowElemental(nSavingThrowType))
        nNewType = nSavingThrowType;

    return nNewType;
}

//
//  Determine if a spell type is elemental
//
int
IsSpellTypeElemental(string type)
{
    return type == "Acid"
        || type == "Cold"
        || type == "Electricity"
        || type == "Fire"
        || type == "Sonic";
}

//
//  This function converts elemental types as needed
//
string
ChangedElementalType(int spell_id, object oCaster = OBJECT_SELF)
{
    // Lookup the spell type
    string spellType = lookup_spell_type(spell_id);

    // Check if an override is set
    string sType = GetLocalString(oCaster, MASTERY_OF_ELEMENTS_NAME_TAG);

    // If so, check if the spell qualifies for a change
    if (sType == "" || !IsSpellTypeElemental(spellType))
        sType = spellType;

    return sType;
}
