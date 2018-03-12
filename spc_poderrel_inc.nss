/*******************************************************************************
Package: Sistema Premio Combate - poder relativo
Author: Inquisidor
Version: 1.0
Descripcion: funciones para obtener el poder relativo
*******************************************************************************/
#include "RDO_Races_itf"
#include "Mercenario_itf"

/* Las siguients dos constantes se determinaron matematicamente para que se cumpla lo siguiente:
 poderRelativoSujeto[ 5, 3 ] == poderRelativoSujeto[ 22, 17 ] == 2
Esto significa que segun estos valores, un PJ nivel 5 empata contra dos nivel 3,
y un PJ nivel 22 empata contra dos PJs nivel 17. Las luchas deben ser entre PJs
de la misma clase y sin tretas.
Si esto parece descabellado, contactarme para que calcule los valores de las
constantes partiendo de otros puntos. */
const float K1 = -0.0798878;
const int K2 = 23; // (este debe ser entero para simplificar la implementacion).


// Calcula el poder de un sujeto (conciderando exclusivamente su nivel) respecto a un nivel de referencia.
// Definicion de poder absoluto (conciderando solo el nivel del sujeto):
// Sea X un equipo comprendido por los sujetos de nivel { x1,x2,..,xn } y sea Y otro equipo comprendido
// por los sujetos de nivel { y1, y2,..., yn } tal que empate combatiendo contra el equipo X.
// Entonces la suma de los poderes absolutos de los sujetos de X es igual a la suma de los poderes absolutos de los sujetos en Y.
// Dado que el sistema de lucha del D&D usa tanto variables que dependen de la diferencia
// entre los niveles (hit rate), y variables que dependen del nivel absoluto (hit points,
// damage); es imposible definir una función que de el poder de un personaje o criatura en
// función del nivel de forma absoluta.
// Sin embargo se puede aproximar bastante bien si los poderes se miden relativos a un nivel
// de referencia cercano al nivel de los sujetos que se quiere medir el poder. Esta funcion
// hace justamente eso. Da el poder de un sujeto de nivelX respecto al nivelY de referencia.
// Entonces, usando esta funcion la igualdad de la definicion de poder se daría aproximadamente.
// Tanto mas cuanto mas cercano sea el nivel de referencia a los niveles de los sujetos en juego.
// La igualdad de la definicion de poder quedaría asi:
//    pr(x1,nr) + pr(x2,nr) + ... + pr(xn,nr) =arpox= pr(y1,nr) + pr(y2,nr) +...+ pr(yn,nr)
// donde 'nr' es el nivel de referencia.
// Nota: nivelX y nivelY deben ser ambos mayores a -K1
float SisPremioCombate_poderRelativoSujeto( int nivelX, int nivelY );
float SisPremioCombate_poderRelativoSujeto( int nivelX, int nivelY ) {
    float factorDiferencia;
    int diferenciaLevel = nivelX - nivelY;
    if( diferenciaLevel >= K2 )
        factorDiferencia = 2.0 * K2;
    else if( diferenciaLevel <= -K2 )
        factorDiferencia = 0.5 / K2;
    else
        factorDiferencia = IntToFloat( K2 + diferenciaLevel ) / IntToFloat( K2 - diferenciaLevel );

    return factorDiferencia * ( K1 + nivelX ) / ( K1 + nivelY );
}

// Calcula en nivel X tal que poderRelativoSujeto( X, 'nivelY' ) sea igual a 'poderRelativo'
float SisPremioCombate_calcularNivelParaPoderRelativo( float nivelY, float poderRelativo );
float SisPremioCombate_calcularNivelParaPoderRelativo( float nivelY, float poderRelativo ) {
    float b = K1 + K2 - nivelY + K1*poderRelativo + nivelY*poderRelativo;
    float c = (K2 - nivelY - K2*poderRelativo - nivelY*poderRelativo)*K1 - (K2 + nivelY)*nivelY*poderRelativo;
    return ( -b + pow( b*b - 4*c, 0.5 ) )/2.0;
}


struct ResultadoPoderRelativoParty {
    float poderPersonajes;      // suma de los poderes relativos aportados por los personajes del party
    float poderHenchmans;       // suma de los poderes relativos aportados por los henchmans del party
    float poderMedio;           // media de la distribucion del poder relativo del party ( Sumatoria( poderRel<i>^2 ) / Sumatoria( poderRel<i> ) )
    int cantMiembros;           // cantidad de miembros que se concideran para el poder del party
    int nivelMayor;             // nivel del miembro de mayor nivel de entre los que se concideran para el poder del party
    int nivelMenor;             // nivel del miembro de menor nivel de entre los que se concideran para el poder del party
};

// Calcula el poder del party respecto a una criatura/personaje del nivel dado.
struct ResultadoPoderRelativoParty SisPremioCombate_poderRelativoParty( object party, int nivelReferencia );
struct ResultadoPoderRelativoParty SisPremioCombate_poderRelativoParty( object party, int nivelReferencia ) {
    struct ResultadoPoderRelativoParty resultado;
    resultado.nivelMenor = 2000000; // basta que sea superior al maximo nivel posible
    float sumatoriaPoderesCuadrados;
    object partyMember = GetFirstFactionMember( party, FALSE );
    while( GetIsObjectValid( partyMember ) == TRUE ) {
        int memberAssociateType = GetAssociateType( partyMember );
        if( memberAssociateType == ASSOCIATE_TYPE_NONE ) {
            int memberLevel = GetHitDice( partyMember ) + GetLocalInt( partyMember, RDO_modificadorNivelSubraza_PN );  // sumar el ajuste de nivel para subraza
            if( memberLevel > resultado.nivelMayor )
                resultado.nivelMayor = memberLevel;
            if( memberLevel < resultado.nivelMenor )
                resultado.nivelMenor = memberLevel;
            float memberPower = SisPremioCombate_poderRelativoSujeto( memberLevel, nivelReferencia );
            resultado.poderPersonajes += memberPower;
            sumatoriaPoderesCuadrados += memberPower*memberPower;
            resultado.cantMiembros += 1;
        }
        else if( memberAssociateType == ASSOCIATE_TYPE_HENCHMAN && GetTag(partyMember) == Mercenario_ES_DE_TABERNA_TAG ) {
            int memberLevel = GetHitDice( partyMember );
            if( memberLevel > resultado.nivelMayor )
                resultado.nivelMayor = memberLevel;
            if( memberLevel < resultado.nivelMenor )
                resultado.nivelMenor = memberLevel;
            float memberPower = SisPremioCombate_poderRelativoSujeto( memberLevel, nivelReferencia );
            resultado.poderHenchmans += memberPower;
            sumatoriaPoderesCuadrados += memberPower*memberPower;
            resultado.cantMiembros += 1;
        }
        partyMember = GetNextFactionMember( party, FALSE );
    }
    resultado.poderMedio = sumatoriaPoderesCuadrados /( resultado.poderPersonajes + resultado.poderHenchmans );
//    SendMessageToPC( GetFirstPC(), "poderRelativoParty: poderPersonajes="+FloatToString( resultado.poderPersonajes )+", poderHenchmans="+FloatToString(resultado.poderHenchmans) );
    return resultado;
}


// Calcula el factor pena suave. Da el factor usado para atenuar los premios cuando la dificultadRelativa es menor a uno.
float SisPremioCombate_factorPenaSuave( float dificultadRelativa );
float SisPremioCombate_factorPenaSuave( float dificultadRelativa ) {
    if( dificultadRelativa >= 1.0 )
        return 1.0;
    // assert( 0 < dificultadRelativa < 1 );
    if( dificultadRelativa > 0.5 )
        return -2.666667 * dificultadRelativa*dificultadRelativa + 5.333333 * dificultadRelativa - 1.666667;  // = -8/3*x^2 + 16/3*x - 5/3
    else if( dificultadRelativa > 0.25 )
        return 5.333333 * dificultadRelativa*dificultadRelativa - 2.666667 * dificultadRelativa + 0.3333333;  // = 16/3*x^2 - 8/3*x + 1/3
    else
        return 0.0; // si la dificultadRelativa grupal es nula, no se le da premio a nadie.

}

// Calcula el factor pena severa. Da el factor usado para atenuar los premios cuando la dificultadRelativa es menor a uno.
float SisPremioCombate_factorPenaSevera( float dificultadRelativa );
float SisPremioCombate_factorPenaSevera( float dificultadRelativa ) {
    if( dificultadRelativa >= 1.0  )
        return 1.0;
    // assert( 0 < dificultadRelativa < 1 );
    if( dificultadRelativa > 0.6666666666666 )
        return -4.5 * dificultadRelativa*dificultadRelativa + 9.0 * dificultadRelativa - 3.5;  // = -9/2*x^2 + 9*x - 7/2
    else if( dificultadRelativa > 0.3333333333333 )
        return 4.5 * dificultadRelativa*dificultadRelativa - 3.0 * dificultadRelativa + 0.5;  // = 9/2*x^2 - 3*x + 1/2
    else
        return 0.0; // si la dificutad grupal es nula, no se le da premio a nadie.
}
