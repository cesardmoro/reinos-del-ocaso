////////////////
//
// Conjunto de funciones relativas al inventario
////////////////
#include "IPS_basic_inc"

//////////////////////// CONSTTANTES /////////////////////////////////////////

const string ESTADO_EQUIPANDO_FORZADO     = "yaEquipo";
const int EQUIPANDO_FORZADO_FUNCIONANDO   = 1;

const string Inventario_EFFECT_CREATOR    = "Inventario_effectCreator";

const string Inventario_MARCADOR_ITEMS_RECIBIDOS_DM = "UsOs"; // nombre engañoso

/////////////////////// FUNCIONES ////////////////////////////////////////////

// Esta funcion es privada a inventory_cambiarItem()
// OBJECT_SELF equipa un item tomando un tiempo para hacerlo
void inventory_equiparItemConRetardo( object oItem, float fTiempo, string sItem, int nSlot)
{
    if(sItem != "")
        ActionSpeakString(sItem);

    if (fTiempo > 1.0) {
        ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, fTiempo-1.0);
        ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.0);
    }
    ActionEquipItem(oItem, nSlot);

}

// Equipa un nuevo item y genera un mensaje visible por todos sobre la accion
// para evitar metajuego y trampas. Si el item toma un tiempo especial en cambiarse
// retarda el cambio con la funcion inventory_equiparItemConRetardo()
void inventory_cambiarItem(object oPC, object oItem)
{
    //Si no es un personaje, terminar el script
    if (!GetIsPC(oPC))
        return;

    string sItem;
    float fTiempo;
    int nSlot;
    int iBaseItemType = GetBaseItemType(oItem);

    switch (iBaseItemType) {
    case BASE_ITEM_AMULET:          sItem = "*Se cambia su amuleto*";
                                    break;
    case BASE_ITEM_RING:            sItem = "*Se cambia su anillo*";
                                    break;
    case BASE_ITEM_BOOTS:           sItem = "*Se cambia sus botas*";
                                    break;
    case BASE_ITEM_BRACER:          sItem = "*Se cambia sus brazales*";
                                    break;
    case BASE_ITEM_CLOAK:           sItem = "*Se cambia su capa*";
                                    break;
    case BASE_ITEM_GLOVES:          sItem = "*Se cambia sus guantes*";
                                    break;
    case BASE_ITEM_HELMET:          sItem = "*Se cambia su casco*";
                                    break;
    case BASE_ITEM_ARROW:           sItem = "*Se cambia su carcajo*";
                                    break;
    case BASE_ITEM_BELT:            sItem = "*Se cambia su cinto*";
                                    break;
    case BASE_ITEM_BOLT:            sItem = "*Se cambia su carcajo de virotes*";
                                    break;
    case BASE_ITEM_BULLET:          sItem = "*Se cambia su bolsa de piedras*";
                                    break;
    case BASE_ITEM_ARMOR:           sItem = "*Se cambia su armadura*";
                                    //nSlot = INVENTORY_SLOT_CHEST;
                                    //fTiempo = 30.0;
                                    break;
    }

    if(fTiempo > 0.0 && GetIsPC(oPC))
        AssignCommand(oPC, ActionDoCommand(inventory_equiparItemConRetardo(oItem, fTiempo, sItem, nSlot)));
    else
        ActionSpeakString(sItem);

}



// equipa itemParaEquipar en el slot slotDondeEquipar de la criaturaEquipadora
void forzarEquiparItemRepetitivo( object itemParaEquipar, object criaturaEquipadora, int slotDondeEquipar );
void forzarEquiparItemRepetitivo( object itemParaEquipar, object criaturaEquipadora, int slotDondeEquipar )
{
    if ( GetIsObjectValid( itemParaEquipar ) ) {
        if (GetItemInSlot(slotDondeEquipar, criaturaEquipadora)==OBJECT_INVALID) {
            SetLocalInt(criaturaEquipadora, ESTADO_EQUIPANDO_FORZADO, EQUIPANDO_FORZADO_FUNCIONANDO);
            //SendMessageToPC(GetFirstPC(), "Intentando equipar "+GetName(itemParaEquipar));
            AssignCommand(criaturaEquipadora, ActionEquipItem(itemParaEquipar, slotDondeEquipar));
            DelayCommand(1.0, AssignCommand(criaturaEquipadora, forzarEquiparItemRepetitivo(itemParaEquipar, criaturaEquipadora, slotDondeEquipar)));
        } else
            DeleteLocalInt(criaturaEquipadora, ESTADO_EQUIPANDO_FORZADO);
    }
}

// Copia en la criatura B los items que la criatura A tenga equipados y los equipa
void copiarInventarioEquipadoCriaturaAenCriaturaB( object criaturaA, object criaturaB, int setearNoDropeables = FALSE );
void copiarInventarioEquipadoCriaturaAenCriaturaB( object criaturaA, object criaturaB, int setearNoDropeables = FALSE )
{
    location locacionB = GetLocation(criaturaB);
    object itemParaCopiar;
    object itemCopiado;

    AssignCommand(criaturaB, ClearAllActions());

    int i;
    for (i=0; i<NUM_INVENTORY_SLOTS; i++) {
        itemParaCopiar = GetItemInSlot(i, criaturaA);
        if (itemParaCopiar != OBJECT_INVALID) {
            itemCopiado = CopyItem(itemParaCopiar, criaturaB, TRUE);
            SetIdentified(itemCopiado, TRUE);
            if (setearNoDropeables)
                SetDroppableFlag(itemCopiado, FALSE);
            DestroyObject(GetItemInSlot(i, criaturaB));
            forzarEquiparItemRepetitivo(itemCopiado, criaturaB, i);
        }
    }
}

// Setea todos los items equipados por oCriatura como no dropeables
void Inventory_setearItemsEquipadosNoDropeables( object oCriatura );
void Inventory_setearItemsEquipadosNoDropeables( object oCriatura ) {
    int slotIterator = NUM_INVENTORY_SLOTS;
    while( --slotIterator >= 0 )
        SetDroppableFlag(GetItemInSlot(slotIterator, oCriatura), FALSE);
}

void Inventory_setearItemsContenidosNoDropeables( object container );
void Inventory_setearItemsContenidosNoDropeables( object container ) {
    object itemIterator = GetFirstItemInInventory(container);
    while( itemIterator != OBJECT_INVALID ) {
        SetDroppableFlag( itemIterator, FALSE );
        itemIterator = GetNextItemInInventory(container);
    }
}

void Inventario_generarClaveInventarioDM()
{
    int clave = Random(5000);
    SetLocalInt(GetModule(), Inventario_MARCADOR_ITEMS_RECIBIDOS_DM, clave);
}

// Marca un item tomado por un DM para que no se destruya al devolverlo al modulo
void Inventario_marcarItemTomadoPorDM( object oItem );
void Inventario_marcarItemTomadoPorDM( object oItem ) {
    int clave = GetLocalInt( GetModule(), Inventario_MARCADOR_ITEMS_RECIBIDOS_DM );
    SetLocalInt( oItem, Inventario_MARCADOR_ITEMS_RECIBIDOS_DM, clave );
}

// Devuelve si un item poseido por un DM fue tomado del modulo, y borra la marca.
int Inventario_esObjetoTomadoDelModulo( object oItem );
int Inventario_esObjetoTomadoDelModulo( object oItem ) {
    int fueTomadoDelModulo = GetLocalInt(oItem,Inventario_MARCADOR_ITEMS_RECIBIDOS_DM) == GetLocalInt( GetModule(), Inventario_MARCADOR_ITEMS_RECIBIDOS_DM );
    DeleteLocalInt( oItem, Inventario_MARCADOR_ITEMS_RECIBIDOS_DM );
    return fueTomadoDelModulo || GetResRef(oItem) == IPS_FLEETING_ITEM_RESREF;
}

