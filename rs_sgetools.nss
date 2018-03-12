/******************************************************************************
Package: RandomSpawn - SGE tools
Author: Inquisidor
Descripcon: Toda area que pretenda generar RandomSpawn tiene un scrip asociado que
se encarga de generar encuentros con criaturas correspondientes al area. Este script,
que llamaremos SGE (Script Generador de Encuentros), es llamado por el RandomSpawn
system cada vez que se genera un encuentro en el area.
Las funciones definidas aqui ayudan a generar grupos de criaturas.
IMPORTATE: todas las funciones aqui definidas deben ser llamadas con OBJECT_SELF == area del encuentro
*******************************************************************************/
#include "RS_SGEInterface"
#include "SPC_poderRel_inc"


const float RS_PODER_RELATIVO_ENCUENTRO_DEFECTO = 2.0
/* Notas sobre el grado de desafio de las criaturas y el parametro 'poderRelativoEncuentro'.
El parametro 'poderRelativoEncuentro' depende de como este definido el CR de las criaturas, de cuantos
encuentros se busca pueda superar entre descansos un party de una cantidad determinada de
sujetos, y de la sinergia por agrupacion de criaturas.
Asumiendo que la sinergía es nula, y que se busque que parties de cinco sujetos logren superar
a cinco encuentros entre descansos, el valor de 'poderRelativoEncuentro' debe ser:
1) Si CR esta definido tal que una criatura CR X empata contra un personaje nivel X: entonces si 'poderRelativoEncuentro' vale N, el encuentro generado sera equivalente a un grupo de N personajes nivel X. Por ende, estimo que 'poderRelativoEncuentro' debe valer entre 1.8 y 2.2 para que el party tolere cinco encuentros sucesivos.
2) Si CR esta definido tal que una criaturas CR X empata contra un party de cinco personajes nivel X consumido por haber vencido a otras cuatro criaturas CR X por separado: entonces 'poderRelativoEncuentro' debe valer 1.

Importante: En el CR de una criatura NO debe estar contemplada la sinergia, a no ser que
siempre se la agrupe con las mismas criaturas (cosa que limita las variantes). La sinergia
debe ser contemplada UNICAMENTE en el script que arma los grupos.
Por ejemplo, si el grupo generado esta compuesto por criaturas de la misma clase, lo mas
probable es que la sinergia sea nula. Entonces el parametro 'poderRelativoEncuentro' debe valer como
dice en (1) o (2) segun sea el caso.
En cambio, si el grupo generado esta compuesto por criaturas de clases que se complementan, lo
mas probable es que la sinergia sea conciderable. Entonces el parametro 'poderRelativoEncuentro' debe ser
disminuido en una proporcion igual a la proporcion de aumtento del poder gracias a la
singergia. O sea que si la sinergia aumenta el poder del encuentro en un 10%, el parametro
'poderRelativoEncuentro' debe ser un 10% menor a lo que se indica en (1) y (2).
*/
;


// Genera una intancia de la plantilla de criatura dada y la registra al sistema de spawn ( 'RS_marcarCriatura()' ).
// Devuelve la FAE (fraccion de aporte al encuentro) de la criatura generada.
float RS_generarCriatura( struct RS_DatosSGE datosSGE, int crCriatura, string nombrePlantilla );
float RS_generarCriatura( struct RS_DatosSGE datosSGE, int crCriatura, string nombrePlantilla ) {
    float poderRelativo = SisPremioCombate_poderRelativoSujeto( crCriatura, datosSGE.dificultadEncuentro );
    float fae = poderRelativo / datosSGE.poderRelativoEncuentro;

    object criatura = RS_crearCriatura( nombrePlantilla, datosSGE.ubicacionEncuentro );
    if( GetIsObjectValid( criatura ) ) {
        RS_marcarCriatura( datosSGE, criatura, fae );
//        if( FloatToInt( GetChallengeRating( criatura ) ) != crCriatura )
//            WriteTimestampedLogEntry( "RS_generarCriatura: Warning: el CR especificado no concuerda con el de la plantilla. plantilla=["+nombrePlantilla+"]" );
    }
    else
        WriteTimestampedLogEntry( "RS_generarCriatura: Error: plantilla de criatura invalida en area=["+nombrePlantilla+"]" );

    return fae;
}


float absFloat( float v ) {
    return v < 0.0 ? -v : v;
}

// Genera una o mas instancias de la plantilla de criatura dada y las registra al sistema de spawn ('RS_marcarCriatura()').
// La cantidad de criaturas generada es tal que la suma de sus FAE sea lo mas cercana posible a 'faeGrupoBuscado'.
// La toleracia 'toleranciaFaeGrupoBuscado' determina por cuanto se puede exceder la FAE generada por arriba de la FAE buscada.
// Devuelve la suma de las FAE (fraccion de aporte al encuentro) de las criaturas generadas.
// El valor devuelto será siempre mayor o igual a cero y menor a 'faeGrupoBuscado + toleranciaFaeGrupoBuscado'.
float RS_generarGrupoHomogeneo( struct RS_DatosSGE datosSGE, int crInstancia, string plantilla, float faeGrupoBuscado=1.0, float toleranciaFaeGrupoBuscado=0.17 );
float RS_generarGrupoHomogeneo( struct RS_DatosSGE datosSGE, int crInstancia, string plantilla, float faeGrupoBuscado=1.0, float toleranciaFaeGrupoBuscado=0.17 ) {
    if( !GetIsObjectValid( GetAreaFromLocation( datosSGE.ubicacionEncuentro ) ) )
        return 0.0;

    float faeGrupoMax = faeGrupoBuscado + toleranciaFaeGrupoBuscado;
    float faeInstancia = SisPremioCombate_poderRelativoSujeto( crInstancia, datosSGE.dificultadEncuentro ) / datosSGE.poderRelativoEncuentro ;

    float faeGrupoGenerado = 0.0; // aqui se van acumulando las FAE de las criaturas generadas hasta el momento
    float faeGrupoPrueba = faeInstancia;

    // en cada ciclo de el siguiente bucle e genera una intancia de la plantilla de criatura
    while( absFloat(faeGrupoPrueba - faeGrupoBuscado) < absFloat( faeGrupoGenerado - faeGrupoBuscado )  &&  faeGrupoGenerado <= faeGrupoMax ) {

        object criatura = RS_crearCriatura( plantilla, datosSGE.ubicacionEncuentro );
        if( GetIsObjectValid( criatura ) ) {
            faeGrupoGenerado += faeInstancia;
            faeGrupoPrueba = faeGrupoGenerado + faeInstancia;
            RS_marcarCriatura( datosSGE, criatura, faeInstancia );
//            if( FloatToInt( GetChallengeRating( criatura ) ) != crDmd )
//                WriteTimestampedLogEntry( "RS_generarGrupo: Warning: el CR especificado en el DMD no concuerda con el de la plantilla. plantilla=["+nombrePlantilla+"]" );
        }
        else {
            WriteTimestampedLogEntry( "RS_generarGrupoHomogeneo: Error: plantilla de criatura invalida en area=["+GetTag(OBJECT_SELF)+"]. plantilla=["+plantilla+"]" );
            break;
        }
//        SendMessageToPC( GetFirstPC(), "cotaInfDmdsEligibles="+IntToString(cotaInfDmdsEligibles) +", cotaSupDmdsEligibles="+IntToString(cotaSupDmdsEligibles) +", faeGrupoGenerado="+FloatToString( faeGrupoGenerado ) );
    };
    return faeGrupoGenerado;
}




const int RS_DMD_CR_OFFSET = 0;
const int RS_DMD_CR_SIZE = 3;
const int RS_DMD_TYPE_OFFSET = 4;
const int RS_DMD_TYPE_SIZE = 1;
const int RS_DMD_DATA_OFFSET = 6;
const int RS_DMD_DATA_SIZE = 16;
const int RS_DMD_TEMPLATE_OFFSET = 23;
const int RS_DMD_TEMPLATE_SIZE = 16;
const int RS_DMD_TOTAL_SIZE = 40;


// funcion privada usada exclusivamente por 'RS_generarGrupo(..)'
void RS_generarGrupo_instanciarDMD( struct RS_DatosSGE datosSGE, string arregloDMDs, int dcdSorteadoIndex, float faeDmd ) {
    string nombrePlantilla = GetSubString( arregloDMDs, dcdSorteadoIndex*RS_DMD_TOTAL_SIZE + RS_DMD_TEMPLATE_OFFSET, RS_DMD_TEMPLATE_SIZE + 1 );
    nombrePlantilla = GetStringLeft( nombrePlantilla, FindSubString( nombrePlantilla, " " ) );

    string dcdTypeStr = GetSubString( arregloDMDs, dcdSorteadoIndex*RS_DMD_TOTAL_SIZE + RS_DMD_TYPE_OFFSET, RS_DMD_TYPE_SIZE );
    int dcdTypeInt = FindSubString( "MALS", dcdTypeStr );
    if( dcdTypeInt >= 0 ) {
        object criatura = RS_crearCriatura( nombrePlantilla, datosSGE.ubicacionEncuentro );
        if( GetIsObjectValid( criatura ) ) {
            RS_marcarCriatura( datosSGE, criatura, faeDmd );
//            if( FloatToInt( GetChallengeRating( criatura ) ) != crDmd )
//                WriteTimestampedLogEntry( "RS_generarGrupo: Warning: el CR especificado en el DMD no concuerda con el de la plantilla. plantilla=["+nombrePlantilla+"]" );
        }
        else
            WriteTimestampedLogEntry( "RS_generarGrupo: Error: plantilla de criatura invalida en area=["+GetTag(OBJECT_SELF)+"]. plantilla=["+nombrePlantilla+"]" );

        //if( dcdTypeInt == 3 )
        //    WriteTimestampedLogEntry( "RS_generarGrupo: Error: tipo de DMD incorrecto en area=["+GetTag(OBJECT_SELF)+"]" );

    } else {
        WriteTimestampedLogEntry( "RS_generarGrupo: Error: tipo de DMD invalido en area=["+GetTag(OBJECT_SELF)+"]" );
    }
}


const float float_MAX = 999999.0;
const float float_MIN = -999999.0;

struct RS_CotasDmdMasCercano {
    int indiceCotaInferior;
    float faeCotaInferior;
    int crCotaInferior;
    int indiceCotaSuperior;
    float faeCotaSuperior;
    int crCotaSuperior;
};
// Acota el DMD cuyo FAE se acerque mas a 'faeDmdBuscado'.
// Solo busca entre los DMDs cuyo indice (base cero) es menor a 'indiceCotaSuperiorInicial'. Por ende, para que bussque en todo el arreglo, 'indiceCotaSuperiorInicial' debe ser igual a la cantiad de DMDs en el arreglo.
struct RS_CotasDmdMasCercano RS_acotarDmdMasCercano( int dificultadEncuentro, string arregloDMDs, float faeDmdBuscado, int indiceCotaSuperiorInicial, float poderRelativoEncuentro );
struct RS_CotasDmdMasCercano RS_acotarDmdMasCercano( int dificultadEncuentro, string arregloDMDs, float faeDmdBuscado, int indiceCotaSuperiorInicial, float poderRelativoEncuentro ) {
    struct RS_CotasDmdMasCercano cotasDmdMasCercano;
    cotasDmdMasCercano.indiceCotaInferior = -1;
    cotasDmdMasCercano.faeCotaInferior = float_MIN;
    cotasDmdMasCercano.indiceCotaSuperior = indiceCotaSuperiorInicial;
    cotasDmdMasCercano.faeCotaSuperior = float_MAX;
    cotasDmdMasCercano.crCotaInferior = 0; // deberia ser el CR del primer DMD menos uno (al CR).
    cotasDmdMasCercano.crCotaSuperior = 32767; // debera ser el CR del ultimo DMD eligible mas uno (al CR)
    while( cotasDmdMasCercano.indiceCotaSuperior - cotasDmdMasCercano.indiceCotaInferior > 1 && cotasDmdMasCercano.crCotaSuperior - cotasDmdMasCercano.crCotaInferior > 1 ) {
        int indiceMedio = ( cotasDmdMasCercano.indiceCotaSuperior + cotasDmdMasCercano.indiceCotaInferior )/2;
        int crMedio = StringToInt( GetSubString( arregloDMDs, indiceMedio*RS_DMD_TOTAL_SIZE + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) );
        float poderRelativoDmd = SisPremioCombate_poderRelativoSujeto( crMedio, dificultadEncuentro );
        float faeDmd = poderRelativoDmd / poderRelativoEncuentro;
        if( faeDmd > faeDmdBuscado ) {
            cotasDmdMasCercano.indiceCotaSuperior = indiceMedio;
            cotasDmdMasCercano.faeCotaSuperior = faeDmd;
            cotasDmdMasCercano.crCotaSuperior = crMedio;
        } else {
            cotasDmdMasCercano.indiceCotaInferior = indiceMedio;
            cotasDmdMasCercano.faeCotaInferior = faeDmd;
            cotasDmdMasCercano.crCotaInferior = crMedio;
        }
//        SendMessageToPC( GetFirstPC(), "indiceCotaInferior="+IntToString(cotasDmdMasCercano.indiceCotaInferior) +", indiceCotaSuperior="+IntToString(cotasDmdMasCercano.indiceCotaSuperior) );
    }
    return cotasDmdMasCercano;
}

// Genera un grupo de criaturas tal que la suma de sus poderes relativos al nivel de dificultad del encuentro, sea cercano a 'faeGrupoBuscado * poderRelativoEncuentro'.
// 'datosSGE': debe ser el obtenido llamando a 'RS_getDatosSEG()'
// 'arregloDMDs': es el arreglo de Datos de Miembros Designados (para abreviar DMD). El arreglo esta serializado a texto, donde cada elemento (un DMD) tiene una cantidad fija de caracteres (=RS_DMD_TOTAL_SIZE).
//      Cada DMD esta comprendido por los siguientes campos:
//       3 caracteres para el CR [alineado a la derecha rellenando con ceros a la izquierda],
//       1 caracter para una coma delimitadora de campos,
//       1 caracter para identificador de tipo de DMD (debe ser distinto a espacio),
//       1 caracter para una coma delimitadora de campos,
//      16 caracteres reservados para datos propios al tipo de DMD (no debe haber espacios),
//       1 carater para una coma delimitadora de campos,
//      16 caracteres para el nombre de la plantilla designada (alineado a la izquierda y rellenando la derecha con espacios),
//       1 caracter para un espacio delimitador entre DMDs
//      40 TOTAL
//      Formato: "###,@,RRRRRRRRRRRRRRRR,@@@@@@@@@@@@@@@@ "
//      Los elementos del arreglo de DMDs tienen que estar en orden creciente de CR. O sea que mirando un DMD arbitrario del arreglo, el campo CR debe ser mayor o igual a los CR correspondientes a los DMD que estan antes (a su izquierda).
// 'faeGrupoBuscado': fraccion de aporte al encuentro que se pretende tenga el grupo generado. Este parametro debe ser mayor a 0 y menor o igual a 1. El valor mas típico es 1, cuando se busca que el grupo generado sea todo el encuentro.
// 'toleranciaFaeGrupoBuscado': es la diferencia maxima que se tolera haya entre 'faeGrupoBuscado' y la fraccion de aporte al encuentro del grupo generado (faeGrupoGenerado). Existe la posibilidad de que el faeGrupoGenerado sea menor de lo tolerado si la fraccion de aporte de la criatura menos poderosa de entre las designadas es dos veces mayor a la tolerancia. Esto no es problema si despues de llamar esta funcion se usa el valor devuelto para completar el grupo con algun apendice usando la funcion RS_generarSolitario() sobre un arreglo de criaturas de CR mas bajo que la criatura de CR mas bajo del arreglo de DMD (arregloDMDs) pasado a esta funcion.
// 'ignoranFiltroFaeCriaturaMax': Indica cuantas de las primeras DMDs del arreglo ignoran el filtro de FAE maximo (ver 'filtroFaeCriaturaMax'). Por ejemplo, si este parametro vale tres, entonces las tres primeras DMDs seran eligibles incluso si la FAE correspondiente supera la FAE maxima dada por 'filtroFaeCriaturaMax'.
// 'filtroFaeCriaturaMax': Este filtro determina la maxima FAE para que un DMD sea eligible. El objetivo es evitar que se generen las criaturas correspondientes a los DMDs de CR mas alto del arreglo, cuando la dificultad del encuentro es baja. Para que este filtro no aplique, usar un 1. De este valor depende cuanto es la cantidad minima de criaturas que se generaran, cuanto mas alto el valor, mayor la probabilidad de que se generen pocas criaturas que aporten mucho (FAEs mas altos).
// 'ignoranFiltroFaeCriaturaMin': Indica cuantas de las ultimas DMDs del arreglo ignoran el filtro de FAE minimo (ver 'filtroFaeCriaturaMin').  Por ejemplo, si este parametro vale tres, entonces las tres ultimas DMDs seran eligibles incluso si la FAE correspondiente es menor a la FAE minima dada por 'filtroFaeCriaturaMax'.
// 'filtroFaeCriaturaMin': Este filtro determina la minima FAE para que un DMD sea eligible. El objetivo es evitar que se generen las criaturas correspondientes a los DMDs de CR mas bajo del arreglo, cuando la dificultad del encuentro es alta. Para que este filtro no aplique, usar un 0. De este valor depende cuanto es la cantidad maxima de criaturas que se generaran, cuanto mas bajo el valor, mayor la probabilidad de que se generen muchas criaturas que aporten poco (FAEs mas bajos).
// La funcion devuelve el factor de aporte al encuentro del grupo generado (faeGrupoGenerado).
// Tipos de DMD definidos: (por ahora hay uno solo)
// "A": la plantilla designada debe ser de una criatura cuyo CR real (no necesariamente el indicado en la plantilla de la criatura) sea el especificado en el campo CR del DMD. No usa datos propios, por ende son ignorados. Ejemplo de DMD: "123,045,A,????????????,nombreResRef     " ---> CR=12.3, tope del porcentaje aporte acumulado=45%, nombre de la plantilla de criatur="nombreResRef"
float RS_generarGrupo( struct RS_DatosSGE datosSGE, string arregloDMDs, float faeGrupoBuscado=1.0, float toleranciaFaeGrupoBuscado=0.08, int ignoranFiltroFaeCriaturaMax=1, float filtroFaeCriaturaMax=0.5, int ignoranFiltroFaeCriaturaMin=0, float filtroFaeCriaturaMin=0.16 );
float RS_generarGrupo( struct RS_DatosSGE datosSGE, string arregloDMDs, float faeGrupoBuscado=1.0, float toleranciaFaeGrupoBuscado=0.08, int ignoranFiltroFaeCriaturaMax=1, float filtroFaeCriaturaMax=0.5, int ignoranFiltroFaeCriaturaMin=0, float filtroFaeCriaturaMin=0.16 ) {
    if( !GetIsObjectValid( GetAreaFromLocation( datosSGE.ubicacionEncuentro ) ) )
        return 0.0;

    float faeGrupoMin = faeGrupoBuscado - toleranciaFaeGrupoBuscado;
    float faeGrupoMax = faeGrupoBuscado + toleranciaFaeGrupoBuscado;
    int cantDMDs = GetStringLength( arregloDMDs ) / RS_DMD_TOTAL_SIZE;

    float faeGrupoGenerado = 0.0; // aqui se van acumulando las FAE de las criaturas generadas hasta el momento
    int cotaInfDmdsEligibles = 0; // indice menor del rango de indices de DMDs eligibles
    int cotaSupDmdsEligibles = cantDMDs; // indice mayor mas uno del rango de indices de DMDs eligibles
    if( cotaSupDmdsEligibles == 0 ) {
        WriteTimestampedLogEntry( "RS_generarGrupo: Error: el arreglo de DMDs debe tener al menos un elemento. area=["+GetTag(OBJECT_SELF)+"]" );
        return 0.0;
    }

    // en cada ciclo de el siguiente bucle sucede una de dos cosas (nunca ambas): se genera la criatura asociada a un DMD elegido al azar de entre los DMD eligibles, o se achica el rango de indices de DMDs eligibles.
    while( cotaSupDmdsEligibles > cotaInfDmdsEligibles && faeGrupoGenerado < faeGrupoMin ) {
        int dcdSorteadoIndex = cotaInfDmdsEligibles + Random( cotaSupDmdsEligibles - cotaInfDmdsEligibles );
        int crDmd = StringToInt( GetSubString( arregloDMDs, dcdSorteadoIndex*RS_DMD_TOTAL_SIZE + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) );
        float poderRelativoDmd = SisPremioCombate_poderRelativoSujeto( crDmd, datosSGE.dificultadEncuentro );
        float faeDmd = poderRelativoDmd / datosSGE.poderRelativoEncuentro;

//        SendMessageToPC( GetFirstPC(), "faeDmd="+FloatToString(faeDmd)+", dcdIndex="+IntToString(dcdSorteadoIndex) );
        if( ( faeDmd > filtroFaeCriaturaMax  &&  dcdSorteadoIndex >= ignoranFiltroFaeCriaturaMax )  ||  faeDmd + faeGrupoGenerado > faeGrupoMax ) {
            cotaSupDmdsEligibles = dcdSorteadoIndex;
        }
        else {
            if( faeDmd < filtroFaeCriaturaMin && dcdSorteadoIndex < cantDMDs - ignoranFiltroFaeCriaturaMin  )
                cotaInfDmdsEligibles = dcdSorteadoIndex + 1;
            else {
                faeGrupoGenerado += faeDmd;
                RS_generarGrupo_instanciarDMD( datosSGE, arregloDMDs, dcdSorteadoIndex, faeDmd );
            }
        }
//        SendMessageToPC( GetFirstPC(), "cotaInfDmdsEligibles="+IntToString(cotaInfDmdsEligibles) +", cotaSupDmdsEligibles="+IntToString(cotaSupDmdsEligibles) +", faeGrupoGenerado="+FloatToString( faeGrupoGenerado ) );
    };
    // aqui se llego al punto en que el encuentro esta completo, o agregar el DMD eligible de menor fae superaria a faeGrupoMax

    // Lo siguiente completa el encuentro usando DMDs con fae menor a filtroFaeCriaturaMin
    float faeFaltante = faeGrupoBuscado - faeGrupoGenerado;
    if( faeFaltante > toleranciaFaeGrupoBuscado && cotaSupDmdsEligibles > 0 && faeGrupoGenerado > 0.0 ) {
        struct RS_CotasDmdMasCercano cotasDmdMasCercano = RS_acotarDmdMasCercano( datosSGE.dificultadEncuentro, arregloDMDs, faeFaltante, cotaSupDmdsEligibles, datosSGE.poderRelativoEncuentro );
        // si el fae del primer DMD del arreglo es mayor al fae faltante
        if( cotasDmdMasCercano.indiceCotaInferior < 0 ) {
            // si el fae del primer DMD no supera al fae maximo tolerado, poner el primer DMD (o cualquiera de los que le sigue con igual CR)
            if( cotasDmdMasCercano.faeCotaSuperior - faeFaltante < toleranciaFaeGrupoBuscado ) {
                RS_generarGrupo_instanciarDMD( datosSGE, arregloDMDs, cotasDmdMasCercano.indiceCotaSuperior, cotasDmdMasCercano.faeCotaSuperior );
                faeGrupoGenerado += cotasDmdMasCercano.faeCotaSuperior;
            }
        }
        // si el fae del primer DMD del arreglos es menor al fae faltante
        else {
            // poner el DMD cuyo fae se acerca mas al fae faltante
            if( cotasDmdMasCercano.faeCotaSuperior - faeFaltante < faeFaltante - cotasDmdMasCercano.faeCotaInferior ) {
                RS_generarGrupo_instanciarDMD( datosSGE, arregloDMDs, cotasDmdMasCercano.indiceCotaSuperior, cotasDmdMasCercano.faeCotaSuperior );
                faeGrupoGenerado += cotasDmdMasCercano.faeCotaSuperior;
            } else {
                RS_generarGrupo_instanciarDMD( datosSGE, arregloDMDs, cotasDmdMasCercano.indiceCotaInferior, cotasDmdMasCercano.faeCotaInferior );
                faeGrupoGenerado += cotasDmdMasCercano.faeCotaInferior;
            }
        }
    }

    return faeGrupoGenerado;
}


// Arma un arreglo de DMDs a partir de dos arreglos de DMDs. Recordar que un arreglo de DMDs debe tener sus elementos relajadamente (en opocicion a estrictamente) ordenados por el campo CR.
string RS_ArregloDMDs_sumar( string arregloA, string arregloB );
string RS_ArregloDMDs_sumar( string arregloA, string arregloB ) {

    int arregloA_posTrasUltimoDmd = GetStringLength( arregloA ); // posicion del DMD tras el último DMD del arreglo A
    int arregloA_posUltimoDmd = arregloA_posTrasUltimoDmd - RS_DMD_TOTAL_SIZE; // posicion del último DMD del arreglo A
    int arregloA_crUltimoDmd = StringToInt( GetSubString( arregloA, arregloA_posUltimoDmd + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) ); // CR del último DMD del arreglo A

    int arregloB_posTrasUltimoDmd = GetStringLength( arregloB ); // posicion del DMD tras el último DMD del arreglo B
    int arregloB_posDmdIterado; // posicion del DMD iterado del arreglo B. Se itera desde el primer hasta el ultimo DMD del arreglo B.
    for( arregloB_posDmdIterado = 0; arregloB_posDmdIterado < arregloB_posTrasUltimoDmd; arregloB_posDmdIterado += RS_DMD_TOTAL_SIZE ) {
        int arregloB_crDmdIterado = StringToInt( GetSubString( arregloB, arregloB_posDmdIterado + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) ); // CR del DMD iterado del arreglo B
        // si el CR del DMD iterado del arreglo B es mayor al CR del ultimo DMD del arreglo A
        if( arregloB_crDmdIterado >= arregloA_crUltimoDmd )
            // agregar el DMD iterado y todos los DMDs posteriores del arreglo B, al final del arreglo A. Y trabajo terminado
            return arregloA + GetStringRight( arregloB, arregloB_posTrasUltimoDmd - arregloB_posDmdIterado );
        // si el CR del DMD iterado del arreglo B es menor al CR del ultimo DMD del arreglo A
        else {
            // obtener el DMD iterado del arreglo B,
            string arregloB_dmdIterado = GetSubString( arregloB, arregloB_posDmdIterado, RS_DMD_TOTAL_SIZE );
            // e insertarlo en el arreglo A en el sitio que corresponda para que el arreglo A se mantenga ordenado.
            int arregloA_posDmdIterado;
            for( arregloA_posDmdIterado = arregloA_posUltimoDmd - RS_DMD_TOTAL_SIZE; arregloA_posDmdIterado >= 0; arregloA_posDmdIterado -= RS_DMD_TOTAL_SIZE ) {
                int arregloA_crDmdIterado = StringToInt( GetSubString( arregloA, arregloA_posDmdIterado + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) );
                if( arregloA_crDmdIterado <= arregloB_crDmdIterado )
                    break;
            }
            int posInsercion = arregloA_posDmdIterado + RS_DMD_TOTAL_SIZE;
            arregloA = GetStringLeft( arregloA, posInsercion ) + arregloB_dmdIterado + GetStringRight( arregloA, arregloA_posTrasUltimoDmd - posInsercion );
            arregloA_posUltimoDmd = arregloA_posTrasUltimoDmd;
            arregloA_posTrasUltimoDmd += RS_DMD_TOTAL_SIZE;
        }
    }
    return arregloA;
}


// Genera un solitario tal que su poder relativo al nivel de dificultad del encuentro, sea cercano al producto 'faeSolitarioBuscado * poderRelativoEncuentro'. La funcion genera un solitario solo si el 'faeSolitarioMasCercano' dista de 'faeSolitarioBuscado' menos de lo tolerado.
// 'datosSGE': debe ser el obtenido llamando a 'RS_getDatosSEG()'
// 'arregloDMDs': es el arreglo de Datos de Miembros Designados (para abreviar DMD). Ver 'RS_generarGrupo(..)' para la especificacion del formato.
//      Los elementos del arreglo de DMDs tienen que estar en orden creciente de CR. O sea que mirando un DMD arbitrario del arreglo, el campo CR debe ser mayor o igual al CR correspondientes al DMD que esta antes (a su izquierda).
// 'faeSolitarioBuscado': fraccion de aporte al encuentro que se pretende tenga el solitario generado. El valor tipico de este parametro es: 1 si el encuentro es una criatura solitaria; o uno menos el factor de aporte del grupo del que la criatura generada será apendice. Este parametro debe ser mayor a 0 y menor o igual a 1.
// La funcion devuelve el factor de aporte al encuentro del solitario generado (faeSolitarioGenerado).  Se usa un algoritmo de busqueda binaria.
float RS_generarSolitario( struct RS_DatosSGE datosSGE, string arregloDMDs, float faeSolitarioBuscado=1.0, float toleranciaFaeSolitarioBuscado=0.2 );
float RS_generarSolitario( struct RS_DatosSGE datosSGE, string arregloDMDs, float faeSolitarioBuscado=1.0, float toleranciaFaeSolitarioBuscado=0.2 ) {
    if( !GetIsObjectValid( GetAreaFromLocation( datosSGE.ubicacionEncuentro ) ) )
        return 0.0;

    int cantidadDmds = GetStringLength(arregloDMDs)/RS_DMD_TOTAL_SIZE;
    struct RS_CotasDmdMasCercano cotasDmdMasCercano = RS_acotarDmdMasCercano( datosSGE.dificultadEncuentro, arregloDMDs, faeSolitarioBuscado, cantidadDmds, datosSGE.poderRelativoEncuentro );
    int indiceSolitarioMasCercano;
    float faeSolitarioMasCercano;
    int crSolitarioMasCercano;
    if( cotasDmdMasCercano.faeCotaSuperior - faeSolitarioBuscado < faeSolitarioBuscado - cotasDmdMasCercano.faeCotaInferior ) {
        indiceSolitarioMasCercano = cotasDmdMasCercano.indiceCotaSuperior;
        faeSolitarioMasCercano = cotasDmdMasCercano.faeCotaSuperior;
        crSolitarioMasCercano = cotasDmdMasCercano.crCotaSuperior;
    } else {
        indiceSolitarioMasCercano = cotasDmdMasCercano.indiceCotaInferior;
        faeSolitarioMasCercano = cotasDmdMasCercano.faeCotaInferior;
        crSolitarioMasCercano = cotasDmdMasCercano.crCotaInferior;
    }
//    SendMessageToPC( GetFirstPC(), "indiceSolitarioMasCercano="+IntToString(indiceSolitarioMasCercano) +", faeSolitarioMasCercano="+FloatToString(faeSolitarioMasCercano) );

    if( faeSolitarioBuscado - toleranciaFaeSolitarioBuscado < faeSolitarioMasCercano && faeSolitarioMasCercano < faeSolitarioBuscado + toleranciaFaeSolitarioBuscado ) {
        // obtener el indice mas alto tal que del DMD en tal indice tiene CR menor a 'crSolitarioMasCercano'
        int indiceCrInmediatoMenor = indiceSolitarioMasCercano - 1;
        while( indiceCrInmediatoMenor >= 0 && crSolitarioMasCercano == StringToInt( GetSubString( arregloDMDs, indiceCrInmediatoMenor*RS_DMD_TOTAL_SIZE + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) ) )
            --indiceCrInmediatoMenor;

        // obtener el indice mas bajo tal que del DMD en tal indice tiene CR mayor a 'crSolitarioMasCercano'
        int indiceCrInmediatoMayor = indiceSolitarioMasCercano + 1;
        while( indiceCrInmediatoMayor < cantidadDmds && crSolitarioMasCercano == StringToInt( GetSubString( arregloDMDs, indiceCrInmediatoMayor*RS_DMD_TOTAL_SIZE + RS_DMD_CR_OFFSET, RS_DMD_CR_SIZE ) ) )
            ++indiceCrInmediatoMayor;

        // elegir un DMD de entre los que tienen el mismo CR que 'crSolitarioMasCercano'
        int indiceDmdElegido = 1 + indiceCrInmediatoMenor + Random( indiceCrInmediatoMayor - indiceCrInmediatoMenor - 1 );

        string nombrePlantilla = GetSubString( arregloDMDs, indiceDmdElegido*RS_DMD_TOTAL_SIZE + RS_DMD_TEMPLATE_OFFSET, RS_DMD_TEMPLATE_SIZE + 1 );
        nombrePlantilla = GetStringLeft( nombrePlantilla, FindSubString( nombrePlantilla, " " ) );
        object solitario = RS_crearCriatura( nombrePlantilla, datosSGE.ubicacionEncuentro );
        if( GetIsObjectValid( solitario ) ) {
            RS_marcarCriatura( datosSGE, solitario, faeSolitarioMasCercano );
//            if( FloatToInt( GetChallengeRating( solitario ) ) != crSolitario )
//                WriteTimestampedLogEntry( "RS_generarGrupo: Warning: el CR especificado en el DSD no concuerda con el de la plantilla. plantilla=["+nombrePlantilla+"]" );
        }
        else
            WriteTimestampedLogEntry( "RS_generarSolitario: Error: plantilla de criatura invalida en area=["+GetTag(OBJECT_SELF)+"]. plantilla=["+nombrePlantilla+"]" );

        return faeSolitarioMasCercano;
    } else
        return 0.0;
}



//  0123456789012345678901234567890123456789
// "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
const int RS_DVD_CR_OFFSET = 0;
const int RS_DVD_CR_SIZE = 3;
const int RS_DVD_TIPO_OFFSET = 4;
const int RS_DVD_TIPO_SIZE = 1;
const int RS_DVD_FILTRO_PAG_MIN_OFFSET = 6;
const int RS_DVD_FILTRO_PAG_MIN_SIZE = 3;
const int RS_DVD_FILTRO_PAG_MAX_OFFSET = 10;
const int RS_DVD_FILTRO_PAG_MAX_SIZE = 3;
const int RS_DVD_PLANTILLA_OFFSET = 23;
const int RS_DVD_PLANTILLA_SIZE = 16;
const int RS_DVD_TOTAL_SIZE = 40;


// Genera un grupo de una o mas criaturas con la estructura determinada por el tipo de DVD sorteado.
// Para que un DVD del arreglo sea eligible, el porcentaje de aporte al grupo (calculado del CR especificado en el DVD), debe estar entre el minimo y maximo especificado en el DVD.
// Nota: el porcentage de aporte al grupo (PAG) es el porcentaje de poder dado por una criatura al grupo buscado. No al encuentro. El grupo buscado puede ser todo o un subgrupo del encuentro. Con numeros, el PAG = 100*FAE/faeBuscado, donde FAE es la fraccion de aporte al encuentro.
//
// 'datosSGE': debe ser el obtenido llamando a 'RS_getDatosSEG()'
//
// 'arregloDVDs': es el arreglo de Datos de Varios grupos Designados (para abreviar DVD). El arreglo esta serializado a texto, donde cada elemento (un DVD) tiene una cantidad fija de caracteres (=RS_DVD_TOTAL_SIZE).
//      Cada DVD esta comprendido por los siguientes campos:
//       3 caracteres para un CR [alineado a la derecha rellenando con ceros a la izquierda],
//       1 caracter para una coma delimitadora de campos,
//       1 caracter para identificador de tipo de DVD (debe ser distinto a espacio),
//       1 caracter para una coma delimitadora de campos,
//       3 caracteres para el porcentaje de aporte al grupo minimo (PAG_MIN) [alineado a la derecha rellenando con ceros a la izquierda],
//       1 caracter para una coma delimitadora de campos,
//       3 caracteres para el porcentaje de aporte al grupo maximo (PAG_MAX) [alineado a la derecha rellenando con ceros a la izquierda],
//       1 caracter para una coma delimitadora de campos,
//       8 caracteres reservados,
//       1 caracter para una coma delimitadora de campos,
//      16 caracteres para un nombre de plantilla de criatura (alineado a la izquierda y rellenando la derecha con espacios),
//       1 caracter para un espacio delimitador entre DMDs
//      31 TOTAL
//      Formato: "###,@,###,###,????????,@@@@@@@@@@@@@@@@ "
//      Los elementos del arreglo de DMDs no requieren estar en ordenados.
//
// 'faeBuscado': fraccion de aporte al encuentro que se pretende tenga el grupo generado. Este parametro debe ser mayor a 0 y menor o igual a 1. El valor mas típico es 1, cuando se busca que el grupo generado sea todo el encuentro.
//
// 'faeTolerancia': es la diferencia maxima que se tolera haya entre 'faeGrupoBuscado' y la fraccion de aporte al encuentro del grupo generado (faeGrupoGenerado). Existe la posibilidad de que el faeGrupoGenerado sea menor de lo tolerado si la fraccion de aporte de la criatura menos poderosa de entre las designadas es dos veces mayor a la tolerancia. Esto no es problema si despues de llamar esta funcion se usa el valor devuelto para completar el grupo con algun apendice usando la funcion RS_generarSolitario() sobre un arreglo de criaturas de CR mas bajo que la criatura de CR mas bajo del arreglo de DMD (arregloDMDs) pasado a esta funcion.
//
// La funcion devuelve el factor de aporte al encuentro del grupo generado (faeGrupoGenerado).
//
// Tipos de DVD definidos: (por ahora hay 3)
// "S": genera una criatura solitaria
// "M": genera un grupo de criaturas homogeneo
// "L": genera un grupo comprendido por un lider y cero o mas seguidores. El CR y plantilla del seguidor debe estar especificado en variables locales del lider (ver 'creature property names' en el script "RS_itf").
//
float RS_generarVariado( struct RS_DatosSGE datosSGE, string arregloDVDs, float faeBuscado, float faeTolerancia, float faeMaximo=1.1 );
float RS_generarVariado( struct RS_DatosSGE datosSGE, string arregloDVDs, float faeBuscado, float faeTolerancia, float faeMaximo=1.1 ) {

    int cantParaElegir = GetStringLength( arregloDVDs )/RS_DVD_TOTAL_SIZE;
    while( cantParaElegir > 0 ) {
        int dvdSorteadoIndex = Random( cantParaElegir );
//        PrintString( IntToString( dvdSorteadoIndex ) +" ["+ arregloDVDs+"]" );
        int dvdCr = StringToInt( GetSubString( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE + RS_DVD_CR_OFFSET, RS_DVD_CR_SIZE ) );
        float criaturaFae = SisPremioCombate_poderRelativoSujeto( dvdCr, datosSGE.dificultadEncuentro ) / datosSGE.poderRelativoEncuentro;
        int criaturaPag = FloatToInt( 100.0*criaturaFae/faeBuscado );
        int dvdFiltroPagMin = StringToInt( GetSubString( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE + RS_DVD_FILTRO_PAG_MIN_OFFSET, RS_DVD_FILTRO_PAG_MIN_SIZE ) );
        int dvdFiltroPagMax = StringToInt( GetSubString( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE + RS_DVD_FILTRO_PAG_MAX_OFFSET, RS_DVD_FILTRO_PAG_MAX_SIZE ) );
        if( criaturaPag < dvdFiltroPagMin  ||  dvdFiltroPagMax < criaturaPag || criaturaFae > faeMaximo) {
            arregloDVDs = GetStringLeft( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE ) + GetStringRight( arregloDVDs, (cantParaElegir - dvdSorteadoIndex - 1)*RS_DVD_TOTAL_SIZE );
            cantParaElegir -= 1;
        } else {
            string dvdTipo = GetSubString( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE + RS_DVD_TIPO_OFFSET, RS_DVD_TIPO_SIZE );
            string dvdPlantilla = GetSubString( arregloDVDs, dvdSorteadoIndex*RS_DVD_TOTAL_SIZE + RS_DVD_PLANTILLA_OFFSET, RS_DVD_PLANTILLA_SIZE + 1 );
            dvdPlantilla = GetStringLeft( dvdPlantilla, FindSubString( dvdPlantilla, " " ) );

            if( dvdTipo == "M" ) {
                return RS_generarGrupoHomogeneo( datosSGE, dvdCr, dvdPlantilla, faeBuscado, faeTolerancia );

            } else if( dvdTipo == "S" ) {
                object criatura = RS_crearCriatura( dvdPlantilla, datosSGE.ubicacionEncuentro );
                if( GetIsObjectValid( criatura ) ) {
                    RS_marcarCriatura( datosSGE, criatura, criaturaFae );
                    return criaturaFae;
                } else {
                    WriteTimestampedLogEntry( "RS_generarVariado: error, plantilla invalida en area=["+GetTag(OBJECT_SELF)+"]. plantilla=[" + dvdPlantilla + "]" );
                    return 0.0;
                }
            } else if( dvdTipo == "L" ) {
                object criatura = RS_crearCriatura( dvdPlantilla, datosSGE.ubicacionEncuentro );
                if( GetIsObjectValid( criatura ) ) {
                    RS_marcarCriatura( datosSGE, criatura, criaturaFae );
                    string plantillaSeguidores = GetLocalString( criatura, RS_plantillaSeguidores_PN );
                    int crSeguidores = GetLocalInt( criatura, RS_crSeguidor_PN );
                    if( plantillaSeguidores != "" && crSeguidores > 0 )
                        return criaturaFae + RS_generarGrupoHomogeneo( datosSGE, crSeguidores, plantillaSeguidores, faeBuscado - criaturaFae, faeTolerancia );
                    else {
                        WriteTimestampedLogEntry( "RS_generarVariado: error, los datos de seguidor en la plantilla de lider son invalidos. area=["+GetTag(OBJECT_SELF)+"]. plantilla=[" + dvdPlantilla + "]" );
                        return criaturaFae;
                    }
                } else {
                    WriteTimestampedLogEntry( "RS_generarVariado: error, plantilla invalida. area=["+GetTag(OBJECT_SELF)+"]. plantilla=[" + dvdPlantilla + "]" );
                    return 0.0;
                }

            } else {
                WriteTimestampedLogEntry( "RS_generarVariado: error, tipo de DVD invalido. area=["+GetTag(OBJECT_SELF)+"]" );
                return 0.0;
            }

        } // else
    } // while
    if( faeBuscado >= 1.0 )
        WriteTimestampedLogEntry( "RS_generarVariado: error, ningun DVD del arreglo satiface en area=["+GetTag(OBJECT_SELF)+"]." );
    return 0.0;
}


// Igual que 'RS_generarVariado(..)', excepto que, si el sub-encuentro generado tiene un
// fae menor a 'faeBuscado - faeTolerancia', genera otro sub-encuentro para completar el
// 'faeBuscado'. Esto se repite hasta que la suma de los fae de los sub-encuentros generados
// sea mayor a 'fabeBuscado-faeTolerancia'.
float RS_generarMezclado( struct RS_DatosSGE datosSGE, string arregloDVDs, float faeMaximo=1.1, float faeBuscado=1.0, float faeTolerancia=0.1 );
float RS_generarMezclado( struct RS_DatosSGE datosSGE, string arregloDVDs, float faeMaximo=1.1, float faeBuscado=1.0, float faeTolerancia=0.1 ) {
    float faeGeneradoAcumulado = 0.0;
    do {
        float faeGenerado = RS_generarVariado( datosSGE, arregloDVDs, faeBuscado - faeGeneradoAcumulado, faeTolerancia, faeMaximo );
        faeGeneradoAcumulado += faeGenerado;
        if( faeGeneradoAcumulado > faeBuscado - faeTolerancia || faeGenerado == 0.0 )
            break;
        datosSGE = RS_generarUbicacionSGE( datosSGE );
    } while( TRUE );
    return faeGeneradoAcumulado;
}


/*
Notas sobre el grado de desafio de las criaturas y el parametro 'poderRelativoEncuentro'.
El parametro 'poderRelativoEncuentro' depende de como este definido el CR de las criaturas, de cuantos
encuentros se busca pueda superar entre descansos un party de una cantidad determinada de
sujetos, y de la sinergia por agrupacion de criaturas.
Asumiendo que la sinergía es nula, y que se busque que parties de cinco sujetos logren superar
a cinco encuentros entre descansos, el valor de 'poderRelativoEncuentro' debe ser:
1) Si CR esta definido tal que una criatura CR X empata contra un personaje nivel X de la misma clase: entonces si 'poderRelativoEncuentro' vale N, el encuentro generado sera equivalente a un grupo de N personajes nivel X. Por ende, estimo que 'poderRelativoEncuentro' debe valer entre 2 y 2.5 para que el party tolere cinco encuentros sucesivos.
2) Si CR esta definido tal que una criaturas CR X empata contra un party de cinco personajes nivel X consumido por haber vencido a otras cuatro criaturas CR X por separado: entonces 'poderRelativoEncuentro' debe valer 1.

Importante: En el CR de una criatura NO debe estar contemplada la sinergia, a no ser que
siempre se la agrupe con las mismas criaturas (cosa que limita las variantes). La sinergia
debe ser contemplada UNICAMENTE en el script que arma los grupos.
Por ejemplo, si el grupo generado esta compuesto por criaturas de la misma clase, lo mas
probable es que la sinergia sea nula. Entonces el parametro 'poderRelativoEncuentro' debe valer como
dice en (1) o (2) segun sea el caso.
En cambio, si el grupo generado esta compuesto por criaturas de clases que se complementan, lo
mas probable es que la sinergia sea conciderable. Entonces el parametro 'poderRelativoEncuentro' debe ser
disminuido en una proporcion igual a la proporcion de aumtento del poder gracias a la
singergia. O sea que si la sinergia aumenta el poder del encuentro en un 10%, el parametro
'poderRelativoEncuentro' debe ser un 10% menor a lo que se indica en (1) y (2).
*/

/* Como usar las funciones RS_generarGrupo():
La forma mas sencilla de uso, pero menos acertada, es haciendo una única llamada que cree un
grupo del poder total del encuentro. Asi:
    generarGrupo( datosSGE, <todas las criaturas designadas> );
Dado que asi las criaturas son tomadas puramente al azar, es posible que se de tanto el caso
en que la sinergia sea nula o máxima. Entonces el poder del encuentro tendra una varianza elevada.

Para evitar las varianzas por sinergia, y asumiendo que hay tres clases distintas de criaturas
entre las designadas para el encuentro, es necesario hacer tres llamadas. Asi:
    fraccionGenerada1 = generarGrupo( datosSGE, <criaturas clase 1 de entre las designadas>, 1/3 );
    fraccionGenerada2 = generarGrupo( datosSGE, <criaturas clase 2 de entre las designadas>, 1/3 );
    fraccionGenerada3 = generarGrupo( datosSGE, <criaturas clase 3 de entre las designadas>, 1-fraccionGenerada1-fraccionGenerada2 );
Si generarGrupo consiguió criaturas dentro de la tolerancia especificada, la suma de las tres
fraccioneGenerada# dará cerca de uno.

*/

