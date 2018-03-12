int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if ( (GetReputation(OBJECT_SELF, oPC) > 95 ||
          // Reputacion O clerigos de la misma deidad
          (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 && GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0 && GetDeity(oPC)==GetDeity(OBJECT_SELF)) )
         && GetIsObjectValid(GetMaster(OBJECT_SELF)) == FALSE
        )

        return TRUE;

    return FALSE;
}
