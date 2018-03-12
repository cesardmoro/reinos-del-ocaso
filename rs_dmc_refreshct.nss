#include "RS_dmc_inc"

// Solo refresca los custom tokens
int StartingConditional() {

    string autoResetMsg;
    object area = GetArea( GetPCSpeaker() );
    int autoResetTimer = GetLocalInt( area, RS_dmControlTimer_VN );
    if( autoResetTimer > 0 )
        autoResetMsg = "(los valores originales se auto repondran en "+IntToString(autoResetTimer)+" minutos)";
    else
        autoResetMsg = "(valores originales)";

    SetCustomToken( 5700, autoResetMsg );

    switch( RS_DMC_getEstado() ) {
        case RS_Estado_PASIVO:
            SetCustomToken( 5701, "Pasivo" );
        break;
        case RS_Estado_ACTIVO:
            SetCustomToken( 5701, "Alerta\nCantidad encuentros sucesivos generados: "+IntToString( RS_DMC_getNES() ) );
        break;
        case RS_Estado_HOSTIL:
            SetCustomToken( 5701, "Hostil\nCantidad encuentros sucesivos generados: "+IntToString( RS_DMC_getNES() ) );
        break;
    }

    SetCustomToken( 5711, IntToString( RS_DMC_getCr() ) );
    SetCustomToken( 5712, IntToString( RS_DMC_getDMin() ) );
    SetCustomToken( 5713, IntToString( RS_DMC_getSPE() ) );
    SetCustomToken( 5714, IntToString( FloatToInt( RS_PERIODO_TIPICO_ENTRE_ENCUENTROS_SUCESIVOS_CUANDO_CINCO_SUJETOS*( 1.0 + GetLocalFloat( area, RS_modificadorPeriodoSpawn_PN ) ) ) ) );
    SetCustomToken( 5720, IntToString( RS_DMC_getMPS() ) );
    SetCustomToken( 5715, RS_DMC_getSGE() );
    SetCustomToken( 5716, IntToString( RS_getCantidadRefuerzos( area ) ) );
    SetCustomToken( 5717, IntToString( RS_DMC_getMCESR() ) );
    SetCustomToken( 5718, IntToString( RS_getPorcentajeAumentoPoderUltimoRefuerzo( area ) ) );
    SetCustomToken( 5719, IntToString( RS_DMC_getAPUR() ) );

    return TRUE;
}
