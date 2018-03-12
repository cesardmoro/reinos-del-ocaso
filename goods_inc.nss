///////////////////
// Funciones relacionadas con los bienes y sus valores
//
///////////////

#include "ips_basic_inc"

// Devuelve la riqueza total estandar del PJ
int Goods_GetStandardTotalWealth( object oPC );
int Goods_GetStandardTotalWealth( object oPC )
{
    int playerXP = GetXP(oPC);

    // La experiencia de un pj al estar exactamente en su nivel es (nivel * (nivel+1))/2
    // La inversa de esa serie (el nivel para dada exp) hecha funcion es:
    float nivel = 2*playerXP/1000 + 0.25;
    nivel = pow(nivel, 0.5) - 0.5;

    // La riqueza se define como el precio de 24 items del nivel del PJ.
    // Al aplicar esa relacion sobre una variable entera, se recortan los decimales.
    float riquezaEstandar = 24 * IPS_ITEM_VALUE_PER_LEVEL * nivel;

    return FloatToInt(riquezaEstandar);
}


// Devuelve la riqueza total estandar del PJ
int Goods_GetStandardCarriedWealth( object oPC );
int Goods_GetStandardCarriedWealth( object oPC )
{
    int playerXP = GetXP(oPC);

    // La experiencia de un pj al estar exactamente en su nivel es (nivel * (nivel+1))/2
    // La inversa de esa serie (el nivel para dada exp) hecha funcion es:
    float nivel = 2*playerXP/1000 + 0.25;
    nivel = pow(nivel, 0.5) - 0.5;

    // La riqueza se define como el precio de 24 items del nivel del PJ.
    // Al aplicar esa relacion sobre una variable entera, se recortan los decimales.
    float riquezaEstandar = 24 * IPS_ITEM_VALUE_PER_LEVEL * nivel;

    return FloatToInt(riquezaEstandar);
}

// Devuelve la riqueza cargada por el PJ
// considerada como la suma del costo en oro de todos los items llevados por el PJ, más el oro cargado
int Goods_GetCarriedWealth( object oPC );
int Goods_GetCarriedWealth( object oPC )
{
    int riqueza;
    object itemIterado = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(itemIterado)) {
        riqueza += GetGoldPieceValue(itemIterado);
        itemIterado = GetNextItemInInventory(oPC);
    }
    int iterador;
    for (iterador=0; iterador < NUM_INVENTORY_SLOTS; iterador++) {
        itemIterado = GetItemInSlot(iterador, oPC);
        riqueza += GetGoldPieceValue(itemIterado);
    }
    riqueza += GetGold(oPC);
    return riqueza;
}

// Devuelve la riqueza total del PJ
// entendida como la suma del costo en oro de todos los items llevados por el PJ, más el oro cargado
// y sumada a la cantidad de oro que tiene en el banco
int Goods_GetTotalWealth( object oPC );
int Goods_GetTotalWealth( object oPC )
{
    int riqueza = Goods_GetCarriedWealth(oPC);
    riqueza += GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);

    return riqueza;
}
