/**************** Mercenario - agregar a la lista de exclusion  ****************
Package: Generador de mercenarios - include
Autor: Inquisidor
Descripcion: agrega el mercenaio, aun no contratado con el que se esta hablando, a la lista de mercenario excluidos del area.
Pensada para para usarse como handler del evento "action taken" de una conversacion.
*****************************************************************************/
#include "Mercenario_itf"

void main() {
    object hench = OBJECT_SELF;
    object area = GetArea(hench);

    string exclusionList = GetLocalString( area, MercSpawn_exclusionList_VN );
    if( FindSubString( exclusionList, GetResRef(hench) ) < 0 ) {
        exclusionList += GetResRef(hench);
        SetLocalString( area, MercSpawn_exclusionList_VN, exclusionList );
    }
}
