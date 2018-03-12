//::///////////////////////////////////////////////
//:: Goblin User-Defined
//:: UD_Goblin.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in a random goblin at the goblin spawn
    point.
*/
//:://////////////////////////////////////////////
//:: Created By: Rob Bartel
//:: Created On: September 26, 2002
//:://////////////////////////////////////////////


void main()
{
    int iUD = GetUserDefinedEventNumber();
    int iRandom = Random(7)+1;
    string sRandom = IntToString(iRandom);
    object oGoblinSpawn = GetNearestObjectByTag("Spawn_Goblin");
    location lSpawn = GetLocation(oGoblinSpawn);

    if (iUD == 1007)
    {
        CreateObject(OBJECT_TYPE_CREATURE, "goblin"+sRandom, lSpawn);
    }
}
