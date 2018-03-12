/*************************** class VectorObjObj implements Instance ******************************
Autor: Guido Gustavo Pollitzer
Version: 0.1
Descripcion: vector de objetos (motor).
******************************************************************************************/

#include "Fwk_Instance"
#include "Fwk_object"

const string VectorObj_TYPE_ID = "Ctnr_VectorObj0";

const string VectorObj_size_FIELD = ".size";


void VectorObj_constructor( struct Address this );
void VectorObj_constructor( struct Address this ) {
    // parent is an interface
    Instance_setType( this, VectorObj_TYPE_ID );
    SetLocalInt( this.nbh, this.path + VectorObj_size_FIELD, 0 );
}


int VectorObj_getSize( struct Address this );
int VectorObj_getSize( struct Address this ) {
    return GetLocalInt( this.nbh, this.path + VectorObj_size_FIELD );
}


object VectorObj_getAt( struct Address this, int index );
object VectorObj_getAt( struct Address this, int index ) {
    if( 0 <= index && index < VectorObj_getSize( this ) )
        return GetLocalObject( this.nbh, IntToString( index ) + Address_CHILD_PARENT_DELIMITER + this.path );// Aqui se expandio 'Address_buildChild()'
    else {
        PrintString( "VectorObj_getAt: index out of bounds" );
        return OBJECT_INVALID;
    }
}


// Advertenia: esta operacion (al igual que todas las que accedan a los
// elementos contenidos) requiere que el contenedor y todos los elementos
// contenidos sean vecinos.
void VectorObj_destructor( struct Address this );
void VectorObj_destructor( struct Address this ) { Instance_destructor( this ); }
void VectorObj_destructor_UMC( struct Address this ) {

    string sizeAds = this.path + VectorObj_size_FIELD;

    object element;
    int iterator = GetLocalInt( this.nbh, sizeAds );
    while( --iterator >= 0 ) {
        string elementRef = IntToString( iterator ) + Address_CHILD_PARENT_DELIMITER + this.path;// Aqui se expandio 'Address_buildChild()'
        element = GetLocalObject( this.nbh, elementRef );
        SignalEvent( element, EventUserDefined( object_EVENT_DESTRUCTOR ) );
        DeleteLocalString( this.nbh, elementRef );
    }
    DeleteLocalInt( this.nbh, sizeAds );
    Instance_destructor_UMC( this );
}

int VectorObj_isEqual( struct Address this, struct Address other );
int VectorObj_isEqual( struct Address this, struct Address other ) { return Instance_isEqual( this, other ); }
int VectorObj_isEqual_UMC( struct Address this, struct Address other ) {
    PrintString( "VectorObj_isEqual: not implemented" );
    return -1;
}


string VectorObj_toText( struct Address this);
string VectorObj_toText( struct Address this) { return Instance_toText( this ); }
string VectorObj_toText_UMC( struct Address this) {
    string resultado = "{";
    int index;
//    SendMessageToPC( GetFirstPC(), "VectorObj_toText_UMC: size="+IntToString(VectorObj_getSize(this) ) );
    for( index=VectorObj_getSize( this ); --index>0; ) {
        object element = VectorObj_getAt( this, index );
//        SendMessageToPC( GetFirstPC(), "VectorObj_toText_UMC: element="+GetName(element) );
        resultado += GetName( element );
        resultado += ",";
    }
    resultado += GetName( VectorObj_getAt( this, 0 ) );
    return resultado + "}";
}


void VectorObj_removeContents( struct Address this );
void VectorObj_removeContents( struct Address this ) {
    string sizeAds = this.path + VectorObj_size_FIELD;
    int iterator = GetLocalInt( this.nbh, sizeAds );
    while( --iterator >= 0 ) {
        DeleteLocalString( this.nbh, IntToString( iterator ) + Address_CHILD_PARENT_DELIMITER + this.path );// Aqui se expandio 'Address_buildChild()'
    }
    SetLocalInt( this.nbh, sizeAds, 0 );
}


void VectorObj_setAt( struct Address this, int index, object element );
void VectorObj_setAt( struct Address this, int index, object element ) {
    if( 0 <= index && index < VectorObj_getSize( this ) )
        SetLocalObject( this.nbh, IntToString( index ) + Address_CHILD_PARENT_DELIMITER + this.path, element ); // Aqui se expandio 'Address_buildChild()'
    else
        PrintString( "VectorObj_setAt: index out of bounds" );
}


object VectorObj_getBack( struct Address this );
object VectorObj_getBack( struct Address this ) {
    int size = VectorObj_getSize( this );
    if( size > 0 )
        return GetLocalObject( this.nbh, IntToString( size - 1 ) + Address_CHILD_PARENT_DELIMITER + this.path );// Aqui se expandio 'Address_buildChild()'
    else {
        PrintString( "VectorObj_getBack: assert failed" );
        return OBJECT_INVALID;
    }
}


void VectorObj_pushBack( struct Address this, object element );
void VectorObj_pushBack( struct Address this, object element ) {
    string sizeAds = this.path + VectorObj_size_FIELD;
    int size = GetLocalInt( this.nbh, sizeAds );
    SetLocalObject( this.nbh, IntToString( size ) + Address_CHILD_PARENT_DELIMITER + this.path, element ); // Aqui se expandio 'Address_buildChild()'
    SetLocalInt( this.nbh, sizeAds, size + 1 );
//    SendMessageToPC( GetFirstPC(), "VectorObj_pushBack: size="+IntToString(VectorObj_getSize(this) ) );
}


object VectorObj_popBack( struct Address this );
object VectorObj_popBack( struct Address this ) {
    string sizeAds = this.path + VectorObj_size_FIELD;
    int backElemIndex = GetLocalInt( this.nbh, sizeAds ) - 1;
    if( backElemIndex >= 0 ) {
        string elementRef = IntToString( backElemIndex ) + Address_CHILD_PARENT_DELIMITER + this.path; // Aqui se expandio 'Address_buildChild()'
        object element = GetLocalObject( this.nbh, elementRef );
        DeleteLocalObject( this.nbh, elementRef );
        SetLocalInt( this.nbh, sizeAds, backElemIndex );
        return element;
    }
    else {
        PrintString( "VectorObj_popBack: assert failed" );
        return OBJECT_INVALID;
    }
}

//void main () {}
