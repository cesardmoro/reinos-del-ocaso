void efectoen(object oCriatura, effect eEff, string sID)
{
int iHD = 0;
if(GetEffectCreator(eEff) != OBJECT_INVALID)
{
if(GetIsPC(GetEffectCreator(eEff)))
{
iHD = GetHitDice(GetEffectCreator(eEff));
}
if(!(GetIsPC(GetEffectCreator(eEff))) && (GetEffectCreator(eEff) != OBJECT_INVALID))
{
iHD = 1;
}
if(!(GetIsPC(GetEffectCreator(eEff))) && (GetEffectCreator(eEff) != OBJECT_INVALID) && (GetMaster(GetEffectCreator(eEff)) != OBJECT_INVALID))
{
iHD = GetHitDice(GetMaster(GetEffectCreator(eEff)));
}
}

if(GetHitDice(GetEffectCreator(eEff)) == 0)
{
iHD = 45;
}

        if(GetLocalInt(oCriatura, "HD"+sID) < iHD)
        {
        SetLocalInt(oCriatura, "HD"+sID, iHD);
        }
}
void efectoen2(object oCriatura2, object oCriatura, effect eEff, string sID)
{

       if(  GetEffectType(eEff) != EFFECT_TYPE_ABILITY_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_AC_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_ATTACK_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_DAMAGE_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_SAVING_THROW_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_SPELL_RESISTANCE_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_SKILL_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_BLINDNESS &&
            GetEffectType(eEff) != EFFECT_TYPE_DEAF &&
            GetEffectType(eEff) != EFFECT_TYPE_CURSE &&
            GetEffectType(eEff) != EFFECT_TYPE_DISEASE &&
            GetEffectType(eEff) != EFFECT_TYPE_POISON &&
            GetEffectType(eEff) != EFFECT_TYPE_PARALYZE &&
            GetEffectType(eEff) != EFFECT_TYPE_CHARMED &&
            GetEffectType(eEff) != EFFECT_TYPE_DOMINATED &&
            GetEffectType(eEff) != EFFECT_TYPE_DAZED &&
            GetEffectType(eEff) != EFFECT_TYPE_CONFUSED &&
            GetEffectType(eEff) != EFFECT_TYPE_FRIGHTENED &&
            GetEffectType(eEff) != EFFECT_TYPE_NEGATIVELEVEL &&
            GetEffectType(eEff) != EFFECT_TYPE_PARALYZE &&
            GetEffectType(eEff) != EFFECT_TYPE_SLOW &&
            GetEffectType(eEff) != EFFECT_TYPE_CUTSCENE_PARALYZE &&
            GetEffectType(eEff) != EFFECT_TYPE_CUTSCENEGHOST &&
            GetEffectType(eEff) != EFFECT_TYPE_CUTSCENEIMMOBILIZE &&
            GetEffectType(eEff) != EFFECT_TYPE_MISS_CHANCE &&
            GetEffectType(eEff) != EFFECT_TYPE_MOVEMENT_SPEED_DECREASE &&
            GetEffectType(eEff) != EFFECT_TYPE_PETRIFY &&
            GetEffectType(eEff) != EFFECT_TYPE_POLYMORPH &&
            GetEffectType(eEff) != EFFECT_TYPE_ARCANE_SPELL_FAILURE &&
            GetEffectType(eEff) != EFFECT_TYPE_SILENCE &&
            GetEffectType(eEff) != EFFECT_TYPE_SLEEP &&
            GetEffectType(eEff) != EFFECT_TYPE_SPELL_FAILURE &&
            GetEffectType(eEff) != EFFECT_TYPE_STUNNED)
            {
int iHD = 0;
if(GetEffectCreator(eEff) != OBJECT_INVALID)
{
if(GetIsPC(GetEffectCreator(eEff)))
{
iHD = GetHitDice(GetEffectCreator(eEff));
}
if(!(GetIsPC(GetEffectCreator(eEff))) && (GetEffectCreator(eEff) != OBJECT_INVALID))
{
iHD = 1;
}
if(!(GetIsPC(GetEffectCreator(eEff))) && (GetEffectCreator(eEff) != OBJECT_INVALID) && (GetMaster(GetEffectCreator(eEff)) != OBJECT_INVALID))
{
iHD = GetHitDice(GetMaster(GetEffectCreator(eEff)));
}
}


if(GetHitDice(GetEffectCreator(eEff)) == 0)
{
iHD = 45;
SendMessageToPC(oCriatura2, "Posees un efecto de una persona que no esta mas online esta criatura no te dara XP y el efecto sera removido");
//RemoveEffect(oCriatura2, eEff);
}

        if(GetLocalInt(oCriatura, "HD"+sID) < iHD)
        {
        SetLocalInt(oCriatura, "HD"+sID, iHD);
        }
}
}
void buscarparty(object oTarget2, object oDamager, string sID)
{
if((sID == IntToString(GetLocalInt(oTarget2, "party"))))
      {
      if(GetHitDice(oTarget2) > GetHitDice(oDamager))
      {
      SetLocalInt(oDamager, "HD"+sID, GetHitDice(oTarget2));
      }
      }
}
void asignarXP(object oTarget)
{
   string sID = IntToString(GetLocalInt(oTarget, "party"));
   if(GetLocalInt(oTarget, "party") == 0)
        {
        sID = GetStringLeft(GetName(oTarget), 25);
        }
     if(GetMaster(oTarget) != OBJECT_INVALID)
     {

     sID = IntToString(GetLocalInt(GetMaster(oTarget), "party"));
     if(GetLocalInt(oTarget, "party") == 0)
        {
        sID = GetStringLeft(GetName(GetMaster(oTarget)), 25);
        }
     }
     float cCR = GetChallengeRating(OBJECT_SELF);
     int cCR2;
     if((cCR < 0.2) && (cCR > 0.0))
     {
     cCR2 = -3;
     }
      if((cCR < 0.4) && (cCR > 0.2))
     {
     cCR2 = -2;
     }
      if((cCR < 0.6) && (cCR > 0.4))
     {
     cCR2 = -1;
     }
     if((cCR < 0.8) && (cCR > 0.6))
     {
     cCR2 = 0;
     }
     if((cCR > 1.0))
     {
     cCR2 = FloatToInt(cCR);
     }
     int XP;
     int iSw = cCR2 - GetHitDice(oTarget);
    if(iSw > 5)
     {
     iSw = -5;
     }
     if(iSw < -5)
     {
    iSw = -5;
     }
     switch (iSw)
     {
     case -5:
     XP = 1;
     break;
     case -4:
     XP = 3;
     break;
     case -3:
     XP = 5;
     break;
     case -2:
     XP = 8;
     break;
     case -1:
     XP = 10;
     break;
     case 0:
     XP = 15;
     break;
     case 1:
     XP = 20;
     break;
     case 2:
     XP = 25;
     break;
     case 3:
     XP = 30;
     break;
     case 4:
     XP = 35;
     break;
     case 5:
     XP = 40;
     break;
     }
    if(GetLocalInt(OBJECT_SELF, "HD"+sID) == 45)
    {
    XP = 0;
    }
    if(GetIsPC(oTarget) && (GetLocalInt(OBJECT_SELF, "Dam"+sID) > 0))
    {
    SetCampaignInt("killcount", GetTag(OBJECT_SELF), GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget)+1 ,oTarget);
    int iSw2 = 0;
    if(GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget) > 30)
    {
    iSw2 = 1;
    }
    if(GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget) > 60)
    {
    iSw2 = 2;
    }
    if(GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget) > 90)
    {
    iSw2 = 3;
    }
    if(GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget) > 120)
    {
    iSw2 = 4;
    }
    float iDiv;
    int iFama = (FloatToInt(GetChallengeRating(OBJECT_SELF)) * FloatToInt(GetChallengeRating(OBJECT_SELF))) - ((GetCampaignInt("K&F", "Fama",oTarget)/10));
    switch (iSw2)
     {
     case 0:
     iDiv = 1.0;
     break;
     case 1:
     iDiv = 0.75;
     break;
     case 2:
     iDiv = 0.50;
     break;
     case 3:
     iDiv = 0.25;
     break;
     case 4:
     iDiv = 0.10;
     break;
     }
     float XPfinal = IntToFloat(XP)*iDiv;
     int XPF = FloatToInt(XPfinal);
    XPF =(((XPF*GetLocalInt(OBJECT_SELF, "Dam"+sID))/100) * GetHitDice(oTarget))/(GetLocalInt(OBJECT_SELF, "HD"+sID));
    if((GetCampaignInt("K&F", "Fama",oTarget)< 10000) && (iFama > 0))
    {
    SetCampaignInt("K&F", "Fama", GetCampaignInt("K&F", "Fama",oTarget) + ((iFama *GetLocalInt(OBJECT_SELF, "Dam"+sID))/100) ,oTarget);
    }
    if(GetLocalInt(OBJECT_SELF, "Dam"+sID) > 0)
    {
    GiveXPToCreature(oTarget, XPF);
    SendMessageToPC(oTarget, IntToString(GetCampaignInt("K&F", "Fama",oTarget))+" <- Fama Actual");
    SendMessageToPC(oTarget, IntToString(GetLocalInt(OBJECT_SELF, "Dam"+sID))+" % de Vida" );
    SendMessageToPC(oTarget, IntToString(GetLocalInt(OBJECT_SELF, "HD"+sID))+" <- Lv del maximo interventor");
    SendMessageToPC(oTarget, IntToString(GetCampaignInt("killcount", GetTag(OBJECT_SELF),oTarget))+"<- Canitidad de veces que mato a esta criatura" );
    }
    }
}
