void main()
{
if(GetBaseItemType(GetFirstItemInInventory(OBJECT_SELF)) == BASE_ITEM_ARMOR)
{
ActionStartConversation(GetLastClosedBy(), "reforma", TRUE, FALSE);
SetLocalObject(GetLastClosedBy(), "reforma", GetFirstItemInInventory(OBJECT_SELF));
}
}
