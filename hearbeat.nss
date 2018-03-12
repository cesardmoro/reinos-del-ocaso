#include "pct_obj_inc"
#include "hearbeatinc"
void main()
{

    object oPC = OBJECT_SELF;
    string sID = GetName(oPC);
    if(GetStringLength(sID))
    {
        sID = GetStringLeft(sID, 25);

    }
    if(oPC != OBJECT_INVALID)
    {
        if(GetIsPC(oPC) == TRUE)
        {
            vida(oPC);
            lugar(oPC);
            efectos(oPC);
            XP(oPC);
            Sangrado(oPC);
            checkAling(oPC);

            if( !GetIsDM(oPC) )
                PerceptionSys_playerHandler();

            if(GetLocalInt(GetArea(OBJECT_SELF), "seguro") == 1 && GetLocalInt(GetModule(), "seguro"+sID) != 1)
            {
                SetLocalInt(GetModule(), "seguro"+sID, 1);
                SendMessageToPC(oPC, "Esta area es segura para deslogear");
            }
            if(GetLocalInt(GetArea(OBJECT_SELF), "seguro") == 0 && GetLocalInt(GetModule(), "seguro"+sID) != 0)
            {
                SetLocalInt(GetModule(), "seguro"+sID, 0);
            }

            DelayCommand(6.0, ExecuteScript("hearbeat", oPC));
        }
    }
}

