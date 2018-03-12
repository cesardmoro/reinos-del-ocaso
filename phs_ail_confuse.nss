/*:://////////////////////////////////////////////
//:: Name Spell Confusion Heartbeat script
//:: FileName phs_ail_confuse
//:://////////////////////////////////////////////
    This runs on a creature when they have the effect:

    // Create a Confuse effect
    effect EffectConfused()

    On them.

    This will randomly do an action according to the 3.5 rules:

    - Taken from the Confusion Spell description.

    This spell causes the targets to become confused, making them unable to
    independently determine what they will do.

    Roll on the following table at the beginning of each subject’s turn each
    round to see what the subject does in that round.

    d%      Behavior
    01-10   Attack caster with melee or ranged weapons (or close with caster if
            attack is not possible).
    11-20   Act normally.
    21-50   Do nothing but babble incoherently.
    51-70   Flee away from caster at top possible speed.
    71-100  Attack nearest creature (for this purpose, a familiar counts as part
            of the subject’s self).

    A confused character who can’t carry out the indicated action does nothing
    but babble incoherently. Attackers are not at any special advantage when
    attacking a confused character. Any confused character who is attacked
    automatically attacks its attackers on its next turn, as long as it is still
    confused when its turn comes. Note that a confused character will not make
    attacks of opportunity against any creature that it is not already devoted
    to attacking (either because of its most recent action or because it has just
    been attacked).

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// Returns the first caster of confusion (if a valid creature object)
object GetConfusionCreator(object oTarget);

// Babble incoherantly!
void Babble();

void main()
{
    //Make sure the creature is commandable for the round
    SetCommandable(TRUE);
    //Clear all previous actions.
    ClearAllActions();

    // Table roll is a d100
    int nRandom = d100();
    int iCnt;
    object oTarget, oFamiliar;

    // What do we do?

    // 01-10 Attack caster with melee or ranged weapons (or close with caster if
    // attack is not possible).
    if(nRandom <= 10)
    {
        // Get our confusion creator!
        oTarget = GetConfusionCreator(OBJECT_SELF);
        if(GetIsObjectValid(oTarget))
        {
            // Range check to use bow
            if(GetDistanceToObject(oTarget) >= 5.0)
            {
                // Equip a ranged weapon
                ActionEquipMostDamagingRanged();
            }
            else
            {
                // Equip a melee weapon
                ActionEquipMostDamagingMelee();
            }
            ActionAttack(oTarget);
        }
        else
        // A confused character who can’t carry out the indicated action does nothing
        // but babble incoherently.
        {
            Babble();
        }
    }
    // 11-20   Act normally.
    // We let them act normally - with no more SetUncommandable.
    else if(nRandom <= 20)
    {
        SendMessageToPC(OBJECT_SELF, "You suddenly feel a short amount of freedom from your confusion!");
        return;
    }
    // 21-50 Do nothing but babble incoherently.
    else if(nRandom <= 50)
    {
        Babble();
    }
    // 51-70 Flee away from caster at top possible speed.
    else if(nRandom <= 70)
    {
        // Get our confusion creator!
        oTarget = GetConfusionCreator(OBJECT_SELF);
        if(GetIsObjectValid(oTarget))
        {
            // Run from them
            ActionMoveAwayFromObject(oTarget, TRUE, 100.0);
        }
        else
        // A confused character who can’t carry out the indicated action does nothing
        // but babble incoherently.
        {
            Babble();
        }
    }
    // 71-100 Attack nearest creature (for this purpose, a familiar counts as part
    //        of the subject’s self).
    else
    {
        iCnt = 1;
        // We don't ever attack familiars, ourself
        oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, iCnt);
        while(GetIsObjectValid(oTarget))
        {
            // Stop if it is not a familiar (our own)
            if(oTarget != oFamiliar)
            {
                break;
            }
            iCnt++;
            oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
        }
        // Check target validness
        if(GetIsObjectValid(oTarget))
        {
            // Range check to use bow
            if(GetDistanceToObject(oTarget) >= 5.0)
            {
                // Equip a ranged weapon
                ActionEquipMostDamagingRanged();
            }
            else
            {
                // Equip a melee weapon
                ActionEquipMostDamagingMelee();
            }
            ActionAttack(oTarget);
        }
        else
        // A confused character who can’t carry out the indicated action does nothing
        // but babble incoherently.
        {
            Babble();
        }
    }
    SetCommandable(FALSE);
}

// Returns the first caster of confusion (if a valid creature object)
object GetConfusionCreator(object oTarget)
{
    object oCaster, oCreator;
    effect eCheck = GetFirstEffect(oTarget);
    int iCreatorType;

    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_CONFUSED)
        {
            oCreator = GetEffectCreator(eCheck);
            if(GetIsObjectValid(oCreator))
            {
                iCreatorType = GetObjectType(oCreator);
                if(iCreatorType == OBJECT_TYPE_CREATURE)
                {
                    oCaster = oCreator;
                    break;
                }
                else if(iCreatorType == OBJECT_TYPE_AREA_OF_EFFECT)
                {
                    oCaster = GetAreaOfEffectCreator(oCreator);
                    break;
                }

            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return oCaster;
}

// Babble incoherantly!
void Babble()
{
    // Do we do babbling? Only humanoid + PC races will, other will not.
    int nRacial = GetRacialType(OBJECT_SELF);
    // Check race
    switch(nRacial)
    {
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        {
            // Some nice random speak :-)
            switch (d20())
            {
                case(1):{ SpeakString("*blurbleyla!*");} break;
                case(2):{ SpeakString("*Jiapa!*");} break;
                case(3):{ SpeakString("*Duhhhhhh*");} break;
                case(4):{ SpeakString("*Weeeeee!*");} break;
                case(5):{ SpeakString("*oopsalbongo!*");} break;
                case(6):{ SpeakString("*yeee!*");} break;
                case(7):{ SpeakString("*...*");} break;
                case(8):{ SpeakString("*paaannnddaaaa*");} break;
                case(9):{ SpeakString("*Whatcadomatey?*");} break;
                case(10):{ SpeakString("*Memememe!*");} break;
                default:{ SpeakString("*babbles incoherently*");} break;
            }
        }
        default:
        {
            SpeakString("*babbles incoherently*");
        }
        break;
    }
}
