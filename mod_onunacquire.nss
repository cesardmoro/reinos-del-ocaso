/******************* onItemUnAquire handler *************************************
Author: original por Zero. Emprolijado y agregados por Inquisidor.
ScripName: x2_mod_def_unaqu
*******************************************************************************/

#include "x2_inc_switches"
#include "CIB_frente"
#include "IPS_Pj_inc"
#include "InvRed_inc"
#include "inventario_inc"
#include "Muerte_inc"
#include "Mercenario_inc"


void main()
// Original por Zero. Emprolijado y agregados por Inquisidor
{

    object oItem = GetModuleItemLost();
    object oUser = GetModuleItemLostBy();

    if( GetIsDM(oUser) )
    {
        if (!Inventario_esObjetoTomadoDelModulo(oItem)) {
            SendMessageToPC(oUser, "No se permite traer objetos de fuera del modulo");
            DestroyObject(oItem, 0.1);
        }
    } else if ( GetIsPC(oUser) ) {

        Muerte_onUnacquire( oUser, oItem );
        Mercenario_onPcUnacquiresItem( oUser, oItem );

        if( GetCampaignInt("PVP", "Assasin", oUser) == 1 )
            SetLocalInt(oItem, "pj", 2);
        else
            SetLocalInt(oItem, "pj", 1);

        if( oItem != OBJECT_INVALID )
            IPS_Pj_onUnacquire( oUser, oItem );

        InventarioReducido_onUnacquire( oUser, oItem );

    } else if( GetIsObjectValid(GetMaster(oUser)) ) {

        if( GetLocalInt(oItem, "esDelMercenario") == TRUE) {
            AssignCommand(oUser, ClearAllActions());
            if (GetRacialType(oUser)!=RACIAL_TYPE_UNDEAD)
                AssignCommand(oUser, ActionSpeakString("Creo que eso me pertenece", TALKVOLUME_TALK));
            //FloatingTextStringOnCreature("Creo que eso me pertenece", oUser, TRUE);
            object oCopia = CopyItem(oItem, oUser, TRUE);
            SetDroppableFlag(oCopia, FALSE);
            DestroyObject(oItem, 0.2);
            return;
        }
    }

    CIB_onUnaquire( oItem, oUser );

    ExecuteScript("prc_onunaquire", oItem);


    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }

}
