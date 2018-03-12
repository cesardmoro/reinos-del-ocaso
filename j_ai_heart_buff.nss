/************************ [On Heartbeat - Buff] ********************************
    Filename: j_ai_heart_buff
************************* [On Heartbeat - Buff] ********************************
    This is ExecuteScript'ed from the heartbeat file, if they want to buff
    themselves with spells to be prepared for any battle coming up.
************************* [History] ********************************************
    1.3 - Added
************************* [Workings] *******************************************
    This contains Advance Buffing - IE quick protection spells.
    I've done what ones I think are useful - IE most protection ones & summons!
    This doesn't include any which are very short duration:

    Elemntal shield/Wounding whispers (though you can add all of these!)
    Aid, bless, aura of vitality, aura of glory, blood frenzy, prayer,
    divine* Range (Power, Might, Shield, Favor), Expeditious retreat,
    holy/unholy aura (or protection from /magic circle against),
    natures balance, one with the land, shield of faith, virtue, war cry.
************************* [Arguments] ******************************************
    Arguments: N/A
************************* [On Heartbeat - Buff] *******************************/

#include "j_inc_generic_ai"

// Wrapper, to stop repeating the same lines! :-)
int BuffCastSpell(int iSpell);
// haste bug. remove all haste item and reequipment.
void UnEquipAndReEquip(int nSlot);

//
void FastBuff_CastAllyBuffSpell();
//
void FastBuff_CheckAndCast(object oAlly,int iSpellToUse1, int iSpellToUse2 = -1, int iSpellToUse3 = -1, int iSpellToUse4 = -1, int iSpellOther1 = -1, int iSpellOther2 = -1, int iEffect = FALSE, int iSpellEffect = FALSE);


void main()
{
    if(GetLocalInt(OBJECT_SELF,"DEADMAGIC_SPELLFAILURE")) return;

    // For summons counter.
    int nCnt, iBreak;
    // FAST BUFF SELF
    // Stop what we are doing first, to perform the actions.
    ClearAllActions();

    //Combat Protections
    if(!BuffCastSpell(SPELL_PREMONITION))
        if(!BuffCastSpell(SPELL_GREATER_STONESKIN))
            BuffCastSpell(SPELL_STONESKIN);

    //Visage Protections
    if(!BuffCastSpell(SPELL_SHADOW_SHIELD))
        if(!BuffCastSpell(SPELL_ETHEREAL_VISAGE))
            BuffCastSpell(SPELL_GHOSTLY_VISAGE);

    //Mantle Protections
    if(!BuffCastSpell(SPELL_GREATER_SPELL_MANTLE))
        if(!BuffCastSpell(SPELL_SPELL_MANTLE))
            BuffCastSpell(SPELL_LESSER_SPELL_MANTLE);

    // True seeing, see invisibility. We take true seeing to be better then the latter.
    if(BuffCastSpell(SPELL_TRUE_SEEING))
        BuffCastSpell(SPELL_SEE_INVISIBILITY);

    //Elemental Protections. 4 lots. From 40/- to 10/-
    if(!BuffCastSpell(SPELL_ENERGY_BUFFER))
        if(!BuffCastSpell(SPELL_PROTECTION_FROM_ELEMENTS))
            if(!BuffCastSpell(SPELL_RESIST_ELEMENTS))
                BuffCastSpell(SPELL_ENDURE_ELEMENTS);

    //Mental Protections
    if(!BuffCastSpell(SPELL_MIND_BLANK))
        if(!BuffCastSpell(SPELL_LESSER_MIND_BLANK))
            BuffCastSpell(SPELL_CLARITY);

    // Globes
    if(!BuffCastSpell(SPELL_GLOBE_OF_INVULNERABILITY))
        BuffCastSpell(SPELL_MINOR_GLOBE_OF_INVULNERABILITY);

    //Invisibility
    // Note: Improved has 50% consealment, etherealness has just invisiblity.
    if(!BuffCastSpell(SPELL_IMPROVED_INVISIBILITY))
        BuffCastSpell(SPELL_DISPLACEMENT);//50% consealment
    if(!BuffCastSpell(SPELL_ETHEREALNESS))
        if(!BuffCastSpell(SPELL_INVISIBILITY_SPHERE))
            if(!BuffCastSpell(SPELL_INVISIBILITY))
                BuffCastSpell(SPELL_SANCTUARY);

    // The stat-increasing ones.
    if(GetHasSpell(SPELL_AURAOFGLORY))
    {
        ActionCastSpellAtObject(SPELL_AURAOFGLORY, OBJECT_SELF,METAMAGIC_ANY,TRUE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
        DecrementRemainingSpellUses(OBJECT_SELF,SPELL_AURAOFGLORY);
    }
    if(!BuffCastSpell(SPELL_GREATER_BULLS_STRENGTH))
        BuffCastSpell(SPELL_BULLS_STRENGTH);
    if(!BuffCastSpell(SPELL_GREATER_CATS_GRACE))
        BuffCastSpell(SPELL_CATS_GRACE);
    if(!BuffCastSpell(SPELL_GREATER_EAGLE_SPLENDOR))
        BuffCastSpell(SPELL_EAGLE_SPLEDOR);
    if(!BuffCastSpell(SPELL_GREATER_FOXS_CUNNING))
        BuffCastSpell(SPELL_FOXS_CUNNING);
    if(!BuffCastSpell(SPELL_GREATER_OWLS_WISDOM))
        BuffCastSpell(SPELL_OWLS_WISDOM);
    if(!BuffCastSpell(SPELL_GREATER_ENDURANCE))
        BuffCastSpell(SPELL_ENDURANCE);

    // Mage armor or shield. Don't stack them.
    if(!BuffCastSpell(SPELL_SHIELD))
        BuffCastSpell(SPELL_MAGE_ARMOR);
    // Protection from negative energy
    if(!BuffCastSpell(SPELL_UNDEATHS_ETERNAL_FOE))
        BuffCastSpell(SPELL_NEGATIVE_ENERGY_PROTECTION);

    BuffCastSpell(SPELL_DEATH_WARD);
    //Misc Protections which have no more powerful.
//  Low durations (Rounds per caster level)
//    if(!BuffCastSpell(SPELL_ELEMENTAL_SHIELD))
//        BuffCastSpell(SPELL_WOUNDING_WHISPERS);
    BuffCastSpell(SPELL_BARKSKIN);
    BuffCastSpell(SPELL_ENTROPIC_SHIELD);
    BuffCastSpell(SPELL_PROTECTION_FROM_SPELLS);
    BuffCastSpell(SPELL_REGENERATE);
    BuffCastSpell(SPELL_DARKVISION);
    BuffCastSpell(SPELL_REGENERATE);
    BuffCastSpell(SPELL_SPELL_RESISTANCE);
    BuffCastSpell(SPELL_FREEDOM_OF_MOVEMENT);


    //Summon Ally.
    // Spell ID's: These are quite odd. Spells.2da:
/*
    174        Summon_Creature_I    1
    175        Summon_Creature_II   2
    176        Summon_Creature_III  3
    177        Summon_Creature_IV   4
    178        Summon_Creature_IX   9
    179        Summon_Creature_V    5
    180        Summon_Creature_VI   6
    181        Summon_Creature_VII  7
    182        Summon_Creature_VIII 8
*/
    // We can loop through. 9 first, then 8-5, then undead ones, then 4-1
    if(!BuffCastSpell(SPELL_SUMMON_CREATURE_IX))// 9
    {
        // 8, 7, 6, 5.
        for(nCnt = SPELL_SUMMON_CREATURE_VIII;
           (nCnt >= SPELL_SUMMON_CREATURE_V && iBreak != TRUE);
            nCnt--)
        {
            if(BuffCastSpell(nCnt)) iBreak = TRUE;
        }
        // Then undead
        if(iBreak != TRUE)
        {
            if(!BuffCastSpell(SPELL_CREATE_GREATER_UNDEAD))
            {
                if(!BuffCastSpell(SPELL_CREATE_UNDEAD))
                {
                    if(!BuffCastSpell(SPELL_ANIMATE_DEAD))
                    {
                        // Lastly, the 4-1 ones.
                        for(nCnt = SPELL_SUMMON_CREATURE_IV;
                           (nCnt >= SPELL_SUMMON_CREATURE_I);
                            nCnt--)
                        {
                            if(BuffCastSpell(nCnt)) break;
                        }
                    }
                }
            }
        }
    }

    // haste bug. remove all haste item and reequipment.
    if(!GetIsInCombat())
    {
        UnEquipAndReEquip(INVENTORY_SLOT_HEAD);
    }

    DelayCommand(f1,FastBuff_CastAllyBuffSpell());

    // Finally, equip the best melee weapon to look more prepared.
    // Don't use a ranged, we can equip it manually if need be :=P
    // but sneak attackers would have a field day if we didn't have
    // a melee weapon out...
    ActionEquipMostDamagingMelee();
}

// Wrapper, to stop repeating the same lines! :-)
int BuffCastSpell(int iSpell)
{
    if(GetHasSpell(iSpell))
    {
        // paladin and ranger. too many deadlock.
        if(GetLevelByClass(CLASS_TYPE_PALADIN) || GetLevelByClass(CLASS_TYPE_RANGER))
        {
            ActionCastSpellAtObject(iSpell, OBJECT_SELF, METAMAGIC_ANY, TRUE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            DecrementRemainingSpellUses(OBJECT_SELF, iSpell);
        }
        else
        {
            ActionCastSpellAtObject(iSpell, OBJECT_SELF, METAMAGIC_ANY, FALSE, FALSE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        return TRUE;
    }
    return FALSE;
}

// haste bug. remove all haste ip item and reequipment.
void UnEquipAndReEquip(int nSlot)
{
    if(nSlot>INVENTORY_SLOT_CARMOUR)return;
    object oSlot=GetItemInSlot(nSlot);
    itemproperty ip;
    ip=GetFirstItemProperty(oSlot);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip)==ITEM_PROPERTY_HASTE)
        {
            ActionUnequipItem(oSlot);
            break;
        }
        ip=GetNextItemProperty(oSlot);
    }
    UnEquipAndReEquip(nSlot+1);
    ActionEquipItem(oSlot,nSlot);
    return;
}


void FastBuff_CastAllyBuffSpell()
{
    if(GetSpawnInCondition(AI_FLAG_OTHER_COMBAT_ONLY_SELF_BUFFING_SPELLS,AI_OTHER_COMBAT_MASTER)) return;

    ClearAllActions();

    AI_SetUpUsEffects();
    AI_SetUpUs();
    AI_SetUpAllObjects(OBJECT_INVALID);

    // Check buff ally is valid
    if(!GetIsObjectValid(GetLocalObject(OBJECT_SELF, ARRAY_ALLIES_RANGE_SEEN_BUFF + s1))) return;


    // Loop nearest to futhest allies
    int iCnt = i1;
    object oAlly = GetLocalObject(OBJECT_SELF, ARRAY_ALLIES_RANGE_SEEN_BUFF + IntToString(iCnt));
    // Loop Targets
    // - iCnt is our breaker. We only check 10 nearest allies, and set to 20 if break.
    while(GetIsObjectValid(oAlly) && iCnt <= i10 && GetDistanceToObject(oAlly)<=f10)
    {
        // Hastes! short but need;
        FastBuff_CheckAndCast(oAlly, SPELL_HASTE, SPELL_MASS_HASTE, iM1, iM1, iM1, iM1, GlobalEffectHaste, FALSE);
        // Death Ward if we can see an enemy spellcaster.
        FastBuff_CheckAndCast(oAlly, SPELL_DEATH_WARD);
        FastBuff_CheckAndCast(oAlly, SPELL_NEGATIVE_ENERGY_PROTECTION);
        // Anti Mental Spell
        FastBuff_CheckAndCast(oAlly, SPELL_LESSER_MIND_BLANK,SPELL_CLARITY,SPELL_PROTECTION_FROM_EVIL);
        // Try stoneskins as a main one. long.
        FastBuff_CheckAndCast(oAlly, SPELL_STONESKIN);
        // TRUE SEEING
        FastBuff_CheckAndCast(oAlly, SPELL_TRUE_SEEING,SPELL_DARKVISION,iM1,iM1,iM1,iM1,GlobalEffectTrueSeeing,FALSE);
        // Elemental protections. long.
        FastBuff_CheckAndCast(oAlly, SPELL_PROTECTION_FROM_ELEMENTS, SPELL_RESIST_ELEMENTS, SPELL_ENDURE_ELEMENTS);
        // Some AC protections. long;
        FastBuff_CheckAndCast(oAlly, SPELL_MAGE_ARMOR, SPELL_BARKSKIN);
        // Bulls Strength, Cats Grace, Endurance. long;
        FastBuff_CheckAndCast(oAlly, SPELL_ENDURANCE, SPELL_CATS_GRACE, SPELL_BULLS_STRENGTH, SPELL_GREATER_ENDURANCE, SPELL_GREATER_BULLS_STRENGTH, SPELL_GREATER_CATS_GRACE);
        // Bless, Aid. long;
        FastBuff_CheckAndCast(oAlly, SPELL_AID, SPELL_BLESS);
        // Consealment spells. long;
        FastBuff_CheckAndCast(oAlly, SPELL_IMPROVED_INVISIBILITY, SPELL_DISPLACEMENT);

        // Get Next ally
        iCnt++;
        oAlly = GetLocalObject(OBJECT_SELF, ARRAY_ALLIES_RANGE_SEEN_BUFF + IntToString(iCnt));
    }
}

void FastBuff_CheckAndCast(object oAlly,int iSpellToUse1, int iSpellToUse2 = -1, int iSpellToUse3 = -1, int iSpellToUse4 = -1, int iSpellOther1 = -1, int iSpellOther2 = -1, int iEffect = FALSE, int iSpellEffect = FALSE)
{
    // Check for thier effects
    if((!iEffect || !AI_GetAIHaveEffect(iEffect,oAlly)) && (!iSpellEffect || !AI_GetAIHaveSpellsEffect(iSpellEffect,oAlly)) &&
       (iSpellToUse1 == iM1 || !GetHasSpellEffect(iSpellToUse1, oAlly)) &&
       (iSpellToUse2 == iM1 || !GetHasSpellEffect(iSpellToUse2, oAlly)) &&
       (iSpellToUse3 == iM1 || !GetHasSpellEffect(iSpellToUse3, oAlly)) &&
       (iSpellToUse4 == iM1 || !GetHasSpellEffect(iSpellToUse4, oAlly)) &&
       (iSpellOther1 == iM1 || !GetHasSpellEffect(iSpellOther1, oAlly)) &&
       (iSpellOther2 == iM1 || !GetHasSpellEffect(iSpellOther2, oAlly)) &&
       !GetHasSpell(iSpellToUse1, oAlly) && !GetHasSpell(iSpellToUse2, oAlly) &&
       !GetHasSpell(iSpellToUse3, oAlly) && !GetHasSpell(iSpellToUse4, oAlly))
    {
        if(iSpellToUse1!=iM1 && GetHasSpell(iSpellToUse1))
        {
            ActionCastSpellAtObject(iSpellToUse1,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellToUse1);
        }
        else if(iSpellToUse2!=iM1 && GetHasSpell(iSpellToUse2))
        {
            ActionCastSpellAtObject(iSpellToUse2,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellToUse2);
        }
        else if(iSpellToUse3!=iM1 && GetHasSpell(iSpellToUse3))
        {
            ActionCastSpellAtObject(iSpellToUse3,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellToUse3);
        }
        else if(iSpellToUse4!=iM1 && GetHasSpell(iSpellToUse4))
        {
            ActionCastSpellAtObject(iSpellToUse4,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellToUse4);
        }
        else if(iSpellOther1!=iM1 && GetHasSpell(iSpellOther1))
        {
            ActionCastSpellAtObject(iSpellOther1,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellOther1);
        }
        else if(iSpellOther2!=iM1 && GetHasSpell(iSpellOther2))
        {
            ActionCastSpellAtObject(iSpellOther2,oAlly,METAMAGIC_ANY,FALSE,FALSE,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
//            DecrementRemainingSpellUses(OBJECT_SELF,iSpellOther2);
        }
    }
}
