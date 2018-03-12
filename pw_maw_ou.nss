void main()
{
    object oPC = GetLastUsedBy();
    SendMessageToPC(oPC,"You try and claw your way up the worms throat");
    SetLocalInt(oPC,"PW_CLIMBINGOUT",TRUE);
}
