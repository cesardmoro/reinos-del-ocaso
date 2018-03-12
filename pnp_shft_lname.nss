//this script is like pnp_shifter_listfm but it uses the name of the form not the resref for display

#include "pnp_shft_main"

// We will be setting the custom tokens so the dlg will display
// 10 forms at a time.

void main()
{
    object oPC = GetPCSpeaker();
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );

    SetPlotFlag(oMimicForms, TRUE);
    SetDroppableFlag(oMimicForms, FALSE);
    SetItemCursedFlag(oMimicForms, FALSE);

    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    int i;
    int j = 0;

    //SendMessageToPC(oPC,"sid "+IntToString(nStartIndex)+" num "+IntToString(num_creatures));
    // cycle back to the start
    if (nStartIndex > num_creatures)
        nStartIndex = 0;

    for ( i=nStartIndex; i<nStartIndex+10; i++ )
    {
        if (i>num_creatures)
        {
            SetCustomToken(100+j,"");
        }
        else
        {
            SetCustomToken(100+j,GetLocalArrayString( oMimicForms, "shift_choice_name", i )); //here we get the name instead of the resref for display
        }
        j++;
        //SendMessageToPC(oPC,GetLocalArrayString( oMimicForms, "shift_choice", i ));
    }


}
