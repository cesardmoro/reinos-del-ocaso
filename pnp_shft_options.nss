void main()
{
//    // Create the options creature
//    object oListener = CreateObject(OBJECT_TYPE_CREATURE,"pnp_shft_options",GetLocation(OBJECT_SELF));
//    // adjust the reputation so its not hostile to the pc
//    SetIsTemporaryFriend(OBJECT_SELF, oListener);
//    // start the convo
	DeleteLocalInt(OBJECT_SELF, "shifting");
    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "pnp_shft_options", FALSE,FALSE));
}
