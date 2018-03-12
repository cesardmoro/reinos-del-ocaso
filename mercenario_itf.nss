/********************** Mercenario interface ******************************
Package: Generador de mercenarios - interface
Autores: Inquisidor
Descripcion: constantes, setter y getters de los mercenarios de taberna.
*****************************************************************************/

const string Mercenario_ES_DE_TABERNA_TAG = "MSedt"; // Tag que tienene los mercenarios creados con 'Mercenario_crear(..)', que es la funcion usada para crear los mercenarios en las tabernas, y revivir los de taberna que murieron.
const string MercSpawn_PC_PERSISTENT_VARIABLES_HOLDER_ITEM_TAG = "cib_oro_racionad"; // tag de algun item no dropeable ni destruible que tengan todos los PJs. Tal item sera usado para guardar de forma persistente las variables que aplican al PJ.

const string Mercenario_itemCuerpo_TAG = "MercICT"; // tag que tienen los items que representan un cuerpo de mercenario de taberna
const string Mercenario_resRef_VN = "MICrr"; // [string] ResRef del mercenario muerto. Se guarda en el item que representa a su cuerpo
const string Mercenario_criaturaCuerpo_VN = "MercCC"; // [object] referencia al cuerpo del mercenario que se guarda en el item que representa al cuerpo.
const string Mercenario_masterName_VN = "MercMN"; // [string]

// area properties
const string MercSpawn_isActive_VN = "MSia";  // [boolean] indica si el área debe intentar generar mercenarios de tarberna. Para que funcione en el área deben estar los waypoints apropiados.

// area variables
const string MercSpawn_estaGeneracionActiva_VN = "MSega";
const string Mercenario_estaCaminando_VN = "MSec";
const string MercSpawn_exclusionList_VN = "MSel";
const string MercSpawn_colaAcomodados_VN = "MSca"; // recuerda cuales son los ResRef de los mercenarios acomodados.

// persisten variables stored in
const string MercSpawn_mercsPreferidos_VN = "MSmp"; //


/// da la cantidad de mercenarios de taberna asociados a 'pc'
int Mercenario_getCantidad( object pc );
int Mercenario_getCantidad( object pc ) {
    int counter;
    object creatureIterator = GetFirstFactionMember( pc, FALSE );
    while( creatureIterator != OBJECT_INVALID ) {
        if(
            GetAssociateType( creatureIterator ) == ASSOCIATE_TYPE_HENCHMAN
            && GetTag( creatureIterator ) == Mercenario_ES_DE_TABERNA_TAG
            && GetMaster( creatureIterator ) == pc
        )
            ++counter;
        creatureIterator = GetNextFactionMember( pc, FALSE );
    }
    return counter;
}
