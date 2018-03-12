//this script checks if you have druid wild shape to greater wild shape converstion turned off
//if you do then return false and dont show the option to turn it off
int StartingConditional()
{

    // Inspect local variables
    if(!(GetLocalInt(GetPCSpeaker(), "DWS") == 1))
        return FALSE;

    return TRUE;
}
