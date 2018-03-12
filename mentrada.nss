/******************************************************************************
Script By Zero

12/12/06 - Modificacion por Dragoncin:
Se agrego el control de los clerigos.
******************************************************************************/

#include "deity_onlevel"
#include "RdO_Races_inc"

void main()
{
    object oPC = GetLastUsedBy();
    string sID2 = GetName(oPC);
    if(GetStringLength(sID2)) {
        sID2 = GetStringLeft(sID2, 25);
    }

    if (GetXP(oPC) == 0 && GetLocalInt(oPC, STOP_ON_ENTER_STUFF)==TRUE)
    {
        SendMessageToPC(oPC, "No puedes entrar a jugar hasta que no hayas relogueado.");
    }
    // Si es de clase clerigo y no tiene un dios correcto...
    else if ((GetDeityIndex(oPC)<0) && (GetLevelByClass(CLASS_TYPE_CLERIC, oPC)>0))
    {
        //... inicia el dialogo de eleccion de deidad
        AssignCommand(oPC, ActionStartConversation(oPC, "deityconv_inicio"));
    }
    // Si es de clase clerigo y no cumple con las condiciones para subir de nivel...
    else if (CheckDeityRestrictions(oPC)==FALSE && GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0)
    {
        //... no lo deja bajar a jugar
        // Esto debe ser reemplazado por una conversacion en el caso de que tenga mal los dominios que le permita
        // corregirlos con el LetoScript
        return;
    }
    else if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
    {
        AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag("DruidaSpawn"))));
        AdjustReputation(oPC, GetObjectByTag("Druida"),100);
    }
    else {
        AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag("inicio2"))));
        //SetCampaignLocation("respawn", "lugar"+sID2, GetLocation(GetObjectByTag("inicio2")));
    }
}
