/*****************************************************************************
Script By Zero

Script que se ejecuta en la salida del area Plano de la Fuga

08/03/07: modificado por dragoncin
quite el cambio en la base de datos y lo deje en la estatua del fugue
*****************************************************************************/

#include "muerte_inc"
#include "Skills_sinergy"
#include "IPS_inc"

void main()
{

    object oPC = GetExitingObject();

    //Quita la invulnerabilidad que impide combates en el fugue
    SetPlotFlag(oPC, FALSE);

    if( GetIsPC(oPC) ) {
        Skills_Sinergy_applyGeneralSinergies( oPC );

        // pone al máximo la vida del PJ en la DB para que al entrar al mundo el ajustador de vida no le haga daño (ver 'Entradas_ajustarVida(..)' ).
        string pcId = GetStringLeft( GetName(oPC), 25 );
        SetCampaignInt( "Vidade", "vida"+pcId, GetMaxHitPoints(oPC) );

        // ---> Retiramos el fallo arcano aplicado en la entrada al area
        object areaFugue = GetArea(GetWaypointByTag(WAYPOINT_FUGUE));
        effect efectoIterado = GetFirstEffect( oPC );
        while (GetIsEffectValid( efectoIterado ))
        {
            if (GetEffectCreator( efectoIterado ) == areaFugue)
                RemoveEffect( oPC, efectoIterado );
            efectoIterado = GetNextEffect( oPC );
        }
        // <---

        // quitar permiso de quite de Items malditos ahora que se sale del fugue
        DeleteLocalInt( oPC, IPS_Subject_isAutoReequipDisabled_VN );

    }
}
