const string STORE_TAG = "templo"; // poner aqui el tag del store que se pretende este NPC abra al seleccionar la opcion del diálogo correspondiente.
const string STORE_REF = "storeRef"; // variable local donde se recuerda el store asociado a este NPC

void main() {
    object store = GetLocalObject( OBJECT_SELF, STORE_REF );
    if( !GetIsObjectValid( store ) ) {
        store = GetNearestObjectByTag(STORE_TAG);
        SetLocalObject( OBJECT_SELF, STORE_REF, store );
    }
    OpenStore( store, GetPCSpeaker() );
}
