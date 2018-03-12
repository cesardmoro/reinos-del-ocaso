void main()
{
    object oPC = GetExitingObject();
    object oWorm = GetLocalObject(oPC,"PW_INSIDE");
    int nSpace = GetLocalInt(oWorm,"PW_SPACE");
    //1 = a tiny creature, 2 = a small one.
    //4 = a large one (or normal)
    int nSize;

    if(GetCreatureSize(oPC)==CREATURE_SIZE_TINY)
        nSize = 1;
    else if(GetCreatureSize(oPC)==CREATURE_SIZE_SMALL)
        nSize = 2;
    else if(GetCreatureSize(oPC)==CREATURE_SIZE_MEDIUM)
        nSize = 4;
    else if(GetCreatureSize(oPC)==CREATURE_SIZE_LARGE)
        nSize = 4;

    SetLocalInt(oWorm,"PW_SPACE",nSpace-nSize);

    if(nSpace-nSize<1)
         DeleteLocalInt(oWorm,"PW_SPACE");

    DeleteLocalObject(oPC,"PW_INSIDE");
    DeleteLocalInt(oPC,"PW_DAMAGEDEALT");
    DeleteLocalInt(oPC,"PW_CLIMBINGOUT");
}
