/************************* Random *****************************************
Package: Random - include
Autor: Inquisidor
Descripcion: Dado desvalanceado configurable.
******************************************************************************/

const int WeightedSelector_WEIGHT_WIDTH = 3; // el peso debe estar en la cola del elemento (al final)
const int WeightedSelector_WEIGHT_TOP = 1000; // = 10^WeightedSelector_WEIGHT_WIDTH

struct WeightedSelector {
    string array;
    int elementLength;
    int totalWeight;
};


// Construye un WeightedSelector, que es un espacio muestreal donde la probabilidad
// de ocurrencia de un elemento es su peso dividido el peso total (suma de los pesos
// de todos los elementos).
// El espacio muestreal es especificado con los parametros 'array' donde estan
// concatenados los descriptores de los elementos, y 'elementLength' que dice
// cuantos caracteres usa cada descriptor de elemento.
// El peso de cada elemento debe ser indicado en los ultimos WeightedSelector_WEIGHT_WIDTH
// caracteres del elemento.
struct WeightedSelector WeightedSelector_create( string array, int elementLength );
struct WeightedSelector WeightedSelector_create( string array, int elementLength ) {
    struct WeightedSelector this;
    this.array = array;
    this.elementLength = elementLength;
    int weightPos = GetStringLength( array ) - WeightedSelector_WEIGHT_WIDTH;
    while( weightPos >= 0 ) {
        int elementWeight = StringToInt( GetSubString( array, weightPos, WeightedSelector_WEIGHT_WIDTH ) );
        if( elementWeight == 0 )
            WriteTimestampedLogEntry( "WeightedSelector_create: an element with zero weight was found. weightingArray="+array );
        this.totalWeight += elementWeight;
        weightPos -= elementLength;
    }
    if( weightPos + WeightedSelector_WEIGHT_WIDTH != 0 )
        WriteTimestampedLogEntry( "WeightedDie_constructor: Error, the array length must be a multiple of element length" );
    return this;
}

// Elige al azar uno de los elementos del espacio muestreal recibido.
// Da un string con el descriptor del elemento sin el peso (o sea que el largo del
// resultado es 'this.elementLength' menos 'WeightedSelector_WEIGHT_WIDTH' ).
// La chance de un elemento es su peso sobre el peso total.
string WeightedSelector_choose( struct WeightedSelector this );
string WeightedSelector_choose( struct WeightedSelector this ) {
    int weightingSelector = Random( this.totalWeight );
    int weightPos = this.elementLength - WeightedSelector_WEIGHT_WIDTH;
    int weightAcumulator = 0;
    while( TRUE ) {
        weightAcumulator += StringToInt( GetSubString( this.array, weightPos, WeightedSelector_WEIGHT_WIDTH ) );
        if( weightAcumulator > weightingSelector )
            break;
        weightPos += this.elementLength;
    }
    return GetSubString( this.array, weightPos + WeightedSelector_WEIGHT_WIDTH - this.elementLength, this.elementLength - WeightedSelector_WEIGHT_WIDTH );
}

// Removes the first element whose value is 'elementValue'.
// Does nothing if this WeightedSelector has no element whose value equals 'elementValue'.
struct WeightedSelector WeightedSelector_remove( struct WeightedSelector this, string elementValue );
struct WeightedSelector WeightedSelector_remove( struct WeightedSelector this, string elementValue ) {
    int position = FindSubString( this.array, elementValue );
    if( position >= 0 ) {
        this.totalWeight -= StringToInt( GetSubString( this.array, position + this.elementLength - WeightedSelector_WEIGHT_WIDTH, WeightedSelector_WEIGHT_WIDTH ) );
        this.array = GetStringLeft( this.array, position ) + GetStringRight( this.array, GetStringLength(this.array) - position - this.elementLength );
    }
    return this;
}


///////////////////////////////// Weighted Die /////////////////////////////////
// WeightedDie es un generador de numeros enteros al azar con distribucion
// de probabilidad configurable

const string WeightedDie_FACE_HEADER = "|";
const int WeightedDie_FACE_NUMBER_OFFSET = 1;
const int WeightedDie_FACE_NUMBER_WIDTH = 3;
const int WeightedDie_FACE_NUMBER_TOP = 1000; // = 10^WeightedDie_FACE_NUMBER_WIDTH
const int WeightedDie_FACE_TOTAL_WIDTH = 8;


// Construye un WeightedDie donde la cantidad de caras, valor de las caras y
// probabilidad estan determinados por el arreglo 'facesArray'.
// El formato de cada elemento en facesArray es: "|###,###". Donde el primer campo es el
// valor de la cara, y el segundo campo es el peso.
// Los elementos van concatenados sin separacion alguna.
struct WeightedSelector WeightedDie_create( string facesArray );
struct WeightedSelector WeightedDie_create( string facesArray ) {
    return WeightedSelector_create( facesArray, WeightedDie_FACE_TOTAL_WIDTH );
}


// Crea un WeightedDie igual al recibido excepto porque se le agrega una cara.
struct WeightedSelector WeightedDie_addFace( struct WeightedSelector die, int faceNumber, int faceWeight );
struct WeightedSelector WeightedDie_addFace( struct WeightedSelector die, int faceNumber, int faceWeight ) {
    if( faceNumber < 0 || WeightedDie_FACE_NUMBER_TOP <= faceNumber || faceWeight <= 0 )
        WriteTimestampedLogEntry( "WeightedDie_addFace: error, invalid parameters: faceNumber="+IntToString(faceNumber)+", faceWeight="+IntToString(faceWeight) );
    else {
        if( faceWeight >= WeightedSelector_WEIGHT_TOP )
            faceWeight = WeightedSelector_WEIGHT_TOP - 1;

        die.array +=
            WeightedDie_FACE_HEADER
            + GetStringRight( IntToString(WeightedDie_FACE_NUMBER_TOP+faceNumber), WeightedDie_FACE_NUMBER_WIDTH )
            + ","
            + GetStringRight( IntToString(WeightedSelector_WEIGHT_TOP+faceWeight), WeightedSelector_WEIGHT_WIDTH )
        ;
        die.totalWeight += faceWeight;
    }
    return die;
}


// Construye un WeightedDie a partir de otros dos WeightedDie. El dado resultante tendra
// todas las caras de los dados 'dieA' y 'dieB' con el mismo peso que en su origen.
struct WeightedSelector WeightedDie_merge( struct WeightedSelector dieA, struct WeightedSelector dieB );
struct WeightedSelector WeightedDie_merge( struct WeightedSelector dieA, struct WeightedSelector dieB ) {
    dieA.array += dieB.array;
    dieA.totalWeight += dieB.totalWeight;
    return dieA;
}


// Crea un WeightedDie igual al WeightedDie recibido, excepto porque se le quita
// la cara indicada por 'faceNumber'
struct WeightedSelector WeightedDie_removeFace( struct WeightedSelector die, int faceNumber );
struct WeightedSelector WeightedDie_removeFace( struct WeightedSelector die, int faceNumber ) {
    string faceEntry = WeightedDie_FACE_HEADER + GetStringRight( IntToString( faceNumber + WeightedDie_FACE_NUMBER_TOP ), WeightedDie_FACE_NUMBER_WIDTH );
    int position = FindSubString( die.array, faceEntry );
    if( position >= 0 ) {
        int nextFacePosition = position + die.elementLength;
        die.totalWeight -= StringToInt( GetSubString( die.array, nextFacePosition - WeightedSelector_WEIGHT_WIDTH, WeightedSelector_WEIGHT_WIDTH ) );
        die.array = GetStringLeft( die.array, position ) + GetSubString( die.array, nextFacePosition, GetStringLength( die.array ) - nextFacePosition );
    }
    return die;
}


// Lanza el WeightedDie, y da el numero de la cara que salio sorteada.
int WeightedDie_throw( struct WeightedSelector die );
int WeightedDie_throw( struct WeightedSelector die ) {
    string face = WeightedSelector_choose( die );
    return StringToInt( GetSubString( face, WeightedDie_FACE_NUMBER_OFFSET, WeightedDie_FACE_NUMBER_WIDTH ) );
}



//////////////////////// Probabilistic Distributions ///////////////////////////

// returns a random number in the range [0,maxValue) where the expectance is 1/(2*weigth)
float Random_weightedDistribution( float maxValue, float weight );
float Random_weightedDistribution( float maxValue, float weight ) {
    float r = IntToFloat(Random(10000))/10000.0;
    return maxValue * pow( r, weight );
}

// returns a random number in the range [0,maxValue), where the expectance is maxValue/4
int Random_challengeDistribution( int maxValue );
int Random_challengeDistribution( int maxValue ) {
    float r = IntToFloat(Random(10000))/10000.0;
    return FloatToInt( IntToFloat(maxValue) * r * r  );
}



// Genera un numero al azar entre 'minValue' e infinito, con esperansa igual a 'expectance'.
// Se asume que 'expectance' > 'minValue'
float Random_exponentialDistribution( float minValue, float expectance );
float Random_exponentialDistribution( float minValue, float expectance ) {
    float r = IntToFloat(1+Random(10000))/10000.0;
    return minValue - (expectance-minValue)* log(r);
}




////////////////////////////////////////////////////////////////////////////////
//////////////////// Generador de un nivel al azar basado en CR //////////////////
////////////////////////////////////////////////////////////////////////////////

// Genera un valor al azar 'V' (seria una variable aleatoria) segun la distribucion de probabilidad p(cr,v).
// El parametro 'cr' indica el nivel de dificultad que se tuvo que superar para conseguir
// el item cuyo nivel sera la dado por esta funcion.
// La distribucion de probabilidad p(cr,q) es:
//      q / cr  para q <= cr
//      Exp[2*(-q + cr)/cr]  para  q > cr
float Random_generateLevel( int cr );
float Random_generateLevel( int cr ) {
    // Nota: para generar un numero aleatorio 'v' cuya distribucion de probabilidad es dp(v), a partir de una distribucion constante como la que da la funcion Random(..), hay que hacer una transformacion que requiere integrar ( A = DP(v) = Integral( dp(x), x, 0, v ) y luego obtener la funcion inversa ( v = InvDP( A ) ). Entonces se puede generar un v haciendo v = InvDP( Random( Limite( DP(v), v->infinito ) ) )
    // toda esta trasformacion se hizo usando el Matematica y esta en el archivo "calidad del item en funcion del CR.nb".
    int rPor10000 = Random(20000);
    float r = IntToFloat( rPor10000 ) / 10000.0; // r es aleatoria con distribucion continua en el intervalo [0,2)
    float crK = IntToFloat( cr );
    if( rPor10000 <= 10000 )
        return crK*pow( r, 0.5 );
    else
        return crK - crK*log( 2.0 - r )/2.0;
}


