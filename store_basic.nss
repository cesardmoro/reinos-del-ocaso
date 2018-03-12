/////////////////////
// 07/04/07 Script By Inquisidor and Dragoncin
//
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
////////////////////////////

//////////////////////////// CONSTANTES /////////////////////////////
const string Store_GOLD_DATABASE_FILE_NAME = "StoreGold";
const int Store_GOLD_DATABASE_ID_MAX_LENGTH = 32;

const int Store_MAXIMUM_ITEMS_TO_GENERATE_IN_ONE_STEP = 12;

// bits de prohibicion de venta asignados //
const int Store_BIT_PROHIBICION_VENTA_CIB = 1; // = 2^0 Bit asignado al ControlIntercambioBienes
const int Store_BIT_PROHIBICION_VENTA_IPS = 2; // = 2^1 Bit asignado al ItemPropertiesSystem

//////////////////////// VARIABLES DE INSTANCIA DE Store ////////////////////////////////
const string Store_wasOpenedBefore_VN = "StoreWOB";
const string Store_itemsExpectedQuality_PN = "StoreItemsCr";

//////////////////////// VARIABLES DE ISTANCIA DE Item //////////////////////////////////
const string Store_conjuntoProhibicionesVenta_VN = "StoreCPV";
const string Store_expirationDate_VN = "StoreED"; // instante a partir del cual el item es destruido si la tienda es abierta.

//////////////////////// TIPOS DE DATO /////////////////////////////////////////
// tipo de dato devuelto por los onItemArrivesStore handlers
struct Store_PermisoVenta {
    int prohibido;
    int concedido;
};

