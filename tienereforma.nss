int StartingConditional()
{
if(GetGold(GetPCSpeaker()) >= 800)
{
TakeGoldFromCreature(d4(2)*100, GetPCSpeaker(), TRUE);
object oItem = GetLocalObject(GetLastClosedBy(), "reforma");
itemproperty oProperty = GetFirstItemProperty(oItem);
while(GetIsItemPropertyValid(oProperty) == TRUE )
{
if(GetItemPropertyType(oProperty) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
{
RemoveItemProperty(oItem, oProperty);
}
oProperty = GetNextItemProperty(oItem);
}

return TRUE;
}
return FALSE;
}
