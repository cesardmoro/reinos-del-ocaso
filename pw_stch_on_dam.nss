void main()
{
    object oPC = GetLastDamager();
    //if the pc isn't using a small weapon, then he didn't damage it.
    object oWeapon = GetLastWeaponUsed(oPC);

    if(GetIsObjectValid(oWeapon))
    {
        int nType =GetBaseItemType(oWeapon);
        if((nType==BASE_ITEM_CSLASHWEAPON)||(nType==BASE_ITEM_CSLSHPRCWEAP)||(nType==BASE_ITEM_KAMA)||(nType==BASE_ITEM_HANDAXE)||(nType==BASE_ITEM_SICKLE))
        {
            object oWorm = GetLocalObject(oPC,"PW_INSIDE");
            int nDamage = GetLocalInt(oPC,"PW_DAMAGEDEALT");
            int nDam =GetTotalDamageDealt();
            nDamage += nDam;
            SetLocalInt(oPC,"PW_DAMAGEDEALT",nDamage);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(nDam,DAMAGE_TYPE_SLASHING),oWorm);
            if(nDamage>=25)
            {
               //escape
                //Teleport player to the place the worm is.
                location lTo = GetLocation(oWorm);
                AssignCommand(oPC,ClearAllActions());
                AssignCommand(oPC,JumpToLocation(lTo));
                SendMessageToPC(oPC,"You slash your way out of the worm, but muscle contractions close the way behind you");
            }
        }
        else
        {
            SendMessageToPC(oPC,"There is not enough space to swing that weapon effectively");
        }

    }
    else
    {
        SendMessageToPC(oPC,"There is not enough space to do that effectively");
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(1000),OBJECT_SELF);
}
