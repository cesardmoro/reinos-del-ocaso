
// Da la cantidad de PJs que hay en este area.
int Area_getCantidadPjs( object this );
int Area_getCantidadPjs( object this ) {
    int cantPjs = 0;
    object pjIterator = GetFirstPC();
    while( pjIterator != OBJECT_INVALID ) {
        if( !GetIsDM( pjIterator ) && GetArea( pjIterator ) == this )
            cantPjs += 1;
        pjIterator = GetNextPC();
    }
    return cantPjs;
}


// Da TRUE si hay algun PJ en este area.
int Area_isAPjInside( object this );
int Area_isAPjInside( object this ) {
    object pjIterator = GetFirstPC();
    while( pjIterator != OBJECT_INVALID ) {
        if( GetArea( pjIterator ) == this && !GetIsDM( pjIterator) )
            return TRUE;
        pjIterator = GetNextPC();
    }
    return FALSE;
}


// Elige al azar un PJ del area dada. Si no hay PJs en el area, devuelve OBJECT_INVALID
object Area_sortearPj( object this );
object Area_sortearPj( object this ) {

    int cantPjs = Area_getCantidadPjs( this );
    if( cantPjs == 0 )
        return OBJECT_INVALID;

    int sorteo = Random( cantPjs );

    object pjIterator = GetFirstPC();
    do {
        if( !GetIsDM(pjIterator) && GetArea(pjIterator) == this ) {
            if( sorteo == 0 )
                return pjIterator;
            --sorteo;
        }
        pjIterator = GetNextPC();
    }while( pjIterator != OBJECT_INVALID );

    WriteTimestampedLogEntry( "Area_sortearPj: error, unreachable reached" );
    return OBJECT_INVALID;
}

