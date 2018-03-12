//Este script permite que al utilizar un item (una palanca por ejemplo) aparezca en un area distintos items, y al volver a accionar ese item desaparezcan.
//Teatro de Brosna - Escenario 1 - Bosque
const string REFERENCIA_AL_PLACEABLE_1 = "referenciaAlPlaceable1";
const string REFERENCIA_AL_PLACEABLE_2 = "referenciaAlPlaceable2";
const string REFERENCIA_AL_PLACEABLE_3 = "referenciaAlPlaceable3";
const string REFERENCIA_AL_PLACEABLE_4 = "referenciaAlPlaceable4";
const string REFERENCIA_AL_PLACEABLE_5 = "referenciaAlPlaceable5";
const string REFERENCIA_AL_PLACEABLE_6 = "referenciaAlPlaceable6";
const string REFERENCIA_AL_PLACEABLE_7 = "referenciaAlPlaceable7";
const string REFERENCIA_AL_PLACEABLE_8 = "referenciaAlPlaceable8";
const string REFERENCIA_AL_PLACEABLE_9 = "referenciaAlPlaceable9";
const string REFERENCIA_AL_PLACEABLE_10 = "referenciaAlPlaceable10";
const string REFERENCIA_AL_PLACEABLE_11 = "referenciaAlPlaceable11";
const string REFERENCIA_AL_PLACEABLE_12 = "referenciaAlPlaceable12";
const string REFERENCIA_AL_PLACEABLE_13 = "referenciaAlPlaceable13";
const string REFERENCIA_AL_PLACEABLE_14 = "referenciaAlPlaceable14";
const string REFERENCIA_AL_PLACEABLE_15 = "referenciaAlPlaceable15";
const string REFERENCIA_AL_PLACEABLE_16 = "referenciaAlPlaceable16";
const string REFERENCIA_AL_PLACEABLE_17 = "referenciaAlPlaceable17";
const string REFERENCIA_AL_PLACEABLE_18 = "referenciaAlPlaceable18";
const string REFERENCIA_AL_PLACEABLE_19 = "referenciaAlPlaceable19";
void main() {
    object bola = OBJECT_SELF;
    object placeable1 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_1 );
    object placeable2 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_2 );
    object placeable3 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_3 );
    object placeable4 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_4 );
    object placeable5 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_5 );
    object placeable6 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_6 );
    object placeable7 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_7 );
    object placeable8 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_8 );
    object placeable9 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_9 );
    object placeable10 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_10 );
    object placeable11 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_11 );
    object placeable12 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_12 );
    object placeable13 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_13 );
    object placeable14 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_14 );
    object placeable15 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_15 );
    object placeable16 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_16 );
    object placeable17 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_17 );
    object placeable18 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_18 );
    object placeable19 = GetLocalObject( bola, REFERENCIA_AL_PLACEABLE_19 );

    if( GetIsObjectValid( placeable1 )) {
         DestroyObject( placeable1 );
         DestroyObject( placeable2 );
         DestroyObject( placeable3 );
         DestroyObject( placeable4 );
         DestroyObject( placeable5 );
         DestroyObject( placeable6 );
         DestroyObject( placeable7 );
         DestroyObject( placeable8 );
         DestroyObject( placeable9 );
         DestroyObject( placeable10 );
         DestroyObject( placeable11 );
         DestroyObject( placeable12 );
         DestroyObject( placeable13 );
         DestroyObject( placeable14 );
         DestroyObject( placeable15 );
         DestroyObject( placeable16 );
         DestroyObject( placeable17 );
         DestroyObject( placeable18 );
         DestroyObject( placeable19 );
    }
    else {
        location lTarget;

        lTarget = Location( GetArea(bola), Vector( 77.35, 32.74, -0.23) , 0.0 );
        placeable1 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_1, placeable1 );

        lTarget = Location( GetArea(bola), Vector( 72.37, 32.74, -0.23) , 0.0 );
        placeable2 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_2, placeable2 );

        lTarget = Location( GetArea(bola), Vector( 67.35, 32.74, -0.23) , 0.0 );
        placeable3 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_3, placeable3 );

        lTarget = Location( GetArea(bola), Vector( 62.35, 32.74, -0.23) , 0.0 );
        placeable4 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_4, placeable4 );

        lTarget = Location( GetArea(bola), Vector( 57.37, 32.74, -0.23) , 0.0 );
        placeable5 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_5, placeable5 );

        lTarget = Location( GetArea(bola), Vector( 52.40, 32.74, -0.23) , 0.0 );
        placeable6 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_6, placeable6 );

        lTarget = Location( GetArea(bola), Vector( 77.26, 37.67, -0.23) , 0.0 );
        placeable7 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_7, placeable7 );

        lTarget = Location( GetArea(bola), Vector( 72.27, 37.67, -0.23) , 0.0 );
        placeable8 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_8, placeable8 );

        lTarget = Location( GetArea(bola), Vector( 67.29, 37.67, -0.23) , 0.0 );
        placeable9 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_9, placeable9 );

        lTarget = Location( GetArea(bola), Vector( 62.33, 37.67, -0.23) , 0.0 );
        placeable10 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_10, placeable10 );

        lTarget = Location( GetArea(bola), Vector( 57.33, 37.67, -0.23) , 0.0 );
        placeable11 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_11, placeable11 );

        lTarget = Location( GetArea(bola), Vector( 52.38, 37.67, -0.23) , 0.0 );
        placeable12 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_grasstuft001", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_12, placeable12 );

        lTarget = Location( GetArea(bola), Vector( 74.64, 35.98, -0.23) , 0.0 );
        placeable13 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_tree053", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_13, placeable13 );

        lTarget = Location( GetArea(bola), Vector( 71.09, 32.78, -0.23) , 0.0 );
        placeable14 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_pinetr27", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_14, placeable14 );

        lTarget = Location( GetArea(bola), Vector( 66.54, 34.48, -0.23) , 0.0 );
        placeable15 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_tree016", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_15, placeable15 );

        lTarget = Location( GetArea(bola), Vector( 62.4, 34.21, -0.23) , 0.0 );
        placeable16 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_tree041", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_16, placeable16 );

        lTarget = Location( GetArea(bola), Vector( 57.47, 33.12, -0.23) , 0.0 );
        placeable17 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_treanttree", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_17, placeable17 );

        lTarget = Location( GetArea(bola), Vector( 57.22, 37.09, -0.23) , 0.0 );
        placeable18 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_pinetr17", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_18, placeable18 );

        lTarget = Location( GetArea(bola), Vector( 53.97, 35.66, -0.23) , 88.6 );
        placeable19 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_pinetr17", lTarget );
        SetLocalObject( bola, REFERENCIA_AL_PLACEABLE_19, placeable19 );
    }
}
