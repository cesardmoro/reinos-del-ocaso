/********** Control de Intercambio de Bienes - item gold value adapter *********
package: CIB - item gold value adapter - include
Author: Inquisidor
Descripcon: Adaptadores que determinan como ve el CIB el valor genuino y
aparente de un item.
*******************************************************************************/
#include "IPS_basic_inc"


// Funcion usada por el CIB para determinar el valor aparente en oro de los items.
// Toda variacion en el valor aparente de un item que se pretenda sea conciderada por el CIB
// debe ser implementada modificando esta funcion
// El valor aparente suele ser el precio al que los PJs venden sus items a los mercaderes.
// El CIB usara el valor devuelto por este valor para mostrar valores di items al PJ.
int CIB_getItemApparentGoldValue( object item, object inspector );
int CIB_getItemApparentGoldValue( object item, object inspector ) {
    return IPS_Item_getIsAdept( item ) ? IPS_Item_getApparentGoldValue( item, inspector ) : GetGoldPieceValue( item );
}

// Funcion usada por el CIB para determinar el valor genuino en oro de los items.
// Toda variacion en el valor genuino de un item que se pretenda sea conciderada por el CIB
// debe ser implementada modificando esta funcion
// El valor genuino de un item no es necesariamente el precio al que los
// PJ venden los items a los mercaderes (que esta modificado por su apraise), sino el
// relacionado a la calidad del item.
// El CIB usará el valor devuelto por esta funcion para ajustar la balanza de intercambio
int CIB_getItemGenuineGoldValue( object item );
int CIB_getItemGenuineGoldValue( object item ) {
    return IPS_Item_getIsAdept( item ) ? IPS_Item_getGenuineGoldValue( item ) : GetGoldPieceValue( item );
}

