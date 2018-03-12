#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_inc_clsfunc"

void main()
{

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();

   string SpellN;
   int iLevel=GetLevelByClass(CLASS_TYPE_SHADOWLORD,OBJECT_SELF);

    if(nSpell == SHADOWLORD_BLINDNESS)
    {
        SpellN = "tfshad_blindness";
        if (!CanCastSpell(1,ABILITY_INTELLIGENCE,1)) return;

    }
    else if (nSpell == SHADOWLORD_DARKNESS)
    {
        SpellN = "tfshad_darkness";
        if (!CanCastSpell(1,ABILITY_INTELLIGENCE,1)) return;
    }
    else if (nSpell == SHADOWLORD_INVISIBILITY)
    {
        SpellN = "tfshad_invis";
        if (!CanCastSpell(1,ABILITY_INTELLIGENCE,1)) return;
    }
    else if(nSpell == SHADOWLORD_HASTE)
    {
        SpellN = "tfshad_haste";
        if (!CanCastSpell(2,ABILITY_INTELLIGENCE,1)) return;
    }
    else if (nSpell == SHADOWLORD_IMPROVINVIS)
    {
        SpellN = "tfshad_imprinvis";
        if (!CanCastSpell(2,ABILITY_INTELLIGENCE,1)) return;
    }
    else if (nSpell == SHADOWLORD_VAMPITOUCH)
    {
        SpellN = "tfshad_vamptch";
        if (!CanCastSpell(2,ABILITY_INTELLIGENCE,1)) return;
    }
    else if (nSpell == SHADOWLORD_CONFUSION)
    {
        SpellN = "tfshad_confusion";
        if (!CanCastSpell(3,ABILITY_INTELLIGENCE,1)) return;
    }
    else if (nSpell == SHADOWLORD_INVISPHERE)
    {
        SpellN = "tfshad_invsph";
        if (!CanCastSpell(3,ABILITY_INTELLIGENCE,1)) return;
    }
    ExecuteScript(SpellN,OBJECT_SELF);
}

