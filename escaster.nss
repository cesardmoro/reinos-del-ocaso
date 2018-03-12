int StartingConditional()
{
    if((GetLevelByClass(CLASS_TYPE_WIZARD, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_SORCERER, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0) || (GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF) > 0) )
{
return TRUE;

}
return FALSE;
}
