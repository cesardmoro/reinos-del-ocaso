/** @file
 *
 * @todo: Primo, could you fill in the comments for this file?
 *
 * @author Primogenitor
 */

#include "prc_misc_const"


struct trap
{
//DC to detect the trap
    int nDetectDC;
//DC to disarm the trap
//By PnP only rogues can disarm traps over DC 35?
//this is not implemented yet
    int nDisarmDC;
//this is the vfx_persistent.2da row number of the AoEs
//that make up the trap
//used to determine the size of it
//usually this is 10m larger than the radius of the trap
    int nDetectAOE;
    int nTrapAOE;
//this is the resref of the invisible object to use
//to mark the trap
//defaults to prgt_invis
    string sResRef;
//this is the script that is fired when the trap is
//triggered
//defaults to prgt_trap_fire
    string sTriggerScript;
//if the trap casts a spell when triggered
//these control the details
    int nSpellID;
    int nSpellLevel;
    int nSpellMetamagic;
    int nSpellDC;
//these are for normal dmaging type traps
    int nDamageType;
    int nRadius;
    int nDamageDice;
    int nDamageSize;
    int nTargetVFX;
    int nTrapVFX;
    int nFakeSpell;
    int nBeamVFX;
//this is a mesure of CR of the trap
//can be used by XP scripts
    int nCR;
//delay before respawning once destroyed/disarmed
    int nRespawnSeconds;
//CR passed to CreateRandomTrap when respawning
//if not set, uses same trap as before
    int nRespawnRandomCR;
};

struct trap GetLocalTrap(object oObject, string sVarName);
void SetLocalTrap(object oObject, string sVarName, struct trap tTrap);
void DeleteLocalTrap(object oObject, string sVarName);
struct trap CreateRandomTrap(int nCR = -1);

/**
 * Converts the given trap into a string. The structure members' names and
 * values are listed separated by line breaks.
 *
 * @param tTrap A trap structure to convert into a string.
 * @return      A string representation of tTrap.
 */
string TrapToString(struct trap tTrap);


//////////////////////////////////////
/* Includes                         */
//////////////////////////////////////

#include "inc_utility"



//////////////////////////////////////
/* Function Definitions             */
//////////////////////////////////////

struct trap CreateRandomTrap(int nCR = -1)
{
    if(nCR == -1)
    {
        nCR = GetECL(GetFirstPC());
        nCR += Random(5)-2;
        if(nCR < 1)
            nCR = 1;
    }
    struct trap tReturn;
    switch(Random(26))
    {
        case 0: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 1: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 2: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 3: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 4: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 5: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
        case 6: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 7: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 8: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 9: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 10: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 11: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
        case 12: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 13: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 14: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 15: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 16: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 17: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
        case 18: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
        case 19: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
        case 20: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
        case 21: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
        case 22: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
        case 23: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
        case 24: tReturn.nDamageType = DAMAGE_TYPE_ACID; break;
        case 25: tReturn.nDamageType = DAMAGE_TYPE_SONIC; break;
    }

    tReturn.nRadius = 5+(nCR/2);
    tReturn.nDamageDice = 1*nCR;
    tReturn.nDamageSize = 6;
    tReturn.nDetectDC = 15+nCR;
    tReturn.nDisarmDC = 15+nCR;
    tReturn.nDetectAOE = VFX_PER_15M_INVIS;
    tReturn.nTrapAOE = VFX_PER_5M_INVIS;
    tReturn.nCR = nCR;
    tReturn.nRespawnSeconds = 0;
    tReturn.nRespawnRandomCR = nCR;
    tReturn.sResRef = "prgt_invis";
    tReturn.sTriggerScript = "prgt_trap_fire";

    switch(tReturn.nDamageType)
    {
        case DAMAGE_TYPE_BLUDGEONING:
            tReturn.nFakeSpell = 773; //bolder tossing
            tReturn.nRadius /= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_SLASHING:
            tReturn.nTrapVFX = VFX_FNF_SWINGING_BLADE;
            tReturn.nRadius /= 2;
            tReturn.nDamageSize *= 2;
            break;
        case DAMAGE_TYPE_PIERCING:
            tReturn.nTargetVFX = VFX_IMP_SPIKE_TRAP;
            tReturn.nRadius /= 4;
            tReturn.nDamageSize *= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_COLD:
            tReturn.nTrapVFX = VFX_FNF_ICESTORM;
            tReturn.nTargetVFX = VFX_IMP_FROST_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_FIRE:
            tReturn.nTrapVFX = VFX_FNF_FIREBALL;
            tReturn.nTargetVFX = VFX_IMP_FLAME_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_ELECTRICAL:
            tReturn.nBeamVFX = VFX_BEAM_LIGHTNING;
            tReturn.nTargetVFX = VFX_IMP_LIGHTNING_S;
            tReturn.nRadius /= 4;
            tReturn.nDamageSize *= 2;
            tReturn.nDamageDice *= 2;
            break;
        case DAMAGE_TYPE_SONIC:
            tReturn.nTrapVFX = VFX_FNF_SOUND_BURST;
            tReturn.nTargetVFX = VFX_IMP_SONIC;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
        case DAMAGE_TYPE_ACID:
            tReturn.nTrapVFX = VFX_FNF_GAS_EXPLOSION_ACID;
            tReturn.nTargetVFX = VFX_IMP_ACID_S;
            tReturn.nRadius *= 2;
            tReturn.nDamageSize /= 2;
            tReturn.nDamageDice /= 2;
            break;
    }
    return tReturn;
}

struct trap GetLocalTrap(object oObject, string sVarName)
{
    struct trap tReturn;
    tReturn.nDetectDC       = GetLocalInt(oObject, sVarName+".nDetectDC");
    tReturn.nDisarmDC       = GetLocalInt(oObject, sVarName+".nDisarmDC");
    tReturn.nDetectAOE      = GetLocalInt(oObject, sVarName+".nDetectAOE");
    tReturn.nTrapAOE        = GetLocalInt(oObject, sVarName+".nTrapAOE");
    tReturn.sResRef         = GetLocalString(oObject, sVarName+".sResRef");
    tReturn.sTriggerScript  = GetLocalString(oObject, sVarName+".sTriggerScript");
    tReturn.nSpellID        = GetLocalInt(oObject, sVarName+".nSpellID");
    tReturn.nSpellLevel     = GetLocalInt(oObject, sVarName+".nSpellLevel");
    tReturn.nSpellMetamagic = GetLocalInt(oObject, sVarName+".nSpellMetamagic");
    tReturn.nSpellDC        = GetLocalInt(oObject, sVarName+".nSpellDC");
    tReturn.nDamageType     = GetLocalInt(oObject, sVarName+".nDamageType");
    tReturn.nRadius         = GetLocalInt(oObject, sVarName+".nRadius");
    tReturn.nDamageDice     = GetLocalInt(oObject, sVarName+".nDamageDice");
    tReturn.nDamageSize     = GetLocalInt(oObject, sVarName+".nDamageSize");
    tReturn.nTargetVFX      = GetLocalInt(oObject, sVarName+".nTargetVFX");
    tReturn.nTrapVFX        = GetLocalInt(oObject, sVarName+".nTrapVFX");
    tReturn.nFakeSpell      = GetLocalInt(oObject, sVarName+".nFakeSpell");
    tReturn.nBeamVFX        = GetLocalInt(oObject, sVarName+".nBeamVFX");
    tReturn.nCR             = GetLocalInt(oObject, sVarName+".nCR");
    tReturn.nRespawnSeconds = GetLocalInt(oObject, sVarName+".nRespawnSeconds");
    tReturn.nRespawnRandomCR= GetLocalInt(oObject, sVarName+".nRespawnRandomCR");

    //defaults
    if(tReturn.sResRef == "")
        tReturn.sResRef = "prgt_invis";
    if(tReturn.sTriggerScript == "")
        tReturn.sTriggerScript = "prgt_trap_fire";

    return tReturn;
}
void SetLocalTrap(object oObject, string sVarName, struct trap tTrap)
{

    //defaults
    if(tTrap.sResRef == "")
        tTrap.sResRef = "prgt_invis";
    if(tTrap.sTriggerScript == "")
        tTrap.sTriggerScript = "prgt_trap_fire";


    SetLocalInt(oObject, sVarName+".nDetectDC", tTrap.nDetectDC);
    SetLocalInt(oObject, sVarName+".nDisarmDC", tTrap.nDisarmDC);
    SetLocalInt(oObject, sVarName+".nDetectAOE", tTrap.nDetectAOE);
    SetLocalInt(oObject, sVarName+".nTrapAOE", tTrap.nTrapAOE);
    SetLocalString(oObject, sVarName+".sResRef", tTrap.sResRef);
    SetLocalString(oObject, sVarName+".sTriggerScript", tTrap.sTriggerScript);
    SetLocalInt(oObject, sVarName+".nSpellID", tTrap.nSpellID);
    SetLocalInt(oObject, sVarName+".nSpellLevel", tTrap.nSpellLevel);
    SetLocalInt(oObject, sVarName+".nSpellMetamagic", tTrap.nSpellMetamagic);
    SetLocalInt(oObject, sVarName+".nSpellDC", tTrap.nSpellDC);
    SetLocalInt(oObject, sVarName+".nDamageType", tTrap.nDamageType);
    SetLocalInt(oObject, sVarName+".nRadius", tTrap.nRadius);
    SetLocalInt(oObject, sVarName+".nDamageDice", tTrap.nDamageDice);
    SetLocalInt(oObject, sVarName+".nDamageSize", tTrap.nDamageSize);
    SetLocalInt(oObject, sVarName+".nTargetVFX", tTrap.nTargetVFX);
    SetLocalInt(oObject, sVarName+".nTrapVFX", tTrap.nTrapVFX);
    SetLocalInt(oObject, sVarName+".nFakeSpell", tTrap.nFakeSpell);
    SetLocalInt(oObject, sVarName+".nBeamVFX", tTrap.nBeamVFX);
    SetLocalInt(oObject, sVarName+".nCR", tTrap.nCR);
    SetLocalInt(oObject, sVarName+".nRespawnSeconds", tTrap.nRespawnSeconds);
    SetLocalInt(oObject, sVarName+".nRespawnRandomCR", tTrap.nRespawnRandomCR);
}
void DeleteLocalTrap(object oObject, string sVarName)
{
    DeleteLocalInt(oObject, sVarName+".nDetectDC");
    DeleteLocalInt(oObject, sVarName+".nDisarmDC");
    DeleteLocalInt(oObject, sVarName+".nDetectAOE");
    DeleteLocalInt(oObject, sVarName+".nTrapAOE");
    DeleteLocalString(oObject, sVarName+".sResRef");
    DeleteLocalString(oObject, sVarName+".sTriggerScript");
    DeleteLocalInt(oObject, sVarName+".nSpellID");
    DeleteLocalInt(oObject, sVarName+".nSpellLevel");
    DeleteLocalInt(oObject, sVarName+".nSpellLevelMetamagic");
    DeleteLocalInt(oObject, sVarName+".nSpellLevelDC");
    DeleteLocalInt(oObject, sVarName+".nDamageType");
    DeleteLocalInt(oObject, sVarName+".nRadius");
    DeleteLocalInt(oObject, sVarName+".nDamageDice");
    DeleteLocalInt(oObject, sVarName+".nDamageSize");
    DeleteLocalInt(oObject, sVarName+".nTargetVFX");
    DeleteLocalInt(oObject, sVarName+".nTrapVFX");
    DeleteLocalInt(oObject, sVarName+".nFakeSpell");
    DeleteLocalInt(oObject, sVarName+".nBeamVFX");
    DeleteLocalInt(oObject, sVarName+".nCR");
    DeleteLocalInt(oObject, sVarName+".nRespawnSeconds");
    DeleteLocalInt(oObject, sVarName+".nRespawnRandomCR");
}

string TrapToString(struct trap tTrap)
{
    string s;
    s += "nDetectDC: "        + IntToString(tTrap.nDetectDC)        + "\n";
    s += "nDisarmDC: "        + IntToString(tTrap.nDisarmDC)        + "\n";
    s += "nDetectAOE: "       + IntToString(tTrap.nDetectAOE)       + "\n";
    s += "nTrapAOE: "         + IntToString(tTrap.nTrapAOE)         + "\n";
    s += "sResRef: '"         + tTrap.sResRef                       + "'\n";
    s += "sTriggerScript: '"  + tTrap.sTriggerScript                + "'\n";
    s += "nSpellID: "         + IntToString(tTrap.nSpellID)         + "\n";
    s += "nSpellLevel: "      + IntToString(tTrap.nSpellLevel)      + "\n";
    s += "nSpellMetamagic: "  + IntToString(tTrap.nSpellMetamagic)  + "\n";
    s += "nSpellDC: "         + IntToString(tTrap.nSpellDC)         + "\n";
    s += "nDamageType: "      + IntToString(tTrap.nDamageType)      + "\n";
    s += "nRadius: "          + IntToString(tTrap.nRadius)          + "\n";
    s += "nDamageDice: "      + IntToString(tTrap.nDamageDice)      + "\n";
    s += "nDamageSize: "      + IntToString(tTrap.nDamageSize)      + "\n";
    s += "nTargetVFX: "       + IntToString(tTrap.nTargetVFX)       + "\n";
    s += "nTrapVFX: "         + IntToString(tTrap.nTrapVFX)         + "\n";
    s += "nFakeSpell: "       + IntToString(tTrap.nFakeSpell)       + "\n";
    s += "nBeamVFX: "         + IntToString(tTrap.nBeamVFX)         + "\n";
    s += "nCR: "              + IntToString(tTrap.nCR)              + "\n";
    s += "nRespawnSeconds: "  + IntToString(tTrap.nRespawnSeconds)  + "\n";
    s += "nRespawnRandomCR: " + IntToString(tTrap.nRespawnRandomCR) + "\n";

    return s;
}
