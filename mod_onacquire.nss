/******************* onItemAquire handler *************************************
Author: original por Zero. Emprolijado y agregados por Inquisidor.
ScrptName: x2_mod_def_aqu
*******************************************************************************/

#include "x2_inc_switches"
#include "CIB_frente"
//#include "Tesoro_inc"
#include "InvRed_inc"
#include "muerte_inc"
#include "IPS_Pj_inc"
#include "Store_inc"
#include "inventario_inc"
#include "Mercenario_inc"


void main()
// Original por Zero. Emprolijada y agregados por Inquisidor
{
    object oItem = GetModuleItemAcquired();
    object oUser = GetModuleItemAcquiredBy();
    object giver = GetModuleItemAcquiredFrom();
    int cuanto = GetModuleItemAcquiredStackSize();
    string tagItem = GetTag(oItem);

    // marcar los ítems tomados del módulo (para diferenciarlos de los ítems traidos del vault del cliente DM)
    if ( GetIsDM(oUser) ) {
        if( Mod_isPcInitialized( oUser ) )
            Inventario_marcarItemTomadoPorDM(oItem);

    } else if ( GetIsPC( oUser ) &&  GetIsObjectValid( oItem ) ) {
        if( IPS_Item_getIsAdept( oItem ) )
            IPS_Pj_onAcquire( oUser, oItem, giver );
        else if(
            !Mod_esItemHabilitadoEquipar( oItem )
            && tagItem != Tesoro_ITEM_TAG
            && GetGoldPieceValue(oItem) > 3000
        ) {
            SendMessageToPC( oUser, "Este objeto se registra como ilegal: "+GetName(oItem)+", type="+IntToString(GetBaseItemType(oItem)) );
            WriteTimestampedLogEntry(GetName(oUser)+" ha intentado tomar un objeto que se registra como ilegal:"+GetName(oItem)+", type="+IntToString(GetBaseItemType(oItem)) );
            Item_tirar( oItem, oUser );
            return;
        }

        Mercenario_onPcAcquiresItem( oUser, oItem, giver );

        int marcaDePJ = GetLocalInt(oItem, "pj");
        if( marcaDePJ != 0 ) {

//            Quitado porque es innecesario. Este flag se pone automaticamnete en false cada vez que el item pasa de duenio.
//            SetDroppableFlag( oItem, FALSE );// Si fue dado a un asociado este flag se puso en TRUE. Por ende hay que volver a ponerlo en FALSE.

            if( marcaDePJ == 2) { // Zero, ponele nombres a las constantes!!
                SendMessageToPC(oUser, "Este objecto le pertenece a un criminal y al aceptarlo ganas una pequea pena de carcel");
                int carcel = GetCampaignInt( "PVP", "Carcel", oUser ) + 3;
                SetCampaignInt("PVP", "Carcel", carcel, oUser);
                if( carcel > 30)
                    SetCampaignInt("PVP", "Assasin", 1, oUser);
            }
            DeleteLocalInt( oItem, "pj" );
        }

        InventarioReducido_onAcquire( oUser, oItem );

        Muerte_onAcquire( oUser, oItem );
    }

    CIB_onAcquire( oItem, GetModuleItemAcquiredStackSize(), giver, oUser );

    Store_Subject_onAcquire( oItem, oUser, giver );

    ExecuteScript("prc_onaquire", oItem);

    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }
}
