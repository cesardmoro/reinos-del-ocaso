#include "inventario_inc"
#include "inc_item_props"
#include "ips_basic_inc"

const string InvRed_AREA_PERMITE_CRAFT              = "puede";
const string ESTADO_INVENTARIO_REDUCIDO             = "InvRed_estado";
const int INVENTARIO_REDUCIDO_ACTIVADO              = 1;

const string InvRed_CANTIDAD_ARMADURAS_PJ           = "InvRed_cantidadArmadurasPJ";
const string InvRed_CANTIDAD_ARMAS_2MANOS_PJ        = "InvRed_cantidadArmas2ManosPJ";
const string InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ     = "InvRed_cantidadArmasPequeniasPJ";
const string InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ   = "InvRed_cantidadArmasPrincipalesPJ";
const string InvRed_CANTIDAD_ARROJADIZAS_PJ         = "InvRed_cantidadArrojadizasPJ";
const string InvRed_CANTIDAD_ARCOS_PJ               = "InvRed_cantidadArcosPJ";
const string InvRed_CANTIDAD_BALLESTAS_PJ           = "InvRed_cantidadBallestasPJ";
const string InvRed_CANTIDAD_BOTAS_PJ               = "InvRed_cantidadBotasPJ";
const string InvRed_CANTIDAD_CINTURONES_PJ          = "InvRed_cantidadCinturonesPJ";
const string InvRed_CANTIDAD_CAPAS_PJ               = "InvRed_cantidadCapasPJ";
const string InvRed_CANTIDAD_CASCOS_PJ              = "InvRed_cantidadCascosPJ";
const string InvRed_CANTIDAD_DAGAS_PJ               = "InvRed_cantidadDagasPJ";
const string InvRed_CANTIDAD_ESCUDOS_PJ             = "InvRed_cantidadEscudosPJ";
const string InvRed_CANTIDAD_ESPADAS_PJ             = "InvRed_cantidadEspadasPJ";
const string InvRed_CANTIDAD_ESPADAS_CORTAS_PJ      = "InvRed_cantidadEspadasCortasPJ";
const string InvRed_CANTIDAD_FLECHAS_PJ             = "InvRed_cantidadFlechasPJ";
const string InvRed_CANTIDAD_GUANTES_PJ             = "InvRed_cantidadGuantesPJ";
const string InvRed_CANTIDAD_PIEDRAS_PJ             = "InvRed_cantidadPiedrasPJ";
const string InvRed_CANTIDAD_POCIONES_PJ            = "InvRed_cantidadPocionesPJ";
const string InvRed_CANTIDAD_ROPA_PJ                = "InvRed_cantidadRopaPJ";
const string InvRed_CANTIDAD_VARITAS_PJ             = "InvRed_cantidadVaritasPJ";
const string InvRed_CANTIDAD_VIROTES_PJ             = "InvRed_cantidadVirotesPJ";

const int InvRed_MAXIMO_ARMADURAS              = 2;
const int InvRed_MAXIMO_ARMAS_2MANOS           = 2;
const int InvRed_MAXIMO_ARMAS_PEQUENIAS        = 4;
const int InvRed_MAXIMO_ARMAS_PRINCIPALES      = 3;
const int InvRed_MAXIMO_ARROJADIZAS            = 200;
const int InvRed_MAXIMO_ARCOS                  = 2;
const int InvRed_MAXIMO_BALLESTAS              = 2;
const int InvRed_MAXIMO_BOTAS                  = 4;
const int InvRed_MAXIMO_CINTURONES             = 4;
const int InvRed_MAXIMO_CAPAS                  = 3;
const int InvRed_MAXIMO_CASCOS                 = 2;
const int InvRed_MAXIMO_DAGAS                  = 6;
const int InvRed_MAXIMO_ESCUDOS                = 2;
const int InvRed_MAXIMO_ESPADAS                = 4;
const int InvRed_MAXIMO_ESPADAS_CORTAS         = 4;
const int InvRed_MAXIMO_FLECHAS                = 300;
const int InvRed_MAXIMO_GUANTES                = 4;
const int InvRed_MAXIMO_PIEDRAS                = 300;
const int InvRed_MAXIMO_POCIONES               = 10;
const int InvRed_MAXIMO_ROPA                   = 6;
const int InvRed_MAXIMO_VARITAS                = 10;
const int InvRed_MAXIMO_VIROTES                = 300;

void InventarioReducido_onEnter( object oPC );
void InventarioReducido_onEnter( object oPC )
{
    int cantidadArmaduras;
    int cantidadRopa;
    int cantidadFlechas;
    int cantidadEspadas;
    int cantidadArmasPrincipales;
    int cantidadCinturones;
    int cantidadVirotes;
    int cantidadBotas;
    int cantidadGuantes;
    int cantidadPiedras;
    int cantidadArmasPequenias;
    int cantidadDagas;
    int cantidadCapas;
    int cantidadArmas2Manos;
    int cantidadEspadasCortas;
    int cantidadEscudos;
    int cantidadCascos;
    int cantidadVaritas;
    int cantidadPociones;
    int cantidadArrojadizas;
    int cantidadBallestas;
    int cantidadArcos;

    object item = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(item)) {
        switch (GetBaseItemType(item)) {
            case BASE_ITEM_ARROW:               cantidadFlechas += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_BOLT:                cantidadVirotes += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_BULLET:              cantidadPiedras += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_BASTARDSWORD:        cantidadEspadas++; break;
            case BASE_ITEM_BATTLEAXE:           cantidadArmasPrincipales++; break;
            case BASE_ITEM_BELT:                cantidadCinturones++; break;
            case BASE_ITEM_BOOTS:               cantidadBotas++; break;
            case BASE_ITEM_BRACER:              cantidadGuantes++; break;
            case BASE_ITEM_CLOAK:               cantidadCapas++; break;
            case BASE_ITEM_CLUB:                cantidadArmasPequenias++; break;
            case BASE_ITEM_DAGGER:              cantidadDagas++; break;
            case BASE_ITEM_DART:                cantidadArrojadizas += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_DIREMACE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_DOUBLEAXE:           cantidadArmas2Manos++; break;
            case BASE_ITEM_DWARVENWARAXE:       cantidadArmasPrincipales++; break;
            case BASE_ITEM_GLOVES:              cantidadGuantes++; break;
            case BASE_ITEM_GREATAXE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_GREATSWORD:          cantidadArmas2Manos++; break;
            case BASE_ITEM_HALBERD:             cantidadArmas2Manos++; break;
            case BASE_ITEM_HANDAXE:             cantidadArmasPequenias++; break;
            case BASE_ITEM_HEAVYCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_HEAVYFLAIL:          cantidadArmas2Manos++; break;
            case BASE_ITEM_HELMET:              cantidadCascos++; break;
            case BASE_ITEM_KATANA:              cantidadEspadas++; break;
            case BASE_ITEM_KUKRI:               cantidadDagas++; break;
            case BASE_ITEM_LARGESHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_LIGHTCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_LIGHTFLAIL:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_LIGHTHAMMER:         cantidadArmasPequenias++; break;
            case BASE_ITEM_LIGHTMACE:           cantidadArmasPequenias++; break;
            case BASE_ITEM_LONGBOW:             cantidadArcos++; break;
            case BASE_ITEM_LONGSWORD:           cantidadEspadas++; break;
            case BASE_ITEM_MAGICROD:            cantidadVaritas++; break;
            case BASE_ITEM_MAGICSTAFF:          cantidadArmas2Manos++; break;
            case BASE_ITEM_MAGICWAND:           cantidadVaritas++; break;
            case BASE_ITEM_MORNINGSTAR:         cantidadArmasPrincipales++; break;
            case BASE_ITEM_POTIONS:             cantidadPociones++; break;
            case BASE_ITEM_QUARTERSTAFF:        cantidadArmas2Manos++; break;
            case BASE_ITEM_RAPIER:              cantidadEspadas++; break;
            case BASE_ITEM_SCIMITAR:            cantidadEspadas++; break;
            case BASE_ITEM_SCYTHE:              cantidadArmas2Manos++; break;
            case BASE_ITEM_SHORTBOW:            cantidadArcos++; break;
            case BASE_ITEM_SHORTSPEAR:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_SHORTSWORD:          cantidadEspadasCortas++; break;
            case BASE_ITEM_SHURIKEN:            cantidadArrojadizas += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_SICKLE:              cantidadArmasPequenias++; break;
            case BASE_ITEM_SMALLSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_THROWINGAXE:         cantidadArrojadizas += (FindSubString(GetName(item), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(item) : IPS_Item_getAmmoPacketStackSize(item); break;
            case BASE_ITEM_TOWERSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_TWOBLADEDSWORD:      cantidadArmas2Manos++; break;
            case BASE_ITEM_WARHAMMER:           cantidadArmasPrincipales++; break;
            case BASE_ITEM_ARMOR:           {   if (GetBaseAC(item)==0) cantidadRopa++; else cantidadArmaduras++; break; }
        }
        item = GetNextItemInInventory(oPC);
    }

    item = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    if (GetIsObjectValid(item)) cantidadGuantes++;

    item = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
    if (GetIsObjectValid(item)) cantidadFlechas += GetItemStackSize(item);

    item = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
    if (GetIsObjectValid(item)) cantidadCinturones++;

    item = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
    if (GetIsObjectValid(item)) cantidadVirotes += GetItemStackSize(item);

    item = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
    if (GetIsObjectValid(item)) cantidadBotas++;

    item = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
    if (GetIsObjectValid(item)) cantidadPiedras += GetItemStackSize(item);

    item = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (GetIsObjectValid(item)) {
        if (GetBaseAC(item)==0) cantidadRopa++; else cantidadArmaduras++;
    }

    item = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    if (GetIsObjectValid(item)) cantidadCapas++;

    item = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    if (GetIsObjectValid(item)) cantidadCascos++;

    item = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        switch (GetBaseItemType(item)) {
            case BASE_ITEM_BASTARDSWORD:        cantidadEspadas++; break;
            case BASE_ITEM_BATTLEAXE:           cantidadArmasPrincipales++; break;
            case BASE_ITEM_CLUB:                cantidadArmasPequenias++; break;
            case BASE_ITEM_DAGGER:              cantidadDagas++; break;
            case BASE_ITEM_DART:                cantidadArrojadizas++; break;
            case BASE_ITEM_DIREMACE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_DOUBLEAXE:           cantidadArmas2Manos++; break;
            case BASE_ITEM_DWARVENWARAXE:       cantidadArmasPrincipales++; break;
            case BASE_ITEM_GREATAXE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_GREATSWORD:          cantidadArmas2Manos++; break;
            case BASE_ITEM_HALBERD:             cantidadArmas2Manos++; break;
            case BASE_ITEM_HANDAXE:             cantidadArmasPequenias++; break;
            case BASE_ITEM_HEAVYCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_HEAVYFLAIL:          cantidadArmas2Manos++; break;
            case BASE_ITEM_KATANA:              cantidadEspadas++; break;
            case BASE_ITEM_KUKRI:               cantidadDagas++; break;
            case BASE_ITEM_LARGESHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_LIGHTCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_LIGHTFLAIL:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_LIGHTHAMMER:         cantidadArmasPequenias++; break;
            case BASE_ITEM_LIGHTMACE:           cantidadArmasPequenias++; break;
            case BASE_ITEM_LONGBOW:             cantidadArcos++; break;
            case BASE_ITEM_LONGSWORD:           cantidadEspadas++; break;
            case BASE_ITEM_MAGICROD:            cantidadVaritas++; break;
            case BASE_ITEM_MAGICSTAFF:          cantidadArmas2Manos++; break;
            case BASE_ITEM_MAGICWAND:           cantidadVaritas++; break;
            case BASE_ITEM_MORNINGSTAR:         cantidadArmasPrincipales++; break;
            case BASE_ITEM_POTIONS:             cantidadPociones++; break;
            case BASE_ITEM_QUARTERSTAFF:        cantidadArmas2Manos++; break;
            case BASE_ITEM_RAPIER:              cantidadEspadas++; break;
            case BASE_ITEM_SCIMITAR:            cantidadEspadas++; break;
            case BASE_ITEM_SCYTHE:              cantidadArmas2Manos++; break;
            case BASE_ITEM_SHORTBOW:            cantidadArcos++; break;
            case BASE_ITEM_SHORTSPEAR:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_SHORTSWORD:          cantidadEspadasCortas++; break;
            case BASE_ITEM_SHURIKEN:            cantidadArrojadizas++; break;
            case BASE_ITEM_SICKLE:              cantidadArmasPequenias++; break;
            case BASE_ITEM_SMALLSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_THROWINGAXE:         cantidadArrojadizas++; break;
            case BASE_ITEM_TOWERSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_TWOBLADEDSWORD:      cantidadArmas2Manos++; break;
            case BASE_ITEM_WARHAMMER:           cantidadArmasPrincipales++; break;
        }

    item = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        switch (GetBaseItemType(item)) {
            case BASE_ITEM_BASTARDSWORD:        cantidadEspadas++; break;
            case BASE_ITEM_BATTLEAXE:           cantidadArmasPrincipales++; break;
            case BASE_ITEM_CLUB:                cantidadArmasPequenias++; break;
            case BASE_ITEM_DAGGER:              cantidadDagas++; break;
            case BASE_ITEM_DART:                cantidadArrojadizas++; break;
            case BASE_ITEM_DIREMACE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_DOUBLEAXE:           cantidadArmas2Manos++; break;
            case BASE_ITEM_DWARVENWARAXE:       cantidadArmasPrincipales++; break;
            case BASE_ITEM_GREATAXE:            cantidadArmas2Manos++; break;
            case BASE_ITEM_GREATSWORD:          cantidadArmas2Manos++; break;
            case BASE_ITEM_HALBERD:             cantidadArmas2Manos++; break;
            case BASE_ITEM_HANDAXE:             cantidadArmasPequenias++; break;
            case BASE_ITEM_HEAVYCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_HEAVYFLAIL:          cantidadArmas2Manos++; break;
            case BASE_ITEM_KATANA:              cantidadEspadas++; break;
            case BASE_ITEM_KUKRI:               cantidadDagas++; break;
            case BASE_ITEM_LARGESHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_LIGHTCROSSBOW:       cantidadBallestas++; break;
            case BASE_ITEM_LIGHTFLAIL:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_LIGHTHAMMER:         cantidadArmasPequenias++; break;
            case BASE_ITEM_LIGHTMACE:           cantidadArmasPequenias++; break;
            case BASE_ITEM_LONGBOW:             cantidadArcos++; break;
            case BASE_ITEM_LONGSWORD:           cantidadEspadas++; break;
            case BASE_ITEM_MAGICROD:            cantidadVaritas++; break;
            case BASE_ITEM_MAGICSTAFF:          cantidadArmas2Manos++; break;
            case BASE_ITEM_MAGICWAND:           cantidadVaritas++; break;
            case BASE_ITEM_MORNINGSTAR:         cantidadArmasPrincipales++; break;
            case BASE_ITEM_POTIONS:             cantidadPociones++; break;
            case BASE_ITEM_QUARTERSTAFF:        cantidadArmas2Manos++; break;
            case BASE_ITEM_RAPIER:              cantidadEspadas++; break;
            case BASE_ITEM_SCIMITAR:            cantidadEspadas++; break;
            case BASE_ITEM_SCYTHE:              cantidadArmas2Manos++; break;
            case BASE_ITEM_SHORTBOW:            cantidadArcos++; break;
            case BASE_ITEM_SHORTSPEAR:          cantidadArmasPrincipales++; break;
            case BASE_ITEM_SHORTSWORD:          cantidadEspadasCortas++; break;
            case BASE_ITEM_SHURIKEN:            cantidadArrojadizas++; break;
            case BASE_ITEM_SICKLE:              cantidadArmasPequenias++; break;
            case BASE_ITEM_SMALLSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_THROWINGAXE:         cantidadArrojadizas++; break;
            case BASE_ITEM_TOWERSHIELD:         cantidadEscudos++; break;
            case BASE_ITEM_TWOBLADEDSWORD:      cantidadArmas2Manos++; break;
            case BASE_ITEM_WARHAMMER:           cantidadArmasPrincipales++; break;
        }

    SetLocalInt(oPC, InvRed_CANTIDAD_ARMADURAS_PJ, cantidadArmaduras);
    SetLocalInt(oPC, InvRed_CANTIDAD_ROPA_PJ, cantidadRopa);
    SetLocalInt(oPC, InvRed_CANTIDAD_ARCOS_PJ, cantidadArcos);
    SetLocalInt(oPC, InvRed_CANTIDAD_ARMAS_2MANOS_PJ, cantidadArmas2Manos);
    SetLocalInt(oPC, InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ, cantidadArmasPequenias);
    SetLocalInt(oPC, InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ, cantidadArmasPrincipales);
    SetLocalInt(oPC, InvRed_CANTIDAD_ARROJADIZAS_PJ, cantidadArrojadizas);
    SetLocalInt(oPC, InvRed_CANTIDAD_BALLESTAS_PJ, cantidadBallestas);
    SetLocalInt(oPC, InvRed_CANTIDAD_BOTAS_PJ, cantidadBotas);
    SetLocalInt(oPC, InvRed_CANTIDAD_CAPAS_PJ, cantidadCapas);
    SetLocalInt(oPC, InvRed_CANTIDAD_CASCOS_PJ, cantidadCascos);
    SetLocalInt(oPC, InvRed_CANTIDAD_CINTURONES_PJ, cantidadCinturones);
    SetLocalInt(oPC, InvRed_CANTIDAD_DAGAS_PJ, cantidadDagas);
    SetLocalInt(oPC, InvRed_CANTIDAD_ESCUDOS_PJ, cantidadEscudos);
    SetLocalInt(oPC, InvRed_CANTIDAD_ESPADAS_PJ, cantidadEspadas);
    SetLocalInt(oPC, InvRed_CANTIDAD_ESPADAS_CORTAS_PJ, cantidadEspadasCortas);
    SetLocalInt(oPC, InvRed_CANTIDAD_FLECHAS_PJ, cantidadFlechas);
    SetLocalInt(oPC, InvRed_CANTIDAD_GUANTES_PJ, cantidadGuantes);
    SetLocalInt(oPC, InvRed_CANTIDAD_PIEDRAS_PJ, cantidadPiedras);
    SetLocalInt(oPC, InvRed_CANTIDAD_POCIONES_PJ, cantidadPociones);
    SetLocalInt(oPC, InvRed_CANTIDAD_VARITAS_PJ, cantidadVaritas);
    SetLocalInt(oPC, InvRed_CANTIDAD_VIROTES_PJ, cantidadVirotes);

    SetLocalInt(oPC, ESTADO_INVENTARIO_REDUCIDO, INVENTARIO_REDUCIDO_ACTIVADO);
}

void InventarioReducido_onAcquire( object oPC, object oItem );
void InventarioReducido_onAcquire( object oPC, object oItem )
{
if (GetLocalInt(oPC, ESTADO_INVENTARIO_REDUCIDO)==INVENTARIO_REDUCIDO_ACTIVADO && GetLocalInt(GetArea(oPC), InvRed_AREA_PERMITE_CRAFT)==FALSE) {
    int maximo;
    string variableParaModificar, mensaje;
    int tipoBase = GetBaseItemType(oItem);
    switch (tipoBase) {
        case BASE_ITEM_ARROW:          maximo = InvRed_MAXIMO_FLECHAS;
                                       variableParaModificar = InvRed_CANTIDAD_FLECHAS_PJ; mensaje = "flechas";
                                       break;
        case BASE_ITEM_BASTARDSWORD:   maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_BATTLEAXE:      maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_BELT:           maximo = InvRed_MAXIMO_CINTURONES;
                                       variableParaModificar = InvRed_CANTIDAD_CINTURONES_PJ; mensaje = "cinturones";
                                       break;
        case BASE_ITEM_BOLT:           maximo = InvRed_MAXIMO_VIROTES;
                                       variableParaModificar = InvRed_CANTIDAD_VIROTES_PJ; mensaje = "virotes";
                                       break;
        case BASE_ITEM_BOOTS:          maximo = InvRed_MAXIMO_BOTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BOTAS_PJ; mensaje = "botas";
                                       break;
        case BASE_ITEM_BRACER:         maximo = InvRed_MAXIMO_GUANTES;
                                       variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; mensaje = "guantes";
                                       break;
        case BASE_ITEM_BULLET:         maximo = InvRed_MAXIMO_PIEDRAS;
                                       variableParaModificar = InvRed_CANTIDAD_PIEDRAS_PJ; mensaje = "piedras";
                                       break;
        case BASE_ITEM_CLOAK:          maximo = InvRed_MAXIMO_CAPAS;
                                       variableParaModificar = InvRed_CANTIDAD_CAPAS_PJ; mensaje = "capas";
                                       break;
        case BASE_ITEM_CLUB:           maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_DAGGER:         maximo = InvRed_MAXIMO_DAGAS;
                                       variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; mensaje = "dagas";
                                       break;
        case BASE_ITEM_DART:           maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_DIREMACE:       maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_DOUBLEAXE:      maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_DWARVENWARAXE:  maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_GLOVES:         maximo = InvRed_MAXIMO_GUANTES;
                                       variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; mensaje = "guantes";
                                       break;
        case BASE_ITEM_GREATAXE:       maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_GREATSWORD:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HALBERD:        maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HANDAXE:        maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_HEAVYCROSSBOW:  maximo = InvRed_MAXIMO_BALLESTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; mensaje = "ballestas";
                                       break;
        case BASE_ITEM_HEAVYFLAIL:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HELMET:         maximo = InvRed_MAXIMO_CASCOS;
                                       variableParaModificar = InvRed_CANTIDAD_CASCOS_PJ; mensaje = "cascos";
                                       break;
        case BASE_ITEM_KATANA:         maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_KUKRI:          maximo = InvRed_MAXIMO_DAGAS;
                                       variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; mensaje = "dagas";
                                       break;
        case BASE_ITEM_LARGESHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_LIGHTCROSSBOW:  maximo = InvRed_MAXIMO_BALLESTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; mensaje = "ballestas";
                                       break;
        case BASE_ITEM_LIGHTFLAIL:     maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_LIGHTHAMMER:    maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_LIGHTMACE:      maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_LONGBOW:        maximo = InvRed_MAXIMO_ARCOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; mensaje = "arcos";
                                       break;
        case BASE_ITEM_LONGSWORD:      maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_MAGICROD:       maximo = InvRed_MAXIMO_VARITAS;
                                       variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; mensaje = "varitas";
                                       break;
        case BASE_ITEM_MAGICSTAFF:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_MAGICWAND:      maximo = InvRed_MAXIMO_VARITAS;
                                       variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; mensaje = "varitas";
                                       break;
        case BASE_ITEM_MORNINGSTAR:    maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_POTIONS:        maximo = InvRed_MAXIMO_POCIONES;
                                       variableParaModificar = InvRed_CANTIDAD_POCIONES_PJ; mensaje = "pociones";
                                       break;
        case BASE_ITEM_QUARTERSTAFF:   maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_RAPIER:         maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_SCIMITAR:       maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_SCYTHE:         maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_SHORTBOW:       maximo = InvRed_MAXIMO_ARCOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; mensaje = "arcos";
                                       break;
        case BASE_ITEM_SHORTSPEAR:     maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_SHORTSWORD:     maximo = InvRed_MAXIMO_ESPADAS_CORTAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_CORTAS_PJ; mensaje = "espadas cortas";
                                       break;
        case BASE_ITEM_SHURIKEN:       maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_SICKLE:         maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_SMALLSHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_THROWINGAXE:    maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_TOWERSHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_TWOBLADEDSWORD: maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_WARHAMMER:      maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_ARMOR:       {  if (GetBaseAC(oItem)==0) {
                                           maximo = InvRed_MAXIMO_ROPA;
                                           variableParaModificar = InvRed_CANTIDAD_ROPA_PJ;
                                           mensaje = "ropas";
                                       } else {
                                           maximo = InvRed_MAXIMO_ARMADURAS;
                                           variableParaModificar = InvRed_CANTIDAD_ARMADURAS_PJ;
                                           mensaje = "armaduras";
                                       }
                                       break; }
    }
    if (variableParaModificar!="") {
        int cantidad = GetLocalInt(oPC, variableParaModificar);
        if (IPS_Item_getAmmoPacketStackSize(oItem) > 0)
            cantidad += IPS_Item_getAmmoPacketStackSize(oItem);
        else if (Item_getIsAmmo(oItem) || tipoBase==BASE_ITEM_POTIONS) {
            // Si es municion y no es paquete, por problemas con las pilas, hay que contar todo de nuevo.
            cantidad = 0;
            object itemIterado = GetFirstItemInInventory(oPC);
            while (GetIsObjectValid(itemIterado)) {
                if (GetBaseItemType(itemIterado)==tipoBase)
                    cantidad += GetItemStackSize(itemIterado);
                itemIterado = GetNextItemInInventory(oPC);
            }
            itemIterado = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
            itemIterado = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
            itemIterado = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
        }
        else
            cantidad++;
        SetLocalInt(oPC, variableParaModificar, cantidad);
        if (cantidad > maximo) {
            Item_tirar( oItem, oPC );
            cantidad--;
        }
        SendMessageToPC(oPC, "Llevas "+IntToString(cantidad)+" de "+IntToString(maximo)+" "+mensaje+".");
    }
}
}


void InventarioReducido_onUnacquire( object oPC, object oItem );
void InventarioReducido_onUnacquire( object oPC, object oItem )
{
    int tipoBase = GetBaseItemType(oItem);
    string variableParaModificar;
        switch (tipoBase) {
            case BASE_ITEM_ARROW:               variableParaModificar = InvRed_CANTIDAD_FLECHAS_PJ; break;
            case BASE_ITEM_BASTARDSWORD:        variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; break;
            case BASE_ITEM_BATTLEAXE:           variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_BELT:                variableParaModificar = InvRed_CANTIDAD_CINTURONES_PJ; break;
            case BASE_ITEM_BOLT:                variableParaModificar = InvRed_CANTIDAD_VIROTES_PJ; break;
            case BASE_ITEM_BOOTS:               variableParaModificar = InvRed_CANTIDAD_BOTAS_PJ; break;
            case BASE_ITEM_BRACER:              variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; break;
            case BASE_ITEM_BULLET:              variableParaModificar = InvRed_CANTIDAD_PIEDRAS_PJ; break;
            case BASE_ITEM_CLOAK:               variableParaModificar = InvRed_CANTIDAD_CAPAS_PJ; break;
            case BASE_ITEM_CLUB:                variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; break;
            case BASE_ITEM_DAGGER:              variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; break;
            case BASE_ITEM_DART:                variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; break;
            case BASE_ITEM_DIREMACE:            variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_DOUBLEAXE:           variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_DWARVENWARAXE:       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_GLOVES:              variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; break;
            case BASE_ITEM_GREATAXE:            variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_GREATSWORD:          variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_HALBERD:             variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_HANDAXE:             variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; break;
            case BASE_ITEM_HEAVYCROSSBOW:       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; break;
            case BASE_ITEM_HEAVYFLAIL:          variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_HELMET:              variableParaModificar = InvRed_CANTIDAD_CASCOS_PJ; break;
            case BASE_ITEM_KATANA:              variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; break;
            case BASE_ITEM_KUKRI:               variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; break;
            case BASE_ITEM_LARGESHIELD:         variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; break;
            case BASE_ITEM_LIGHTCROSSBOW:       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; break;
            case BASE_ITEM_LIGHTFLAIL:          variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_LIGHTHAMMER:         variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; break;
            case BASE_ITEM_LIGHTMACE:           variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; break;
            case BASE_ITEM_LONGBOW:             variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; break;
            case BASE_ITEM_LONGSWORD:           variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; break;
            case BASE_ITEM_MAGICROD:            variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; break;
            case BASE_ITEM_MAGICSTAFF:          variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_MAGICWAND:           variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; break;
            case BASE_ITEM_MORNINGSTAR:         variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_POTIONS:             variableParaModificar = InvRed_CANTIDAD_POCIONES_PJ; break;
            case BASE_ITEM_QUARTERSTAFF:        variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_RAPIER:              variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; break;
            case BASE_ITEM_SCIMITAR:            variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; break;
            case BASE_ITEM_SCYTHE:              variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_SHORTBOW:            variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; break;
            case BASE_ITEM_SHORTSPEAR:          variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_SHORTSWORD:          variableParaModificar = InvRed_CANTIDAD_ESPADAS_CORTAS_PJ; break;
            case BASE_ITEM_SHURIKEN:            variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; break;
            case BASE_ITEM_SICKLE:              variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; break;
            case BASE_ITEM_SMALLSHIELD:         variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; break;
            case BASE_ITEM_THROWINGAXE:         variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; break;
            case BASE_ITEM_TOWERSHIELD:         variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; break;
            case BASE_ITEM_TWOBLADEDSWORD:      variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; break;
            case BASE_ITEM_WARHAMMER:           variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; break;
            case BASE_ITEM_ARMOR:           {   if (GetBaseAC(oItem)==0)
                                                    variableParaModificar = InvRed_CANTIDAD_ROPA_PJ;
                                                else
                                                    variableParaModificar = InvRed_CANTIDAD_ARMADURAS_PJ;
                                                break; }
        }
    if (variableParaModificar!="") {
        int cantidad = GetLocalInt(oPC, variableParaModificar);
        if (IPS_Item_getAmmoPacketStackSize(oItem) > 1)
            cantidad -= IPS_Item_getAmmoPacketStackSize(oItem);
        else if (Item_getIsAmmo(oItem) || tipoBase==BASE_ITEM_POTIONS) {
            // Si es municion y no es paquete, por problemas con las pilas, hay que contar todo de nuevo.
            cantidad = 0;
            object itemIterado = GetFirstItemInInventory(oPC);
            while (GetIsObjectValid(itemIterado)) {
                if (GetBaseItemType(itemIterado)==tipoBase)
                    cantidad += GetItemStackSize(itemIterado);
                itemIterado = GetNextItemInInventory(oPC);
            }
            itemIterado = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
            itemIterado = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
            itemIterado = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            cantidad += (GetBaseItemType(itemIterado)==tipoBase) ? GetItemStackSize(itemIterado) : 0;
        } else cantidad--;
        SetLocalInt(oPC, variableParaModificar, cantidad);
        //SendMessageToPC(oPC, "InvRed: "+variableParaModificar+"= "+IntToString(cantidad));
    }
}


void InventarioReducido_onEquip( object oPC, object oItem );
void InventarioReducido_onEquip( object oPC, object oItem )
{
if (GetLocalInt(oPC, ESTADO_INVENTARIO_REDUCIDO)==INVENTARIO_REDUCIDO_ACTIVADO && GetLocalInt(GetArea(oPC), InvRed_AREA_PERMITE_CRAFT)==FALSE) {
    int maximo;
    string variableParaModificar, mensaje;
    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_ARROW:          maximo = InvRed_MAXIMO_FLECHAS;
                                       variableParaModificar = InvRed_CANTIDAD_FLECHAS_PJ; mensaje = "flechas";
                                       break;
        case BASE_ITEM_BASTARDSWORD:   maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_BATTLEAXE:      maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_BELT:           maximo = InvRed_MAXIMO_CINTURONES;
                                       variableParaModificar = InvRed_CANTIDAD_CINTURONES_PJ; mensaje = "cinturones";
                                       break;
        case BASE_ITEM_BOLT:           maximo = InvRed_MAXIMO_VIROTES;
                                       variableParaModificar = InvRed_CANTIDAD_VIROTES_PJ; mensaje = "virotes";
                                       break;
        case BASE_ITEM_BOOTS:          maximo = InvRed_MAXIMO_BOTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BOTAS_PJ; mensaje = "botas";
                                       break;
        case BASE_ITEM_BRACER:         maximo = InvRed_MAXIMO_GUANTES;
                                       variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; mensaje = "guantes";
                                       break;
        case BASE_ITEM_BULLET:         maximo = InvRed_MAXIMO_PIEDRAS;
                                       variableParaModificar = InvRed_CANTIDAD_PIEDRAS_PJ; mensaje = "piedras";
                                       break;
        case BASE_ITEM_CLOAK:          maximo = InvRed_MAXIMO_CAPAS;
                                       variableParaModificar = InvRed_CANTIDAD_CAPAS_PJ; mensaje = "capas";
                                       break;
        case BASE_ITEM_CLUB:           maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_DAGGER:         maximo = InvRed_MAXIMO_DAGAS;
                                       variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; mensaje = "dagas";
                                       break;
        case BASE_ITEM_DART:           maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_DIREMACE:       maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_DOUBLEAXE:      maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_DWARVENWARAXE:  maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_GLOVES:         maximo = InvRed_MAXIMO_GUANTES;
                                       variableParaModificar = InvRed_CANTIDAD_GUANTES_PJ; mensaje = "guantes";
                                       break;
        case BASE_ITEM_GREATAXE:       maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_GREATSWORD:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HALBERD:        maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HANDAXE:        maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_HEAVYCROSSBOW:  maximo = InvRed_MAXIMO_BALLESTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; mensaje = "ballestas";
                                       break;
        case BASE_ITEM_HEAVYFLAIL:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_HELMET:         maximo = InvRed_MAXIMO_CASCOS;
                                       variableParaModificar = InvRed_CANTIDAD_CASCOS_PJ; mensaje = "cascos";
                                       break;
        case BASE_ITEM_KATANA:         maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_KUKRI:          maximo = InvRed_MAXIMO_DAGAS;
                                       variableParaModificar = InvRed_CANTIDAD_DAGAS_PJ; mensaje = "dagas";
                                       break;
        case BASE_ITEM_LARGESHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_LIGHTCROSSBOW:  maximo = InvRed_MAXIMO_BALLESTAS;
                                       variableParaModificar = InvRed_CANTIDAD_BALLESTAS_PJ; mensaje = "ballestas";
                                       break;
        case BASE_ITEM_LIGHTFLAIL:     maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_LIGHTHAMMER:    maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_LIGHTMACE:      maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_LONGBOW:        maximo = InvRed_MAXIMO_ARCOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; mensaje = "arcos";
                                       break;
        case BASE_ITEM_LONGSWORD:      maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_MAGICROD:       maximo = InvRed_MAXIMO_VARITAS;
                                       variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; mensaje = "varitas";
                                       break;
        case BASE_ITEM_MAGICSTAFF:     maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_MAGICWAND:      maximo = InvRed_MAXIMO_VARITAS;
                                       variableParaModificar = InvRed_CANTIDAD_VARITAS_PJ; mensaje = "varitas";
                                       break;
        case BASE_ITEM_MORNINGSTAR:    maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_POTIONS:        maximo = InvRed_MAXIMO_POCIONES;
                                       variableParaModificar = InvRed_CANTIDAD_POCIONES_PJ; mensaje = "pociones";
                                       break;
        case BASE_ITEM_QUARTERSTAFF:   maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_RAPIER:         maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_SCIMITAR:       maximo = InvRed_MAXIMO_ESPADAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_PJ; mensaje = "espadas";
                                       break;
        case BASE_ITEM_SCYTHE:         maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_SHORTBOW:       maximo = InvRed_MAXIMO_ARCOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARCOS_PJ; mensaje = "arcos";
                                       break;
        case BASE_ITEM_SHORTSPEAR:     maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_SHORTSWORD:     maximo = InvRed_MAXIMO_ESPADAS_CORTAS;
                                       variableParaModificar = InvRed_CANTIDAD_ESPADAS_CORTAS_PJ; mensaje = "espadas cortas";
                                       break;
        case BASE_ITEM_SHURIKEN:       maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_SICKLE:         maximo = InvRed_MAXIMO_ARMAS_PEQUENIAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PEQUENIAS_PJ; mensaje = "armas pequeñas";
                                       break;
        case BASE_ITEM_SMALLSHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_THROWINGAXE:    maximo = InvRed_MAXIMO_ARROJADIZAS;
                                       variableParaModificar = InvRed_CANTIDAD_ARROJADIZAS_PJ; mensaje = "armas arrojadizas";
                                       break;
        case BASE_ITEM_TOWERSHIELD:    maximo = InvRed_MAXIMO_ESCUDOS;
                                       variableParaModificar = InvRed_CANTIDAD_ESCUDOS_PJ; mensaje = "escudos";
                                       break;
        case BASE_ITEM_TWOBLADEDSWORD: maximo = InvRed_MAXIMO_ARMAS_2MANOS;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_2MANOS_PJ; mensaje = "armas grandes";
                                       break;
        case BASE_ITEM_WARHAMMER:      maximo = InvRed_MAXIMO_ARMAS_PRINCIPALES;
                                       variableParaModificar = InvRed_CANTIDAD_ARMAS_PRINCIPALES_PJ; mensaje = "armas principales";
                                       break;
        case BASE_ITEM_ARMOR:       {  if (GetBaseAC(oItem)==0) {
                                           maximo = InvRed_MAXIMO_ROPA;
                                           variableParaModificar = InvRed_CANTIDAD_ROPA_PJ;
                                           mensaje = "ropas";
                                       } else {
                                           maximo = InvRed_MAXIMO_ARMADURAS;
                                           variableParaModificar = InvRed_CANTIDAD_ARMADURAS_PJ;
                                           mensaje = "armaduras";
                                       }
                                       break; }
    }
    if (variableParaModificar!="") {
        int cantidad = GetLocalInt(oPC, variableParaModificar);
        if (cantidad > maximo) {
            Item_tirar( oItem, oPC );
            cantidad -= (FindSubString(GetName(oItem), IPS_PACKET_NAME_PREFIX) < 0) ? GetItemStackSize(oItem) : IPS_Item_getAmmoPacketStackSize(oItem);
        }
        SendMessageToPC(oPC, "Llevas "+IntToString(cantidad)+" de "+IntToString(maximo)+" "+mensaje+".");
    }
}
}
