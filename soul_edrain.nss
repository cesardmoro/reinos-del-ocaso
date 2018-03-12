#include "prc_alterations"
#include "inc_soul_shift"

void DeathDelay(object oTarget, string sTarget, string sName);

void DoEnergyDrain(object oTarget,int nDamage)
{

    if (GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
    {
        SendMessageToPC(OBJECT_SELF, "Cannot drain " + GetName(oTarget) +" is immune.");
    }
    else if (GetIsDead(oTarget))
    {
        SendMessageToPC(OBJECT_SELF, "Cannot drain: " + GetName(oTarget) +" is dead.");
    }
    else if (oTarget == OBJECT_SELF)
    {
        SendMessageToPC(OBJECT_SELF, "Cannot drain yourself.");
    }
    else
    {
        int nLevelMod = GetLocalInt(oTarget, "TargetLevel");
        nLevelMod = nLevelMod - nDamage;
        effect eDrain = EffectNegativeLevel(nDamage);
        eDrain = ExtraordinaryEffect(eDrain);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDrain,oTarget);
        SetLocalInt(oTarget, "TargetLevel", nLevelMod);

        //SendMessageToPC(OBJECT_SELF,"You have drained "+ IntToString(nDamage) +
        //    " from " + GetName(oTarget) + ", It has " +
        //     IntToString(GetLocalInt(oTarget, "TargetLevel")) + " levels left.");


        // Soul Strength

        if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 2)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectAbilityIncrease(ABILITY_STRENGTH, 4), OBJECT_SELF,
                HoursToSeconds(24));
            }

        // Soul Endurance

        if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 5)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectAbilityIncrease(ABILITY_CONSTITUTION, 4), OBJECT_SELF,
                HoursToSeconds(24));
            }

        // Soul Agililty

        if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 8)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectAbilityIncrease(ABILITY_DEXTERITY, 4), OBJECT_SELF,
                HoursToSeconds(24));
            }

        // Soul Enchancement

        if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) >= 4)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectSavingThrowIncrease(SAVING_THROW_TYPE_ALL, 2), OBJECT_SELF,
                HoursToSeconds(24));

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectSkillIncrease(SKILL_ALL_SKILLS, 2), OBJECT_SELF,
                HoursToSeconds(24));
            }
            string sTarget = GetResRef(oTarget);
        string sName = GetName(oTarget);
            DelayCommand(0.5, DeathDelay(oTarget, sTarget, sName));
    }
}

void LevelUpWight(int nLevel, object oCreature)
{
    int n;
    for(n=1;n<nLevel;n++)
    {
        LevelUpHenchman(oCreature, CLASS_TYPE_INVALID, TRUE);
        //FloatingTextStringOnCreature("Leveled up Henchmen", OBJECT_SELF, FALSE);
    }
}

// This function is here because the commands in it need to be delayed for GetIsDead to return true.
void DeathDelay(object oTarget, string sTarget, string sName)
{

    if (GetIsDead(oTarget)) RecognizeCreature(OBJECT_SELF, sTarget, sName);

    // Soul Slave Feat
    if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) > 8)
    {
        if (DEBUG) FloatingTextStringOnCreature("Class level is greater than 8", OBJECT_SELF, FALSE);
        // Make sure its dead before raising it as a henchman
        if (GetIsDead(oTarget))
        {
            //FloatingTextStringOnCreature("Target is Dead", OBJECT_SELF, FALSE);

                int nMax = GetMaxHenchmen();
                int i = 1;
                object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
                effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

                // Count the number of henchmen
                while (GetIsObjectValid(oHench))
                {
                    i += 1;
                    oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);
                }
                //FloatingTextStringOnCreature("Henchmen total: " + IntToString(i), OBJECT_SELF, FALSE);

            // Cap the number of henchies he can have at 4
                if (4 >= i) SetMaxHenchmen(nMax + 4);

            object oCreature = CreateObject(OBJECT_TYPE_CREATURE, "soul_wight_test", PRCGetSpellTargetLocation());
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, PRCGetSpellTargetLocation());

            AddHenchman(OBJECT_SELF, oCreature);
            int nTargetLevelUp = GetHitDice(OBJECT_SELF) - 3;

            // Needs to be delayed because it was firing before creature spawned
            DelayCommand(1.0, LevelUpWight(nTargetLevelUp, oCreature));
            // Reset henchmen to the module max
            SetMaxHenchmen(nMax);
        }
    }
}

void main()
{


    object oTarget = PRCGetSpellTargetObject();
    string sTarget = GetResRef(oTarget);
    string sName = GetName(oTarget);
    int nDamage = 1;
    int nBaseLevel = GetLevelByPosition(1, oTarget) + GetLevelByPosition(2, oTarget)
                        + GetLevelByPosition(3, oTarget);

    effect eBlood = EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE);



    if (!GetLocalInt(oTarget, "TargetLevel"))
    {
        SetLocalInt(oTarget, "TargetLevel", nBaseLevel);
    }

    int nLevel = GetLocalInt(oTarget, "TargetLevel");



    if (GetLevelByClass(CLASS_TYPE_SOUL_EATER, OBJECT_SELF) < 7)
    {
        nDamage = 1;
    }
    else
    {
        nDamage = 2;
    }


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));


    // Do a melee touch attack.
    int bHit = (TouchAttackMelee(oTarget,TRUE)>0) ;
    if (!bHit)
    {
        return;
    }

    // Only apply the VFX if you hit
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eBlood, oTarget);
    DoEnergyDrain(oTarget, nDamage);
}
