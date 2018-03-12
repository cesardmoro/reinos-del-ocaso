/************************** Muerte - perdida de items **************************
package: Muerte - perdida de items - include
Author: Inquisidor
Descripcion: perdida de items al morir
*******************************************************************************/

#include "CIB_frente"
#include "SPC_inc"
#include "IPS_basic_inc"


// constante de proporcionalidad usada por determinarSiSePierdeItem
const float Muerte_RELACION_PERDIDAS_SOBRE_CONCERVAS_POR_UNIDAD_DE_DESAFIO = 0.05;
//agregado por Inquisidor
// Determina si el item se queda en el cadaver o va con el alma.
// La relacion entre perdidas y concervas es proporcional a: la dificultad del area relativa al PJ dueño, y a la dificultad de que el PJ consiga el item
int Muerte_determinarSiSePierdeItem( object item, int nivelPj );
int Muerte_determinarSiSePierdeItem( object item, int nivelPj ) {
    // nivelItem es el CR de las areas donde suelen caer items del precio de este item. Ver IPS_generateGoldValue(..)
    int crItem = FloatToInt(
        IPS_Item_getIsAdept( item )
        ? IPS_Item_getCr( item )
        : IPS_levelToCr( IntToFloat( GetGoldPieceValue( item ) / IPS_ITEM_VALUE_PER_LEVEL ) )
    );
    if( crItem <= 3 )
        return FALSE;
    float desafioDelItem = SisPremioCombate_poderRelativoSujeto( crItem, nivelPj );
    float relacionPerdidasSobreConcervas = desafioDelItem * Muerte_RELACION_PERDIDAS_SOBRE_CONCERVAS_POR_UNIDAD_DE_DESAFIO;
    float chancePerderItem = relacionPerdidasSobreConcervas / ( relacionPerdidasSobreConcervas + 1.0 );
//    SendMessageToPC( GetFirstPC(), "Muerte_determinarSiSePierdeItem: item="+GetName(item)+", nivelItem="+IntToString( nivelItem )+", desafioItem="+FloatToString( desafioDelItem )+", perdidas/concervas="+FloatToString(relacionPerdidasSobreConcervas)+", chance="+FloatToString( chancePerderItem ) );
    return Random( 1000 ) < FloatToInt( chancePerderItem*1000.0 );
}


// Se encarga de determinar cuales bienes del 'pjMatado' (=OBJECT_SELF) se quedan en el cadaver y cuales los concerva el alma (OBJECT_SELF).
// El oro queda todo en el cadaver, y los items solo algunos.
// Si es un area sin desafio conciderable para el muerto, se aplica el CIB. Esto no evita, pero complica la burla del CIB (pasar bienes dejandose matar).
// ADVERTENCIA: la función 'viajarAlFugue_paso2(..)' que llama a esta función asume que esta es instantanea. Si alguna modificacion hace que deje de serlo, conciderar modificar viajarAlFugue_paso2(..).
void Muerte_perdidaDeBienes( object cueporPjMatado, int oroQueCargaba, object matador );
void Muerte_perdidaDeBienes( object cueporPjMatado, int oroQueCargaba, object matador ) {
    object pjMatado = OBJECT_SELF;
    int crAreaMuerte = GetLocalInt( GetArea( cueporPjMatado ), RS_crArea_PN );
    int nivelPjMatado = GetHitDice( pjMatado );

    // calculo del desafio que ofrecen los encuentros del area donde muere el PJ
    float desafioDelArea = crAreaMuerte <= 1 ? 0.0 : SisPremioCombate_poderRelativoSujeto( crAreaMuerte, nivelPjMatado );

    //Si el area donde muere no tiene desafio conciderable para el PJ muerto, los bienes perdidos quedan registrados con 'pjMatado' como propietario cosa que se aplique el CIB (control de intercambio de bienes). O sea que sería como si 'pjMatado' los dejara en el suelo intencionalmente.
    int esCibAplicable = desafioDelArea < 0.8;
    int nuevoEstadoItemsPerdidos = esCibAplicable ? CIB_estado_POSEIDO : CIB_estado_LIBRE;

    //Meter el oro en una bolsa looteable dentro del cuerpo.
    if( oroQueCargaba > 0) {
        int oroGanado = RegGan_getOroGanado( pjMatado );
        int oroQueTeniaMenosGastos = oroQueCargaba - oroGanado;
        if( oroQueTeniaMenosGastos > 0 ) {
            int umbral = 80*nivelPjMatado*nivelPjMatado;
            int oroQueQuedaEnAlma = oroQueTeniaMenosGastos <= umbral ? oroQueTeniaMenosGastos : umbral + ((oroQueTeniaMenosGastos - umbral)*4)/5;
            GiveGoldToCreature( pjMatado, oroQueQuedaEnAlma );
        }
        else
            oroGanado = oroQueCargaba;

        if( oroGanado > 0 ) {
            object bolsaOro;
            if( esCibAplicable )
                bolsaOro = CIB_Oro_generarEnContenedor( cueporPjMatado, oroGanado, FALSE, GetName( pjMatado ), pjMatado );
            else
                bolsaOro = CIB_Oro_generarEnContenedor( cueporPjMatado, oroGanado, TRUE );
            SetDroppableFlag( bolsaOro, TRUE );
        }
    }
    RegGan_reset( pjMatado );

/*  QUITADO cuando se retrocedió con la perdida de ítems.
    // si el PJ es matado por un PJ en un area de CR menor al nivel del matador, no hay drop de items.
    if( !GetIsPC(matador) || GetHitDice(matador) <= crAreaMuerte ) {

//    SendMessageToPC( GetFirstPC(), "Muerte_perdidaDeBienes: desafioArea="+FloatToString(desafioDelArea) );

        // A todo item equipado: determinar si queda en el cadaver o va con el alma
        int slotIdIterator = NUM_INVENTORY_SLOTS;
        while( --slotIdIterator >= 0 ) {
            object item = GetItemInSlot( slotIdIterator, pjMatado );
            if( Muerte_determinarSiSePierdeItem( item, nivelPjMatado ) ) {
                if( IPS_Item_getIsAdept( item ) )
                    IPS_Item_setAsUnknown( item );
                else
                    SetIdentified( item, FALSE );
                // NO FUNCA: para que ande
                // 1) si se ejecuta esto despues que 'cuerpoPjMatado' haya sido matada, hay que averiguar cual es el contenedor que crea el motor al morir la criatura
                // 2) si se ejecuta esto antes de que cuerpo PjMatado haya sido matada, hay que asegurar que la transferencia se realice antes que 'cuerpoPjMatado' sea matado.
                CIB_transferirItemAContenedor( item, cueporPjMatado, nuevoEstadoItemsPerdidos, TRUE );
            }
        }

        // A todo item en el inventario: determinar si queda en el cadaver o va con el alma
        object itemIterator = GetFirstItemInInventory( pjMatado );
        while( itemIterator != OBJECT_INVALID ) {
            if( Muerte_determinarSiSePierdeItem( itemIterator, nivelPjMatado ) ) {
                if( IPS_Item_getIsAdept( itemIterator ) )
                    IPS_Item_setAsUnknown( itemIterator );
                else
                    SetIdentified( itemIterator, FALSE );
                // NO FUNCA: para que ande
                // 1) si se ejecuta esto despues que 'cuerpoPjMatado' haya sido matada, hay que averiguar cual es el contenedor que crea el motor al morir la criatura
                // 2) si se ejecuta esto antes de que cuerpo PjMatado haya sido matada, hay que asegurar que la transferencia se realice antes que 'cuerpoPjMatado' sea matado.
                CIB_transferirItemAContenedor( itemIterator, cueporPjMatado, nuevoEstadoItemsPerdidos, TRUE );
            }
            itemIterator = GetNextItemInInventory( pjMatado );
        }
    }
*/
}


