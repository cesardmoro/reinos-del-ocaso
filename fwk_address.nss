/**************************** struct Address *************************************
Autor: Guido Gustavo Pollitzer
Version: 0.1
Descripcion: Referencia a una instancia de alguna clase concreta que derive de
Instance.

Para no confundir los tipos de datos nativos del NWNScript (int, float, string,
etc. ) con los tipos de datos adquiridos con este framework, se llamara a los
ultimos 'tipos adquiridos'. Estos a su vez estan divididos en dos grupos, las
interfaces y las clases.

La estructura de datos de una instancia de una clase (tipo adquirido) esta
implementada con variables nativas locales a un objeto nativo. A este objeto
se lo llamara 'vecindario' con el solo proposito de diferenciar cuando se esta
hablando del domicilio (Address) de la instancia de tipo de dato adquirido, en
contraposicion a cuando se habla de una instancia de un objeto nativo.

La estructura de datos de tipo adquirido se implementa usando string nativos
como direcciones a las variables miembro.
Cuando un string nativo se lo use como direccion de una instancia de tipo
adquirido, se lo llamara 'camino' o 'referencia'.
Por ejemplo, sea una tipo adquirido concreto llamado 'Cuenta', sean 'usuario' y
'clave' los nombres de dos variables miembro de 'Cuenta' de tipo nativo, y sea
'fulano' una instancia de 'Cuenta'. Entonces, habra dos variables locales nativas
llamadas 'fulano.usuario' y 'fulano.clave'.
Sea 'Persona' otro tipo adquirido con dos variables miembro de tipo nativo
llamadas 'nombre' y 'apellido'. Sea 'datosPersonales' otro miembro de 'Cuenta'
de tipo 'Persona'. Entonces por 'fulano' habra, ademas de las mencionadas, dos
variables locales nativas llamadas 'fulano.datosPersonales.nombre' y
'fulano.datosPersonales.apellido'.
Notar que por cada instancia de 'Cuenta' habra cuatro variables locales nativas.
Una por cada miembro nativo de 'Cuenta'.

Se dice que dos instancias son vecinas si el campo 'nbh' de las instancias de
Address que hacen referencia a ellas son iguales. O sea, cuando las variables
locales nativas con las que estan implementadas la estructuras de datos de dos
tipos adquiridos son todas locales al mismo objeto nativo.
********************************************************************************/


/////////////////////// CONSTANTES ////////////////////////////////////////////

// Delimitador usado para separar los nombres de las intancias que forman
// el camino de correspondencia o contencion. O sea, el '#' se puede interpretar como
// un "correspondiente a" o "contenido en" */
const string Address_CHILD_PARENT_DELIMITER = "#";


////////////////////// DEFINICION DE 'Address (Domicilio)' //////////////////////////////

// referencia a una instancia de alguna clase concreta que derive de Instance.
struct Address {
    object nbh; // neighborhood (vecindario)
    string path
        /* Camino que identifica univocamente la intancia dentro del vecindario.
        El camino es una serie de nombres de intancias, delimitados por
        'Address_CHILD_PARENT_DELIMITER', que determina el recorrido de la hoja
        al tronco en una estrutura tipo arbol donde las ligaduras representan
        alguna correspondencia entre las intancias. La correspondencia elejida
        puede ser cualquiera (contencion por ejemplo) siempre y cuando se evite
        conflictos de nombres; que es el proposito de esta metodologia para dar
        nombres. Ejemplo: "bicicleta3#bicicleteriaPepito".

        Cuando una intancia del camino es un campo de otra intancia, este nombre
        estara formado por el camino en la estructura de tipo arbol desde el tipo
        mas agregado al componente; donde las
        ligaduras son '.' y representan composicion.
        Ejemplo: "cuenta5.nombre#listaDeCuentasDeFulanito". */
    ;
};


// Crea un Address a partir del neighborhood (vecindario) y el path (camino)
struct Address Address_create( object nbh, string path );
struct Address Address_create( object nbh, string path ) {
    struct Address result;
    result.nbh = nbh;
    result.path = path;
    return result;
}


// Arma el domicilio de una intancia anidada por correspondencia o contencion a
// otra intancia con el domicilio dado por 'parent'.
// La ventaja de hacer que un domicilio este anidado, es que se evitan
// conflictos por nombres iguales anidados por distintos instancias.
// Ver descripcion del campo 'path' de 'Address'.
struct Address Address_buildChild( string childName, struct Address parent );
struct Address Address_buildChild( string childName, struct Address parent ) {
    parent.path = childName + Address_CHILD_PARENT_DELIMITER + parent.path;
    return parent;
}


// Arma el domicilio del campo 'fieldName' de una instancia 'childName'
// anidada por correspondencia a la intancia 'parentName'.
// Los contenedores suelen usar esta operacion para armar los domicilios
// de los enlaces hacia (vector) y entre (lista) las intancias contenidas.
string Address_buildChildField( string childName, string fieldName, string parentName );
string Address_buildChildField( string childName, string fieldName, string parentName ) {
    return childName + "." + fieldName + Address_CHILD_PARENT_DELIMITER + parentName;
}



// Obtiene el nombre de la instancia mas interna de la estructura anidada
// que forma el nombre de este domicilio.
// Si la intancia apuntada por este domicilio no es esta anidada, devuelve
// su mismo nombre.
string Address_getChildName( struct Address this );
string Address_getChildName( struct Address this ) {
    int delimiterPos = FindSubString( this.path, Address_CHILD_PARENT_DELIMITER );
    if( delimiterPos == -1 )
        return this.path;
    else
        return GetStringLeft( this.path, delimiterPos );
}


//void main(){}
