//this script checks if you have druid wild shape to greater wild shape converstion turned on
//if you do then return false and dont show the option to turn it on
int StartingConditional()
{

    // Inspect local variables
    if(!(GetLocalInt(GetPCSpeaker(), "DWS") == 0))
        return FALSE;

    return TRUE;
}
