void deactivar(object oTriger)
{
    if(GetLocalInt(GetArea(OBJECT_SELF), "numero") == 0)
    {
        SetLocalInt(OBJECT_SELF, "dif", 0);
        if(!(GetStandardFactionReputation(STANDARD_FACTION_COMMONER, oTriger) == 100))
        {
            if(!(GetStandardFactionReputation(STANDARD_FACTION_DEFENDER, oTriger) == 100))
            {
                if(!(GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oTriger) == 100))
                {
                    if(GetObjectType(oTriger) == OBJECT_TYPE_CREATURE)
                    {


                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTriger);
                    }

                    if(GetName(oTriger) != "")
                    {
                        if(GetHasInventory(oTriger)== TRUE && (GetObjectType(oTriger) != OBJECT_TYPE_STORE) && (GetLocalInt(GetArea(OBJECT_SELF), "Cr") != 0))
                        {
                            TakeGoldFromCreature(GetGold(oTriger), oTriger, TRUE);
                            object oPri = GetFirstItemInInventory(oTriger);
                            while(oPri != OBJECT_INVALID)
                            {
                                DestroyObject(oPri, 0.0);
                                oPri = GetNextItemInInventory(oTriger);
                            }

                            DestroyObject(oTriger, 0.1);
                        }


                    }
                }
            }
        }
    }
}
