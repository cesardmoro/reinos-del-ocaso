//Include file for the purple worm AI.
//uses PWDetermineCombatRound to handle swallowing and movement.

int GrappleCheck(object oFalse,object oTrue=OBJECT_SELF)
{
    int nPWStr = GetAbilityModifier(ABILITY_STRENGTH,oTrue);
    int nSWStr = GetAbilityModifier(ABILITY_STRENGTH,oFalse);

    if((nPWStr+d20())>(nSWStr+d20()))
        return TRUE;
    else
        return FALSE;
}

void DigestionDamage(object oPC)
{
    string sMsg;
    if(!GetIsObjectValid(GetLocalObject(oPC,"PW_INSIDE")))
        return;

    if(GetLocalInt(oPC,"PW_CLIMBINGOUT")==TRUE)
    {
        //if they manage to climb out they don't get injured.
        if(!GrappleCheck(oPC))
        {
            sMsg = "You manage to climb up into the worms mouth...";
            if(!GrappleCheck(oPC))
            {
                sMsg = sMsg + "...and jump out!";

                object oWorm = GetLocalObject(oPC,"PW_INSIDE");
                location lTo = GetLocation(oWorm);
                if(GetAreaFromLocation(lTo)==GetObjectByTag("PWUnderground"))
                {
                    lTo = GetLocalLocation(oWorm,"PW_FROM");

                }
                AssignCommand(oPC,ClearAllActions());
                AssignCommand(oPC,JumpToLocation(lTo));
                SendMessageToPC(oPC,sMsg);
                return;
            }
            else
            {
                sMsg = sMsg + "...but slide back down";
            }
        }
        else
        {
            sMsg = sMsg + "Your struggling is fruitless and you remain in it's stomach";
        }
    }
    SendMessageToPC(oPC,"The worms powerful digestion muscles crush you");
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d8(2)+12,DAMAGE_TYPE_BLUDGEONING),oPC);
    SendMessageToPC(oPC,"The worms powerful digestion acid burns you");
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d8(),DAMAGE_TYPE_ACID),oPC);
    SendMessageToPC(oPC,sMsg);
    DelayCommand(6.0,DigestionDamage(oPC));
}

void PWBurrowToTarget(object oTarget)
{
    location lPWFrom  = GetLocalLocation(OBJECT_SELF,"PW_FROM");
    DeleteLocalLocation(OBJECT_SELF,"PW_FROM");
    if(GetLocalInt(OBJECT_SELF,"PW_BURROWING")!=TRUE)
        return;

    if(GetLocalInt(OBJECT_SELF,"PW_SURFACING")==TRUE)
        return;

    if(GetIsDead(OBJECT_SELF))
        return;

    if(GetIsObjectValid(oTarget))
    {
        ClearAllActions();
        ActionJumpToLocation(GetLocation(oTarget));
    }
    else
    {
        //No one to attack
        ClearAllActions();
        ActionJumpToLocation(lPWFrom);
    }

    SetLocalInt(OBJECT_SELF,"PW_SURFACING",TRUE);

}

void PWSwallow(object oSwallowee)
{
    //does this worm have any space left in it's stomach?
    int nSpace = GetLocalInt(OBJECT_SELF,"PW_SPACE");
    //1 = a tiny creature, 2 = a small one.
    //4 = a large one (or normal)
    int nSize;

    if(GetCreatureSize(oSwallowee)==CREATURE_SIZE_TINY)
        nSize = 1;
    else if(GetCreatureSize(oSwallowee)==CREATURE_SIZE_SMALL)
        nSize = 2;
    else if(GetCreatureSize(oSwallowee)==CREATURE_SIZE_MEDIUM)
        nSize = 4;
    else if(GetCreatureSize(oSwallowee)==CREATURE_SIZE_LARGE)
        nSize = 4;
    else
        nSize=16;
    if(nSpace+nSize>=8)
        return;


    if(GrappleCheck(oSwallowee))
    {
        //they have been swallowed
        SendMessageToPC(oSwallowee,"As the worm attacks it opens it's mouth and swallow you whole!");

        object oPC;
        int nN=1;

        oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nN);

        while(GetIsObjectValid(oPC))
        {
            if(GetObjectSeen(oSwallowee,oPC))
            {
                SendMessageToPC(oSwallowee,"As the worm attacks "+GetName(oSwallowee)+" it opens it's mouth and swallows them whole!");
            }
            nN++;
            oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, nN);
        }

        //teleport the player to the stomach, the area enter events do the rest.
        SetLocalObject(oSwallowee,"PW_INSIDE",OBJECT_SELF);
        AssignCommand(oSwallowee,ClearAllActions());
        AssignCommand(oSwallowee,JumpToLocation(GetLocation(GetWaypointByTag("PWInside"))));
    }
    else
    {
        //wasn't swallowed
        SendMessageToPC(oSwallowee,"You avoid being swallowed by the worm");
    }

}

void PWDetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10)
{
    if(GetLocalInt(OBJECT_SELF,"PW_BURROWING")==TRUE)
        return;

    object oNearest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    if(GetIsObjectValid(oIntruder) || GetIsObjectValid(oNearest))
    {
        if(!GetIsObjectValid(oIntruder) || GetArea(oIntruder) != GetArea(OBJECT_SELF) || GetPlotFlag(OBJECT_SELF) == TRUE)
        {
            oIntruder = GetAttemptedAttackTarget();
        }

        //oIntruder now contains the person we want to attack

        float nDist = GetDistanceToObject(oIntruder);

        if((nDist==-1.0)||(nDist>5.0))
        {
            //The target wasn't close enough.  pick another one and move there
            nDist = GetDistanceToObject(oNearest);
            if((nDist==-1.0)||(nDist>5.0))
            {
                //ok, the nearest creature has either gone (??)  of isn't very close
                //We're going to have to jump to someone.
                //do the burrow thing
                SetLocalLocation(OBJECT_SELF,"PW_FROM",GetLocation(OBJECT_SELF));
               //This is crap, I'm sorry
                //It should go for the largest concentration
                //But the only way I can think of to do that
                //Is to do a lot of sin and cos functions
                //Which is expensive.
                int nN = d8()+1;
                object oNearest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, nN, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                while((!GetIsObjectValid(oNearest))&&(nN>1))
                {
                    nN--;
                    oNearest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, nN, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                }
                if(!GetIsObjectValid(oNearest))
                    return;

                SetLocalInt(OBJECT_SELF,"PW_BURROWING",TRUE);
                SetLocalObject(OBJECT_SELF,"PW_TARGET",oNearest);
                SetPlotFlag(OBJECT_SELF,TRUE);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectDisappearAppear(GetLocation(GetWaypointByTag("PWUnderground"))),OBJECT_SELF,4.0);
                ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(OBJECT_SELF));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectDisappearAppear(GetLocation(GetWaypointByTag("PWUnderground"))),OBJECT_SELF,4.0);
                return;
            }
            else
                oIntruder = oNearest;
        }

        //now we attack, and we do the swallow thing
        ClearAllActions();
        ActionAttack(oIntruder);
        SetLocalInt(OBJECT_SELF,"PW_DAMAGE",GetCurrentHitPoints(oIntruder));
        return;
    }
    ClearAllActions();
    SetLocalObject(OBJECT_SELF, "NW_GENERIC_LAST_ATTACK_TARGET", OBJECT_INVALID);
}

void ResetBurrowing()
{
    DeleteLocalInt(OBJECT_SELF,"PW_BURROWING");
    DeleteLocalInt(OBJECT_SELF,"PW_SURFACING");
    DeleteLocalInt(OBJECT_SELF,"PW_SURFACED");
    SetPlotFlag(OBJECT_SELF,FALSE);
    PWDetermineCombatRound();
}

