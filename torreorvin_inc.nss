/********************** Torre de Orvin el rojo - include file ******************
Autor: Inquisidor
Uso: al activar y seleccionar la puerta.
- Si la puerta seleccionada esta sin la traba puesta, se pone la traba y se genera una llave específica para la traba que tiene la puerta.
- Si la puerta seleccionada esta con la traba puesta, se quita la traba permitiendo el paso libre de cualquiera.
Solo funciona con puertas que tienen configurada una llave.
*******************************************************************************/

#include "dm_inc"

/////////////////// Constantes /////////////////////////////
const string TorreOrvin_generadorLlaves_RN = "to_genllaves";
const string TorreOrvin_PREFIJO_TAGS_AREAS = "orvintorre";

////////////////// Door properties ////////////////////////
const string TorreOrvin_aparienciaLlave_PN = "TOal";
const string TorreOrvin_resRefLlave_PN = "TOrl";
const string TorreOrvin_nombreLlave_PN = "TOnl";

void TorreOrvin_generarLlave( object itemActivator, object target ) {
    if(
        GetObjectType( target ) == OBJECT_TYPE_DOOR
        && FindSubString( GetTag(GetArea(target)), TorreOrvin_PREFIJO_TAGS_AREAS) == 0
        && ( GetName(itemActivator)=="Orvin" || GetIsAllowedDM( itemActivator ) )
    ) {
        string targetLockKeyTag = GetLockKeyTag( target );
        if( targetLockKeyTag != "" ) {
            string nombreLlave = GetLocalString( target, TorreOrvin_nombreLlave_PN );
            if( nombreLlave != "" ) {
                if( GetLocked( target ) ) {
                    SetLocked( target, FALSE );
                    SendMessageToPC( itemActivator, "Ahora la puerta puede abrirse libremente" );
                } else {
                    string resRefLlave = GetLocalString( target, TorreOrvin_resRefLlave_PN );
                    object cuerpoLlave;
                    if( resRefLlave == "" ) {
                        int aparienciaDientesLlave = GetLocalInt( target, TorreOrvin_aparienciaLlave_PN );
                        if( 0 < aparienciaDientesLlave && aparienciaDientesLlave < 6 ) {
                            cuerpoLlave = CreateItemOnObject( TorreOrvin_generadorLlaves_RN, itemActivator, 1, targetLockKeyTag );
                            RemoveItemProperty( cuerpoLlave, GetFirstItemProperty( cuerpoLlave) ); // quita la propiedad que la hace maestra
                            SetDroppableFlag(cuerpoLlave, FALSE ); // permite que la llave pueda ser transferida entre PJs
                            DestroyObject( cuerpoLlave );
                            cuerpoLlave = CopyItemAndModify(
                                cuerpoLlave,
                                ITEM_APPR_TYPE_WEAPON_MODEL,
                                ITEM_APPR_WEAPON_MODEL_BOTTOM,
                                aparienciaDientesLlave
                            );
                        } else
                            SendMessageToPC( itemActivator, "Error: puerta mal configurada: la apariencia de los dientes de la llave debe ser de 1 a 5: aparienciaDientesLlave="+ IntToString(aparienciaDientesLlave) );
                    } else {
                        cuerpoLlave = CreateItemOnObject( TorreOrvin_generadorLlaves_RN, itemActivator, 1, targetLockKeyTag );
                        if( !GetIsObjectValid( cuerpoLlave ) )
                            SendMessageToPC( itemActivator, "Error: puerta mal configurada: resRefLlave="+ resRefLlave );
                    }

                    string nombreLlave = GetLocalString( target, TorreOrvin_nombreLlave_PN );
                    SetName( cuerpoLlave, nombreLlave );

                    SetLocked( target, TRUE );
                    SendMessageToPC( itemActivator, "Ahora es necesaria la llave generada para abrir la puerta" );
                }
            } else
                SendMessageToPC( itemActivator, "Error: puerta mal configurada: falta el nombre de la llave que la abre" );
        } else
            SendMessageToPC( itemActivator, "Esa puerta no tiene cerradura" );
    }
}

