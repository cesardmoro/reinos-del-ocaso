/****************************** Base62 ************************************
package: Base62 - include
Autor: Inquisidor
Descripcion: Funciones para convertir de base62 a base10 y vice versa.
*******************************************************************************/


const string B62_SYMBOLS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

// convierte 'value' de base10 a base62 de un solo dígito
string B62_build1( int value );
string B62_build1( int value ) {
    return GetSubString( B62_SYMBOLS, value, 1 );
}

// convierte 'value' de base10 a base62 de dos dígitos
string B62_build2( int value );
string B62_build2( int value ) {
    return GetSubString( B62_SYMBOLS, value/62, 1 ) + GetSubString( B62_SYMBOLS, value%62, 1 );
}

// convierte 'value' de base10 a base62 de tres dígitos
string B62_build3( int value );
string B62_build3( int value ) {
    string b62 = GetSubString( B62_SYMBOLS, value%62, 1 );
    value /= 62;
    b62 = GetSubString( B62_SYMBOLS, value%62, 1 ) + b62;
    value /= 62;
    return GetSubString( B62_SYMBOLS, value%62, 1 ) + b62;
}

// convierte 'b62' de base62 a base10. La cifra dada en 'b62' puede tener cualquier cantidad de dígitos mientras no se supere el maximo soportado por un 'int' (2^31-1)
int B62_toInt( string b62 );
int B62_toInt( string b62 ) {
    int result;
    int numDigits = GetStringLength( b62 );
    int digitIterator = 0;
    for( digitIterator = 0; digitIterator < numDigits; ++digitIterator ) {
        result *= 62;
        result += FindSubString( B62_SYMBOLS, GetSubString( b62, digitIterator, 1 ) );
    }
    return result;
}

