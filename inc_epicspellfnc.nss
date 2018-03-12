int GetDCForSpell(int nSpellID);
int GetFeatForSpell(int nSpellID);
int GetResearchFeatForSpell(int nSpellID);
int GetIPForSpell(int nSpellID);
int GetResearchIPForSpell(int nSpellID);
int GetCastXPForSpell(int nSpellID);
string GetSchoolForSpell(int nSpellID);
int GetR1ForSpell(int nSpellID);
int GetR2ForSpell(int nSpellID);
int GetR3ForSpell(int nSpellID);
int GetR4ForSpell(int nSpellID);
string GetNameForSpell(int nSpellID);
int GetSpellFromAbrev(string sAbrev);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_utility"
#include "inc_epicspelldef"

// SEED FUNCTIONS

int GetFeatForSeed(int nSeedID)
{
    return StringToInt(Get2DACache("epicspellseeds", "FeatID", nSeedID));
}

int GetIPForSeed(int nSeedID)
{
    return StringToInt(Get2DACache("epicspellseeds", "FeatIPID", nSeedID));
}

int GetDCForSeed(int nSeedID)
{
    return StringToInt(Get2DACache("epicspellseeds", "DC", nSeedID));
}

int GetClassForSeed(int nSeedID)
{
    return StringToInt(Get2DACache("epicspellseeds", "Class", nSeedID));
}

int GetSeedFromAbrev(string sAbrev)
{
    int i = 0;
    string sLabel = Get2DACache("epicspellseeds", "LABEL", i);
    while(sLabel != "")
    {
        if(sAbrev == sLabel)
            return i;
        i++;
        sLabel = Get2DACache("epicspellseeds", "LABEL", i);
    }
    return -1;
}

// SPELL FUNCTIONS

int GetDCForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "DC", nSpellID));
}

int GetFeatForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "SpellFeatID", nSpellID));
}

int GetResearchFeatForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "ResFeatID", nSpellID));
}

int GetIPForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nSpellID));
}

int GetResearchIPForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "ResFeatIPID", nSpellID));
}

int GetCastXPForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "CastingXP", nSpellID));
}

string GetSchoolForSpell(int nSpellID)
{
    return Get2DACache("epicspells", "School", nSpellID);
}

int GetR1ForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "Prereq1", nSpellID));
}

int GetR2ForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "Prereq2", nSpellID));
}

int GetR3ForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "Prereq3", nSpellID));
}

int GetR4ForSpell(int nSpellID)
{
    return StringToInt(Get2DACache("epicspells", "Prereq4", nSpellID));
}

int GetSpellFromAbrev(string sAbrev)
{
    int i = 0;
    string sLabel = Get2DACache("epicspells", "LABEL", i);
    while(sLabel != "")
    {
        if(sAbrev == sLabel)
            return i;
        i++;
        sLabel = Get2DACache("epicspells", "LABEL", i);
    }
    return -1;
}

/// @todo These should be looked up in TLK
string GetNameForSpell(int nSpellID)
{
    string sReturn;
    switch(nSpellID)
    {
        case SPELL_EPIC_ACHHEEL:
            sReturn = "Achilles Heel";
            break;
        case SPELL_EPIC_ALLHOPE:
            sReturn = "All Hope Lost";
            break;
        case SPELL_EPIC_AL_MART:
            sReturn = "Allied Martyr";
            break;
        case SPELL_EPIC_ANARCHY:
            sReturn = "Anarchy's Call";
            break;
        case SPELL_EPIC_ANBLAST:
            sReturn = "Animus Blast";
            break;
        case SPELL_EPIC_ANBLIZZ:
            sReturn = "Animus Blizzard";
            break;
        case SPELL_EPIC_ARMY_UN:
            sReturn = "Army Unfallen";
            break;
        case SPELL_EPIC_A_STONE:
            sReturn = "Audience of Stone";
            break;
        case SPELL_EPIC_BATTLEB:
            sReturn = "Battle Bounding";
            break;
        case SPELL_EPIC_CELCOUN:
            sReturn = "Celestial Council";
            break;
        case SPELL_EPIC_CHAMP_V:
            sReturn = "Champion's Valor";
            break;
        case SPELL_EPIC_CON_RES:
            sReturn = "Contingent Resurrection";
            break;
        case SPELL_EPIC_CON_REU:
            sReturn = "Contingent Reunion";
            break;
        case SPELL_EPIC_DEADEYE:
            sReturn = "Deadeye Sense";
            break;
        case SPELL_EPIC_DTHMARK:
            sReturn = "Deathmark";
            break;
        case SPELL_EPIC_DIREWIN:
            sReturn = "Dire Winter";
            break;
        case SPELL_EPIC_DRG_KNI:
            sReturn = "Dragon Knight";
            break;
        case SPELL_EPIC_DREAMSC:
            sReturn = "Dreamscape";
            break;
        case SPELL_EPIC_DULBLAD:
            sReturn = "Dullblades";
            break;
        case SPELL_EPIC_DWEO_TH:
            sReturn = "Dweomer Thief";
            break;
        case SPELL_EPIC_ENSLAVE:
            sReturn = "Enslave";
            break;
        case SPELL_EPIC_EP_M_AR:
            sReturn = "Epic Mage Armor";
            break;
        case SPELL_EPIC_EP_RPLS:
            sReturn = "Epic Repulsion";
            break;
        case SPELL_EPIC_EP_SP_R:
            sReturn = "Epic Spell Reflection";
            break;
        case SPELL_EPIC_EP_WARD:
            sReturn = "Epic Warding";
            break;
        case SPELL_EPIC_ET_FREE:
            sReturn = "Eternal Freedom";
            break;
        case SPELL_EPIC_FIEND_W:
            sReturn = "Fiendish Words";
            break;
        case SPELL_EPIC_FLEETNS:
            sReturn = "Fleetness of Foot";
            break;
        case SPELL_EPIC_GEMCAGE:
            sReturn = "Gem Cage";
            break;
        case SPELL_EPIC_GODSMIT:
            sReturn = "Godsmite";
            break;
        case SPELL_EPIC_GR_RUIN:
            sReturn = "Greater Ruin";
            break;
        case SPELL_EPIC_GR_SP_RE:
            sReturn = "Greater Spell Resistance";
            break;
        case SPELL_EPIC_GR_TIME:
            sReturn = "Greater Timestop";
            break;
        case SPELL_EPIC_HELSEND:
            sReturn = "Hell Send";
            break;
        case SPELL_EPIC_HELBALL:
            sReturn = "Hellball";
            break;
        case SPELL_EPIC_HERCALL:
            sReturn = "Herculean Alliance";
            break;
        case SPELL_EPIC_HERCEMP:
            sReturn = "Herculean Empowerment";
            break;
        case SPELL_EPIC_IMPENET:
            sReturn = "Impenetrability";
            break;
        case SPELL_EPIC_LEECH_F:
            sReturn = "Leech Field";
            break;
        case SPELL_EPIC_LEG_ART:
            sReturn = "Legendary Artisan";
            break;
        case SPELL_EPIC_LIFE_FT:
            sReturn = "Life Force Transfer";
            break;
        case SPELL_EPIC_MAGMA_B:
            sReturn = "Magma Burst";
            break;
        case SPELL_EPIC_MASSPEN:
            sReturn = "Mass Penguin";
            break;
        case SPELL_EPIC_MORI:
            sReturn = "Momento Mori";
            break;
        case SPELL_EPIC_MUMDUST:
            sReturn = "Mummy Dust";
            break;
        case SPELL_EPIC_NAILSKY:
            sReturn = "Nailed to the Sky";
            break;
        case SPELL_EPIC_NIGHTSU:
            sReturn = "Night's Undoing";
            break;
        case SPELL_EPIC_ORDER_R:
            sReturn = "Order Restored";
            break;
        case SPELL_EPIC_PATHS_B:
            sReturn = "Paths Become Known";
            break;
        case SPELL_EPIC_PEERPEN:
            sReturn = "Peerless Penitence";
            break;
        case SPELL_EPIC_PESTIL:
            sReturn = "Pestilence";
            break;
        case SPELL_EPIC_PIOUS_P:
            sReturn = "Pious Parley";
            break;
        case SPELL_EPIC_PLANCEL:
            sReturn = "Planar Cell";
            break;
        case SPELL_EPIC_PSION_S:
            sReturn = "Psionic Salvo";
            break;
        case SPELL_EPIC_RAINFIR:
            sReturn = "Rain of Fire";
            break;
        case SPELL_EPIC_RISEN_R:
            sReturn = "Risen Reunited";
            break;
        case SPELL_EPIC_RUINN://nonstandard
            sReturn = "Ruin";
            break;
        case SPELL_EPIC_SINGSUN:
            sReturn = "Singular Sunder";
            break;
        case SPELL_EPIC_SP_WORM:
            sReturn = "Spell Worm";
            break;
        case SPELL_EPIC_STORM_M:
            sReturn = "Storm Mantle";
            break;
        case SPELL_EPIC_SUMABER:
            sReturn = "Summon Aberration";
            break;
        case SPELL_EPIC_SUP_DIS:
            sReturn = "Superb Dispelling";
            break;
        case SPELL_EPIC_SYMRUST:
            sReturn = "Symrustar's Spellbinding";
            break;
        case SPELL_EPIC_THEWITH:
            sReturn = "The Withering";
            break;
        case SPELL_EPIC_TOLO_KW:
            sReturn = "Tolodine's Killing Wind";
            break;
        case SPELL_EPIC_TRANVIT:
            sReturn = "Transcendent Vitality";
            break;
        case SPELL_EPIC_TWINF:
            sReturn = "Twinfiend";
            break;
        case SPELL_EPIC_UNHOLYD:
            sReturn = "Unholy Disciple";
            break;
        case SPELL_EPIC_UNIMPIN:
            sReturn = "Unimpinged";
            break;
        case SPELL_EPIC_UNSEENW:
            sReturn = "Unseen Wanderer";
            break;
        case SPELL_EPIC_WHIP_SH:
            sReturn = "Whip of Shar";
            break;
    }
    return sReturn;
}

// Test main
void main(){}
