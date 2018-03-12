/******************* ResourcesList **********************
package: Utilities - ResourcesList
Autor: Inquisidor
Descripcion: ResourcesList es un contenedor tipo lista de nombres de recursos.
*******************************************************************************/

// agrega el 'recurso' al comienzo de 'this' lista de nombres de recursos
// Devuelva la lista modificada
// RECOMENDACION: poner los .ncs correspondientes a los handlers en el scrit cache
string RL_addFront( string this, string recurso );
string RL_addFront( string this, string recurso ) {
    recurso = GetStringLeft(recurso,16);
    return recurso + GetStringLeft("                 ", 17-GetStringLength(recurso) ) + this;
}

// Obtiene el recurso que esta al comienzo de la cola
string RL_getFront( string this );
string RL_getFront( string this ) {
    return GetSubString( this, 0, FindSubString( this, " " ) );
}

// Si la lista contiene mas de 'newSize' elementos, son removidos los suficientes elementos de atras como para que queden los 'newSize' de mas adelante
string RL_trunkFront( string this, int newSize );
string RL_trunkFront( string this, int newSize ) {
    return GetStringLeft( this, newSize*17 );
}


// agrega el 'recurso' al final de 'this' lista de nombres de recursos
// Devuelva la lista modificada
// RECOMENDACION: poner los .ncs correspondientes a los handlers en el scrit cache
string RL_addBack( string this, string recurso );
string RL_addBack( string this, string recurso ) {
    recurso = GetStringLeft(recurso,16);
    return this + recurso + GetStringLeft( "                 ", 17-GetStringLength(recurso) );
}

// Da la lista que resulta de agregar al final de 'this' todos los recursos contenidos en 'other'.
string RL_appendBack( string this, string other );
string RL_appendBack( string this, string other ) {
    return this + other;
}

// Obtiene el recurso que esta al final de la cola
string RL_getBack( string this );
string RL_getBack( string this ) {
    int frontPos = GetStringLength(this)-17;
    return GetSubString( this, frontPos, FindSubString( this, " ", frontPos ) - frontPos );
}

// quita el 'recurso' al comienzo de 'this' lista de nombres de recursos
// Devuelva la lista modificada
string RL_removeFront( string this );
string RL_removeFront( string this ) {
    return GetStringRight( this, GetStringLength(this)-17 );
}

// quita el 'recurso' al final de 'this' lista de nombres de recursos
// Devuelva la lista modificada
string RL_removeBack( string this );
string RL_removeBack( string this ) {
    return GetStringLeft( this, GetStringLength(this)-17 );
}

//Da true si 'this' lista contiene el 'recurso'.
int RL_isContained( string this, string resource );
int RL_isContained( string this, string resource ) {
    return FindSubString( this, resource+" " ) >= 0;
}


// Asumiendo que los recursos contenidos en la lista son scripts, los ejecuta todos ejecuta todos en orden desde el primero hasta el último.
void RL_fire( string this, object actionSubject );
void RL_fire( string this, object actionSubject ) {
//    SendMessageToPC( GetFirstPC(), "RL_fire: this=["+this+"], length="+IntToString(GetStringLength(this)) );
    int eolHandlerPos = GetStringLength( this );
    int handlerPos = 0;
    while( handlerPos < eolHandlerPos ) {
        string handler = GetSubString( this, handlerPos, 17 );
        handler = GetStringLeft( handler, FindSubString( handler, " " ) );
//        SendMessageToPC( GetFirstPC(), "RL_fire: handler=["+handler+"], length="+IntToString(GetStringLength(handler)) );
        ExecuteScript( handler, actionSubject );
        handlerPos += 17;
    }
}
