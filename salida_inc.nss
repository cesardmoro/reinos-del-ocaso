#include "faccion_inc"

// Controla la vida de la copia del PJ y la guarda en la base de datos
void salida_controlarVidaCopiaPJ( object oCopiaPJ, string sID );

// Copia los efectos bajo los que se encontraba el PJ a la copia
void salida_ajustarEfectosCopiaPJ(object oPC, object oTarget);

// Ajusta los Flags de los Items que tenga la copia y destruye los cuerpos que tenga
void salida_ajustarFlagsCopiaPJ(object oPC);

// Crea una copia del PJ y devuelve el objeto copia
object salida_crearCopiaPJ( object oPC, location lDondeCrear );

// Destruye una criatura invocada
void salida_mataSummon(object oSummon, object oMaster);


void salida_controlarVidaCopiaPJ( object oCopiaPJ, string sID )
{
    if(GetIsObjectValid(oCopiaPJ) == TRUE) {
        int hp = GetCurrentHitPoints(oCopiaPJ);

        if((hp > -10) && hp < 9999) {
            SetCampaignInt("Vidade", "vida" + sID, hp);
            DelayCommand(6.0, salida_controlarVidaCopiaPJ(oCopiaPJ,sID));
        } else
            SetCampaignInt("delogs", "muerto" + sID , 1);
    }
}


void salida_ajustarEfectosCopiaPJ(object oPC, object oTarget)
{
    effect ePri = GetFirstEffect(oPC);
    while(GetEffectType(ePri) != EFFECT_TYPE_INVALIDEFFECT)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePri, oTarget);
        ePri = GetNextEffect(oPC);
    }
}


void salida_ajustarFlagsCopiaPJ(object oPC)
{
    string sTag;
    string sTempTag;
    string sNumero;
    int iLargoTag;

    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID)
    {
        sTag = GetTag(oItem);
        if (GetStringLeft(sTag, 6) != "Cuerpo") {

            SetDroppableFlag(oItem, FALSE);
            SetPlotFlag(oItem, TRUE);
            SetPickpocketableFlag(oItem, FALSE);

        } else
            DestroyObject(oItem);

        oItem = GetNextItemInInventory(oPC);
    }

    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), FALSE);
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), FALSE);

    int cuantoOro = GetGold(oPC);
    AssignCommand(oPC, TakeGoldFromCreature(cuantoOro, oPC, TRUE));
}


object salida_crearCopiaPJ( object oPC, location lDondeCrear )
{
    string sID = GetStringLeft(GetName(oPC), 25);
    object oCopia = CopyObject(oPC, lDondeCrear, OBJECT_INVALID, "co"+sID);

    //CambiarFaccionConDestino(oCopia, STANDARD_FACTION_COMMONER, lDondeCrear);
    ChangeToStandardFaction(oCopia, STANDARD_FACTION_COMMONER);
    SetLootable(oCopia, FALSE);
    DelayCommand(4.0, AssignCommand(oCopia, ActionSpeakString("Deslogue", TALKVOLUME_TALK)));

    salida_controlarVidaCopiaPJ(oCopia, sID);
    salida_ajustarFlagsCopiaPJ(oCopia);
    salida_ajustarEfectosCopiaPJ(oPC, oCopia);

    SetLocalObject(GetModule(), sID, oCopia);

    DestroyObject(oCopia, 120.0);

    return oCopia;
}


void salida_mataSummon(object oSummon, object oMaster)
{
    if(GetAssociateType(oSummon) == ASSOCIATE_TYPE_DOMINATED)
    {
        if(GetMaster(oSummon) == oMaster)
        {
            effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(oSummon));
            AssignCommand(oSummon, SetIsDestroyable(TRUE, FALSE, FALSE));
            DestroyObject(oSummon, 0.1);
        }
    }
}
