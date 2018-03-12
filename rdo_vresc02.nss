//Este script permite que al utilizar un item (una palanca por ejemplo) aparezca en un area distintos items, y al volver a accionar ese item desaparezcan.
//Teatro de Brosna - Escenario 2 - Sala del Trono
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
    object palanca = OBJECT_SELF;
    object placeable1 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_1 );
    object placeable2 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_2 );
    object placeable3 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_3 );
    object placeable4 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_4 );
    object placeable5 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_5 );
    object placeable6 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_6 );
    object placeable7 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_7 );
    object placeable8 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_8 );
    object placeable9 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_9 );
    object placeable10 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_10 );
    object placeable11 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_11 );
    object placeable12 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_12 );
    object placeable13 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_13 );
    object placeable14 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_14 );
    object placeable15 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_15 );
    object placeable16 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_16 );
    object placeable17 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_17 );
    object placeable18 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_18 );
    object placeable19 = GetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_19 );

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

        lTarget = Location( GetArea(palanca), Vector( 64.85, 34.29, -0.22) , 0.0 );
        placeable1 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_roundrugorien", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_1, placeable1 );

        lTarget = Location( GetArea(palanca), Vector( 64.92, 32.91, -0.24) , 270.0 );
        placeable2 = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_throneevil", lTarget );
        SetName( placeable2, "" );
        SetUseableFlag( placeable2, TRUE );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_2, placeable2 );


        lTarget = Location( GetArea(palanca), Vector( 67.32, 33.7, -0.24) , 270.0  );
        placeable3 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_throne001", lTarget );
        SetName( placeable3, "" );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_3, placeable3 );


        lTarget = Location( GetArea(palanca), Vector( 62.38, 33.74, -0.24) , 270.0  );
        placeable4 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_throne001", lTarget );
        SetName( placeable4, "" );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_4, placeable4 );


        lTarget = Location( GetArea(palanca), Vector( 71.55, 33.96, -0.24) , 270.0 );
        placeable5 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_bench001", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_5, placeable5 );
        SetName( placeable5, "" );

        lTarget = Location( GetArea(palanca), Vector( 58.25, 33.94, -0.24) , 270.0  );
        placeable6 = CreateObject( OBJECT_TYPE_PLACEABLE, "zep_bench001", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_6, placeable6 );
        SetName( placeable6, "" );

        lTarget = Location( GetArea(palanca), Vector( 77.74, 32.88, -0.25) , 90.0  );
        placeable7 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_7, placeable7 );

        lTarget = Location( GetArea(palanca), Vector( 73.37, 32.88, -0.25) , 90.0  );
        placeable8 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_8, placeable8 );

        lTarget = Location( GetArea(palanca), Vector( 69.03, 32.88, -0.25) , 90.0 );
        placeable9 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_9, placeable9 );

        lTarget = Location( GetArea(palanca), Vector( 64.67, 32.88, -0.25) , 90.0 );
        placeable10 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_10, placeable10 );

        lTarget = Location( GetArea(palanca), Vector( 60.30, 32.88, -0.25) , 90.0 );
        placeable11 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_11, placeable11 );

        lTarget = Location( GetArea(palanca), Vector( 55.93, 32.88, -0.25) , 90.0 );
        placeable12 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_12, placeable12 );

        lTarget = Location( GetArea(palanca), Vector( 52.18, 32.88, -0.25) , 90.0 );
        placeable13 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_13, placeable13 );

        lTarget = Location( GetArea(palanca), Vector( 77.07, 37.76, -0.25) , 180.0 );
        placeable14 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_14, placeable14 );

        lTarget = Location( GetArea(palanca), Vector( 71.25, 37.76, -0.25) , 180.0 );
        placeable15 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_15, placeable15 );

        lTarget = Location( GetArea(palanca), Vector( 65.44, 37.76, -0.25) , 180.0 );
        placeable16 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_16, placeable16 );

        lTarget = Location( GetArea(palanca), Vector( 59.61, 37.76, -0.25) , 180.0 );
        placeable17 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_17, placeable17 );

        lTarget = Location( GetArea(palanca), Vector( 53.81, 37.76, -0.25) , 180.0 );
        placeable18 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_18, placeable18 );

        lTarget = Location( GetArea(palanca), Vector( 52.96, 37.76, -0.25) , 180.0 );
        placeable19 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_ruglarge", lTarget );
        SetLocalObject( palanca, REFERENCIA_AL_PLACEABLE_19, placeable19 );

    }
}
