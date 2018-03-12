void main()
{
    int iUD = GetUserDefinedEventNumber();
    int iRandom = Random(9)+1;
    int iRandom2 = Random(9)+1;
    int iRandom3 = Random(9)+1;
    float iRandom4 = IntToFloat(Random(20)+6);
    string sRandom = IntToString(iRandom);
    string sRandom2 = IntToString(iRandom2);
    string sRandom3 = IntToString(iRandom3);

    object oGoblinSpawn = GetNearestObjectByTag("Orcos1");
    object oGoblinSpawn2 = GetNearestObjectByTag("Orcos3");
    object oGoblinSpawn3 = GetNearestObjectByTag("Orcos5");
    location lSpawn = GetLocation(oGoblinSpawn);
    location lSpawn2 = GetLocation(oGoblinSpawn2);
    location lSpawn3 = GetLocation(oGoblinSpawn3);
    object oOrco = CreateObject(OBJECT_TYPE_CREATURE, "orco"+sRandom, lSpawn);
    AssignCommand(oOrco, ActionForceMoveToLocation(GetLocation(GetNearestObjectByTag("Orcos2")), TRUE, 10.0));
    object oOrco2 = CreateObject(OBJECT_TYPE_CREATURE, "orco"+sRandom2, lSpawn2);
    DelayCommand(0.2, AssignCommand(oOrco2, ActionForceMoveToLocation(GetLocation(GetNearestObjectByTag("Orcos4")), TRUE, 10.0)));
    object oOrco3 = CreateObject(OBJECT_TYPE_CREATURE, "orco"+sRandom3, lSpawn3);
    DelayCommand(0.1 , AssignCommand(oOrco3, ActionForceMoveToLocation(GetLocation(GetNearestObjectByTag("Orcos6")), TRUE, 10.0)));
    DelayCommand(45.0 , ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oOrco));
    DelayCommand(45.1 , ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oOrco2));
    DelayCommand(45.2 , ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oOrco3));
    if(GetLocalInt(OBJECT_SELF, "invasion") == 1)
    {
    DelayCommand(iRandom4, ExecuteScript("invasion", OBJECT_SELF));
    }


}
