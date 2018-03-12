//::///////////////////////////////////////////////
//:: Kobold User-Defined
//:: UD_Kobold.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in a random kobold at the kobold spawn
    point.
*/
//:://////////////////////////////////////////////
//:: Created By: Rob Bartel
//:: Created On: September 26, 2002
//:://////////////////////////////////////////////

void main()
{
    int iUD = GetUserDefinedEventNumber();
    int iRandom = Random(6)+1;
    string sRandom = IntToString(iRandom);
    object oKoboldSpawn = GetNearestObjectByTag("Spawn_Kobold");
    location lSpawn = GetLocation(oKoboldSpawn);

    if (iUD == 1007)
    {
        CreateObject(OBJECT_TYPE_CREATURE, "kobold"+sRandom, lSpawn);
    }
}
