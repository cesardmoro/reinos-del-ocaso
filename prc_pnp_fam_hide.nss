/*

prc_pnp_fam_hide
by Primogenitor

This script is used by the PnP familiar system to cause the familiar to hide on their
master in a pocket or similar.

If they are alredy hiding, it runs the Summon Familiar code to spawn them.

*/

void EnterPocket(object oPC)
{
    object oFam = OBJECT_SELF;
    StoreCampaignObject("prc_data", "Familiar", oFam, oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oFam = GetLocalObject(oPC, "Familiar");
    //not valid, so summon it
    if(!GetIsObjectValid(oFam))
    {
        ExecuteScript("nw_s2_familiar", OBJECT_SELF);
        return;
    }
    AssignCommand(oFam, ClearAllActions());
    AssignCommand(oFam, ActionMoveToObject(oPC, TRUE, 0.0));
    AssignCommand(oFam, ActionDoCommand(EnterPocket(oPC)));
    AssignCommand(oFam, ActionDoCommand(SetCommandable(TRUE, oFam)));
    SetCommandable(FALSE, oFam);
}