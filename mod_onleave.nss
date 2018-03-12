#include "av_persistencias"
#include "salida_inc"
#include "CIB_frente"
#include "LetoScript_inc"

void main()
{

    object oMod = GetModule();
    object oPC = GetExitingObject();
    string sID = GetStringLeft(GetName(oPC), 25);

    if(!(GetIsDM(oPC)))
    {
        Leto_onExit( oPC );

        // Persistencia de conjuros
        AVSaveSpells(oPC);

        // Persistencia de puntos de vida
        int localHP = GetLocalInt(oPC, "vida");
        SetCampaignInt("Vidade", "vida" + sID, localHP);

        // Persistencia de la locacion
        location locacionPJ = GetLocalLocation(oPC, "locacionPC");
        object areaPJ = GetAreaFromLocation(locacionPJ);
        SetCampaignVector("Lugares", "vector" + sID, GetPositionFromLocation(locacionPJ));
        SetCampaignString("Lugares", "area" + sID, GetTag(areaPJ));
        SetCampaignFloat("Lugares", "mirando" + sID, GetFacingFromLocation(locacionPJ));

        // Si el Area no es segura...
        if(GetLocalInt(areaPJ, "seguro") != 1)
            // ...crea una copia del pj en su lugar
            salida_crearCopiaPJ(oPC, locacionPJ);
        // Desactivado. Ver mod_oncliententr.nss(256)
        //else
            //SetLocalInt(GetModule(), "traer"+sID, 1);

        object oSummon = GetFirstFactionMember(oPC, FALSE);
        while(GetIsObjectValid(oSummon))
        {
            if (GetAssociateType(oSummon)==ASSOCIATE_TYPE_HENCHMAN) {
                RemoveHenchman(oPC, oSummon);
                SetLocalInt(oSummon, "merc", 0);
            } else {
                salida_mataSummon(oSummon, oPC);
            }
            oSummon = GetNextFactionMember(oPC, FALSE);
        }
    }

    //  Control de intercambio de bienes
    CIB_onClientLeave( oPC );

    DeleteLocalInt( GetModule(), Mod_IS_PC_INITIALIZED_REF_PREFIX + GetName(oPC) ); // ver Mod_inc
}
