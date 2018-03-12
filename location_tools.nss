/************************** class Location *******************************
package: class Location - tools
Autor: Inquisidor
Version: 0.1
Descripcion: funciones utiles para generar locaciones.
*******************************************************************************/
#include "Area_generic"


// Crea una locacion dadas las cordenadas relativas a la locacion de referencia.
// 'longitudinalDistance' es la distancia hacia delante (o atras si es negativo) de 'reference'.
// 'transversalDistance' es la distancia hacia la izquierda (o derecha si es negativo) de 'reference'.
location Location_createRelative( location reference, float longitudinalDistance, float transversalDistance, float facing );
location Location_createRelative( location reference, float longitudinalDistance, float transversalDistance, float facing ) {
    float longitudinalDirection = GetFacingFromLocation( reference );
    vector longitudinalAxis = AngleToVector( longitudinalDirection );
    vector transversalAxis = AngleToVector( longitudinalDirection + 90.0 );
    return Location(
        GetAreaFromLocation(reference),
        GetPositionFromLocation(reference) + longitudinalDistance * longitudinalAxis + transversalDistance * transversalAxis,
        longitudinalDirection + facing
    );
}



// Genera una locacion al azar dentro del area dada. La facing es tambien al azar.
// Nota: solo se checkea que la locacion este dentro de los limites del area. No se
// verifica que la posicion sea valida. Por ende, solo es seguro usar para ubicar
// criaturas, ya que es el unico tipo de objeto que el motor corre a una posicion
// valida si la posicion generada no lo es.
// El parametro 'barringFrame' achica el rango del area, evitando que se generen locaciones
// que caigan a una distancia menor al 'barringFrame' desde un borde del area.
location Location_createRandomAllArea( object area, float barringFrame=0.0 );
location Location_createRandomAllArea( object area, float barringFrame=0.0 ) {

    // calcular los limites
    float barringFramePorDos = 2.0*barringFrame;
    float areaWidth = 10.0f * IntToFloat( GetAreaSize( AREA_WIDTH, area ) ) - barringFramePorDos;
    float areaHight = 10.0f * IntToFloat( GetAreaSize( AREA_HEIGHT, area ) ) - barringFramePorDos;
    if( areaWidth <= 0.0 || areaHight <= 0.0 ) {
//        SendMessageToPC( GetFirstPC(), "CreateRandomInArea: areaWidth="+FloatToString(areaWidth)+", areaHight="+FloatToString(areaHight)+", barringFramePorDos="+FloatToString(barringFramePorDos) );
        location invalidLocation;
        return invalidLocation;
    }

    vector randomVector;
    randomVector.x = barringFrame + areaWidth * IntToFloat( Random( 1001 ) )/1000.0f;
    randomVector.y = barringFrame + areaHight * IntToFloat( Random( 1001 ) )/1000.0f;
    randomVector.z = 0.0;

    // Resolver direccion del facing de la location generada.
    float randomFacing = IntToFloat( Random( 360 ) ); // mirando a cualquier lado

    // Crear la locacion.
    return Location (
        area,
        randomVector,
        randomFacing
    );
}




// Genera una locacion al azar dentro del area excluyendo el circulo centrado en 'exclusionCenter' y de radio 'exclusionRadius' metros.
// Si randomFacing es TRUE, el facing de la locacion generada es al azar. Si es FALSE, el facing es hacia 'centerLoc'.
// Nota: solo se checkea que la locacion este dentro de los limites del area. No se
// verifica que la posicion sea valida. Por ende, solo es seguro usar para ubicar
// criaturas, ya que es el unico tipo de objeto que el motor corre a una posicion
// valida si la posicion generada no lo es.
// El parametro 'barringFrameFraction' achica el rango del area, evitando que se generen locaciones
// que caigan a una distancia menor al 'barringFrameFraction*longitudArea' desde un borde del area.
location Location_createRandomAllAreaExcludingCircle( location exclusionCenter, float exclusionRadius, float barringFrameFraction=0.0 );
location Location_createRandomAllAreaExcludingCircle( location exclusionCenter, float exclusionRadius, float barringFrameFraction=0.0 ) {

    // calcluar los limites
    object area = GetAreaFromLocation( exclusionCenter );
    float areaWidth  = 10.0f * IntToFloat( GetAreaSize( AREA_WIDTH,  area ) );
    float areaHeight = 10.0f * IntToFloat( GetAreaSize( AREA_HEIGHT, area ) );
    float barringFrameX = areaWidth  * barringFrameFraction;
    float barringFrameY = areaHeight * barringFrameFraction;
    float validRangeX = areaWidth  - 2.0 * barringFrameX;
    float validRangeY = areaHeight - 2.0 * barringFrameY;

    // generar una posicion al azar que no caiga en el marco ni en el circulo de exclusion
    vector randomVector;
    vector center = GetPositionFromLocation( exclusionCenter );
    randomVector.z = center.z;
    int watchdog = 10;
    do {
        if( --watchdog == 0 ) {
            location invalidLocation;
            return invalidLocation;
        }
        randomVector.x = barringFrameX + validRangeX * IntToFloat( Random( 1001 ) )/1000.0f;
        randomVector.y = barringFrameY + validRangeY * IntToFloat( Random( 1001 ) )/1000.0f;
    } while( VectorMagnitude( randomVector - center ) < exclusionRadius );

    // Resolver direccion del facing de la location generada.
    float randomFacing = IntToFloat( Random( 360 ) ); // mirando a cualquier lado

    // Crear la locacion.
    return Location (
        area,
        randomVector,
        randomFacing
    );
}



// Genera una locacion a una distancia de 'centerLoc' al azar entre minRadius y maxRadios. La direccion es tambien al azar.
// Si randomFacing es TRUE, el facing de la locacion generada es al azar. Si es FALSE, el facin es hacia 'centerLoc'.
// Nota: solo se checkea que la locacion este dentro de los limites del area. No se
// verifica que la posicion sea valida. Por ende, solo es seguro usar para ubicar
// criaturas, ya que es el unico tipo de objeto que el motor corre a una posicion
// valida si la posicion generada no lo es.
location Location_createRandom( location centerLoc, float minRadius, float maxRadius, int randomFacing=FALSE );
location Location_createRandom( location centerLoc, float minRadius, float maxRadius, int randomFacing=FALSE ) {
    vector centerPos = GetPositionFromLocation( centerLoc );
    float areaWidth = 10.0f * IntToFloat( GetAreaSize( AREA_WIDTH, GetAreaFromLocation( centerLoc ) ) );
    float areaHight = 10.0f * IntToFloat( GetAreaSize( AREA_HEIGHT, GetAreaFromLocation( centerLoc ) ) );

    location tryLoc;

    // Generar un vector al azar de modulo acotado por minRadius, maxRadius, y los bordes del area. La restriccion con los bordes del area no es necesaria, pero es mas eficiente detectarla comparando aqui, ya que se ahorra la creacion y destruccion de criaturas.
    vector randomVector; // notar que la componente vertical 'z' de este vector es siempre nula.
    float randomAngle;
    int innerWatchdog = 15;
    do {
        if( --innerWatchdog == 0 ) {
//                SendMessageToPC( GetFirstPC(), "watchdog 1 reached" );
            location invalidLocation;
            return invalidLocation;
        }

        float randomRadius = minRadius + IntToFloat( Random( 1001 ) )/1000.0f * ( maxRadius - minRadius );
        randomAngle = IntToFloat( Random( 360 ) );
        randomVector.x = centerPos.x + randomRadius * cos( randomAngle );
        randomVector.y = centerPos.y + randomRadius * sin( randomAngle );
        randomVector.z = centerPos.z;

    } while( randomVector.x <= 0.0 || areaWidth <= randomVector.x || randomVector.y <= 0.0 || areaHight <= randomVector.y );
//        PrintString( "innerWatchdog="+IntToString( innerWatchdog ) );

    // Resolver direccion del facing de la location generada.
    float facing;
    if( randomFacing )
        facing = IntToFloat( Random( 360 ) ); // mirando a cualquier lado
    else
        facing = randomAngle + 180.0f; // mirando al centro del circulo

    // Crear la locacion.
    return Location (
        GetAreaFromLocation( centerLoc ),
        randomVector,
        facing
    );
}


// Crea una criatura usando 'creatureResRef' en una locacion valida generada al azar.
// La locacion generada distara entre 'minRadius' y 'maxRadius' de la locacion dada
// por 'centerRadius', a cualquier angulo.
// La criatura quedara mirando hacia 'centerLoc'.
// El parametro 'correctionTolerance' se usa cuando el motor ubica a la criatura
// en una posicion distinta a la indicada por la posicion generada al azar.
// Si la distancia horizontal entre las dos posiciones difiera mas de este
// parametro, se reintenta generando otra posicion al azar. Esto se repite tres
// veces. Si las tras fallan, la funcion devuelve OBJECT_INVALID.
object Location_randomSpawn( location centerLoc, float minRadius, float maxRadius, string creatureResRef, float correctionTolerance=5.0, int verticalTolerance = 5 );
object Location_randomSpawn( location centerLoc, float minRadius, float maxRadius, string creatureResRef, float correctionTolerance=5.0, int verticalTolerance = 5 ) {
//    PrintString( "Area="+GetName( GetAreaFromLocation( centerLoc ) ) );

    vector centerPos = GetPositionFromLocation( centerLoc );
    float areaWidth = 10.0f * IntToFloat( GetAreaSize( AREA_WIDTH, GetAreaFromLocation( centerLoc ) ) );
    float areaHight = 10.0f * IntToFloat( GetAreaSize( AREA_HEIGHT, GetAreaFromLocation( centerLoc ) ) );

    location tryLoc;
    object creature;
    int outerWatchdog = 3; // tres intentos antes de devolver OBJECT_INVALID
    while( --outerWatchdog >= 0 ) {

        // Generar un vector al azar de modulo acotado por minRadius, maxRadius, y los bordes del area. La restriccion con los bordes del area no es necesaria, pero es mas eficiente detectarla comparando aqui, ya que se ahorra la creacion y destruccion de criaturas.
        vector randomVector; // notar que la componente vertical 'z' de este vector es siempre nula.
        float randomAngle;
        int innerWatchdog = 15;
        do {
            if( --innerWatchdog == 0 ) {
//                SendMessageToPC( GetFirstPC(), "watchdog 1 reached" );
                return OBJECT_INVALID;
            }

            float randomRadius = minRadius + IntToFloat( Random( 1001 ) )/1000.0f * ( maxRadius - minRadius );
            randomAngle = IntToFloat( Random( 360 ) );
            randomVector.x = centerPos.x + randomRadius * cos( randomAngle );
            randomVector.y = centerPos.y + randomRadius * sin( randomAngle );

        } while( randomVector.x <= 0.0 || areaWidth <= randomVector.x || randomVector.y <= 0.0 || areaHight <= randomVector.y );
//        PrintString( "innerWatchdog="+IntToString( innerWatchdog ) );

        // Crear la locacion donde aparecera la criatura. La criatura quedara mirando a centerLoc.
        tryLoc = Location (
            GetAreaFromLocation( centerLoc ),
            randomVector,
            randomAngle + 180.0f   // mirando al centro del circulo
        );

        // Crear criatura
        object creature = CreateObject( OBJECT_TYPE_CREATURE, creatureResRef, tryLoc, TRUE );

        // Verificar que sea valida
        if( !GetIsObjectValid( creature ) ) {
//            SendMessageToPC( GetFirstPC(), "invalid creature" );
            continue;
        }

//        PrintString( "tryPos=" );
//        PrintVector( GetPositionFromLocation( tryLoc ), FALSE );
//        PrintString( "creaturePos=" );
//        PrintVector( GetPosition( creature ), FALSE );

        // Verificar que la posicion de la criatura no difiera mas de lo tolerado de la posicion generada al azar (randomVector).
        vector creaturePos = GetPosition(creature);
        int verticalDif = FloatToInt( creaturePos.z - centerPos.z );
        if( -verticalTolerance < verticalDif && verticalDif < verticalTolerance ) { // se tolera una diferencia vertical de cinco metros
            creaturePos.z = 0.0;
            if( VectorMagnitude( creaturePos - randomVector ) < correctionTolerance ) // se tolera una diferencia horizontal de 'correctionTolerance' metros
                return creature;
        }
        DestroyObject( creature, 0.0 );
    };

//    SendMessageToPC( GetFirstPC(), "watchdog 2 reached" );

    return OBJECT_INVALID;
}


const string Location_PJ_punteroUbicacionForzada_VN = "LocPuf"; // Todo PJ que tenga esa variable definida, forzará a que el resultado de la funcion 'Location_createRandomAwayFromPjs(..)' de una 'ubicacionGenerada' igual a la ubicación del objeto señalado por esta variable. Si el objeto señalado por esta variable es una puerta, ella es abierta forzosamente.

struct Location_CreateRandomAwayFromPjsResult {
    location ubicacionGenerada;
    object pjSorteado;
};

// Elige un personaje al azar dentro del 'area' y genera una locacion al azar entre dos circulos con radios 'distanciaMinima' y 'distanciaMaxima' y centro en el personaje elegido.
// Si la locacion obtenida cae a menos de 'distanciaMinima' de algun otro personaje del area, se repite el proceso hasta que esto ultimo no suceda.
// Para disminuir la probabilidad de que el proceso se repita, la ditancia maxima debe ser mas de 10 metros mayor a la distancia minima.
struct Location_CreateRandomAwayFromPjsResult Location_createRandomAwayFromPjs( object area, float distanciaMinima, float distanciaMaxima );
struct Location_CreateRandomAwayFromPjsResult Location_createRandomAwayFromPjs( object area, float distanciaMinima, float distanciaMaxima ) {
    struct Location_CreateRandomAwayFromPjsResult resultado;
    int watchdog = 10;
    int ubicacionDesaprobada;
    do {
        if( --watchdog == 0 ) {
            struct Location_CreateRandomAwayFromPjsResult invalidLocation;
            return invalidLocation;
        }
        // sortear cual de los PJs en el arrea será tomado como centro para generar la posicion al azar
        resultado.pjSorteado = Area_sortearPj( area );
        // fijarse si el 'pjSorteado' tiene asociado una ubicación forzada
        object punteroUbicacionForzada = GetLocalObject( resultado.pjSorteado, Location_PJ_punteroUbicacionForzada_VN );
        // si el 'pjSorteado' tiene una ubicacion forzada que yace en el mismo área donde yace el 'pjSorteado',
        if( GetArea( punteroUbicacionForzada ) == GetArea(resultado.pjSorteado ) ) {
            resultado.ubicacionGenerada = GetLocation( punteroUbicacionForzada );
            ubicacionDesaprobada = FALSE;
            if( GetObjectType(punteroUbicacionForzada) == OBJECT_TYPE_DOOR && !GetIsOpen(punteroUbicacionForzada) )
                AssignCommand( punteroUbicacionForzada, ActionOpenDoor(punteroUbicacionForzada) );
        }
        // sino generar una ubicacion al azar entre los dos circulos concentricos
        else {
            // generacion de la posicion al azar
            resultado.ubicacionGenerada = Location_createRandom( GetLocation( resultado.pjSorteado ), distanciaMinima, distanciaMaxima );
            //verificacion de que la posicion generada no este cera de otro Pj
            ubicacionDesaprobada = FALSE;
            object pjIterator = GetFirstPC();
            while( pjIterator != OBJECT_INVALID ) {
                if( GetArea( pjIterator ) == area && GetDistanceBetweenLocations( GetLocation( pjIterator ), resultado.ubicacionGenerada ) < distanciaMinima ) {
                    ubicacionDesaprobada = TRUE;
                    break;
                }
                pjIterator = GetNextPC();
            }
        }
    }while( ubicacionDesaprobada );
    return resultado;
}



const int Location_SECCION_ES_NORTE_BIT = 2; // norte = 1, sur = 0
const int Location_SECCION_ES_ESTE_BIT = 1; // este = 1, oeste = 0
const int Location_SECCION_SUR_OESTE = 0;
const int Location_SECCION_SUR_ESTE = 1;
const int Location_SECCION_NOR_OESTE = 2;
const int Location_SECCION_NOR_ESTE = 3;
// Distingue en cual de las cuatro secciones resultantes de dividir el area por
// las fronteras vertical y horizontal cae la 'ubicacion' dada.
// 'fronteraHorizonal' es la cantidad de fracciones de 10 de la distancia de este a oeste del area. Debe valer entre 1 y 9. Si vale 5 la frontera divide al area en dos partes iguales.
// 'fronteraVertical' es la cantidad de fracciones de 10 de la distancia de sur a norte del area. Debe valer entre 1 y 9. Si vale 5 la frontera divide al area en dos partes iguales.
// Devuelve un entero que indica en cual de las cuatro secciones cae 'ubicacion'.
int Location_dicernirSeccion( vector ubicacion, int fronteraHorizontal=5, int fronteraVertical=5 );
int Location_dicernirSeccion( vector ubicacion, int fronteraHorizontal=5, int fronteraVertical=5 ) {
    int seccion;
    float fronteraV = IntToFloat( fronteraVertical * GetAreaSize( AREA_WIDTH, OBJECT_SELF ) );
    float fronteraH = IntToFloat( fronteraHorizontal * GetAreaSize( AREA_HEIGHT, OBJECT_SELF ) );
    if( ubicacion.x > fronteraV )
        seccion = Location_SECCION_ES_ESTE_BIT;
    if( ubicacion.y > fronteraH )
        seccion |= Location_SECCION_ES_NORTE_BIT;
    return seccion;
}


// Fuerza el salto de OBJECT_SELF a un location. Solo es útil con PJs.
// Solo funciona para saltar entre areas distintas
void Location_forcedJump( location destination );
void Location_forcedJump( location destination ) {
    if(
        GetIsObjectValid( GetAreaFromLocation( destination ) )
        && GetIsObjectValid( OBJECT_SELF )
        && GetArea( OBJECT_SELF ) != GetAreaFromLocation( destination )
    ) {
        JumpToLocation( destination );
        DelayCommand( 1.0, Location_forcedJump( destination ) );
    }
}


//Chequea si una criatura esta en el angulo de vision de otra
//El angulo de vision comprende un angulo de 45 grados con su bisectriz en linea recta delante de la criatura que mira
//Esta funcion no chequea si el que mira puede efectivamente ver al objetivo, unicamente si este se encuentra en su angulo de vision
int Location_EstaEnAnguloDeVision ( object oObservador, object oObservado );
int Location_EstaEnAnguloDeVision ( object oObservador, object oObservado )
{   // por Dragoncin
    float fDireccionMirandoObservador = GetFacing(oObservador);
    float fAnguloAComparar = VectorToAngle(GetPosition(oObservado) - GetPosition(oObservador));

    float fResultado = fDireccionMirandoObservador - fAnguloAComparar;
    if (fResultado < 0.0) fResultado = -fResultado;
    if (fResultado > 360.0) fResultado -= 360.0;
    else if (fResultado < -360.0) fResultado += 360.0;

    if ( (fResultado < 45.0) || (fResultado > 315.0) )
        return TRUE;

    return FALSE;
}



const int POSICION_ADELANTE = 1;
const int POSICION_IZQUIERDA = 2;
const int POSICION_DERECHA = 3;
const int POSICION_ATRAS = 4;

//HAce lo mismo que la anterior, pero devuelve el cuadrante relativo
int Location_CuadrantePosicionRelativa ( object oObservador, object oObservado );
int Location_CuadrantePosicionRelativa ( object oObservador, object oObservado )
{   // por Dragoncin
    float fDireccionMirandoObservador = GetFacing(oObservador);
    float fAnguloAComparar = VectorToAngle(GetPosition(oObservado) - GetPosition(oObservador));

    float fResultado = fDireccionMirandoObservador - fAnguloAComparar;
    if (fResultado < 0.0) fResultado = -fResultado;
    if (fResultado > 360.0) fResultado -= 360.0;
    else if (fResultado < -360.0) fResultado += 360.0;

    if ( (fResultado < 45.0) || (fResultado >= 315.0) )
        return POSICION_ADELANTE;
    else if ( (fResultado >= 45.0) && (fResultado < 135.0) )
        return POSICION_DERECHA;
    else if ( (fResultado >= 135.0) && (fResultado < 225.0) )
        return POSICION_ATRAS;
    else
        return POSICION_IZQUIERDA;
}

location Location_GetLocationAboveAndInFrontOf(object itemActivator, float fDist, float fHeight);
location Location_GetLocationAboveAndInFrontOf(object itemActivator, float fDist, float fHeight)
{   // por Dragoncin
    float fDistance = -fDist;
    object oTarget = (itemActivator);
    object oArea = GetArea(oTarget);
    vector vPosition = GetPosition(oTarget);
    vPosition.z += fHeight;
    float fOrientation = GetFacing(oTarget);
    vector vNewPos = AngleToVector(fOrientation);
    float vZ = vPosition.z;
    float vX = vPosition.x - fDistance * vNewPos.x;
    float vY = vPosition.y - fDistance * vNewPos.y;
    fOrientation = GetFacing(oTarget);
    vX = vPosition.x - fDistance * vNewPos.x;
    vY = vPosition.y - fDistance * vNewPos.y;
    vNewPos = AngleToVector(fOrientation);
    vZ = vPosition.z;
    vNewPos = Vector(vX, vY, vZ);
    return Location(oArea, vNewPos, fOrientation);
}

