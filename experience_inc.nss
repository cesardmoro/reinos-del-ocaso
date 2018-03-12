/////////////
// 08/04/07 Script By Dragoncin
// 28/07/07 Mondificaciones varias y agregados por Inquisidor
// Conjunto de funciones relacionadas con la experiencia
///////////////

#include "RDO_Races_itf"
#include "Location_tools"

////////////////////////////// CONSTANTES /////////////////////////////////////

const string XP_DATABASE = "Xp";
const string XPVAR_XP_DATABASE = "Xp";
const int MODULE_MAX_CR = 19; // CR del area con mayor CR del modulo

//////////////////////////// Pj variable names /////////////////////////////////
const string Experience_hayQueAjustar_VN = "XPhqa";

////////////////////// DECLARACION PREVIA DE FUNCIONES ////////////////////////

// Da experiencia a una criatura y la agrega a la base de datos
// No significa que luego de llamada la funcion, toda la experiencia del pj sea legal
// Esta funcion tiene en cuenta penas por multiclase y clases favorecidas de las subrazas
//void GiveLegalXP( object oPC, int nXPAmount );

// Setea la experiencia de una criatura y se asegura que esta sea legal
// Luego de llamada esta funcion, toda la experiencia del pj es legal
// Por ende, llamar solo cuando se sabe que nXPAmount es legal. Si no, usar GiveLegalXPToPC()
void Experience_poner( object oPC, int nXpAmount );

// Delevels a PC then restores xp.
// Sacada de deity_onlevel
void ResetLevel( object oPC );

// Controla si la experiencia del sujeto coincide con la de la base de datos
// Si la experiencia del sujeto es menor que la de la base de datos, ajusta la base de datos.
// Si la experiencia del sujeto mayor que la de la base de datos, ajusta la experiencia del sujeto
//void LegalizarXP( object oPC );

//////////////////////////////// FUNCIONES ////////////////////////////////////

/*void GiveLegalXP( object oPC, int nXPAmount )
{
    int xpAmount = Races_GetFavouredClassAdjustedXP(nXPAmount, oPC);
    GiveXPToCreature(oPC, xpAmount);
    int databaseXP = GetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, oPC );
    SetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, databaseXP+xpAmount, oPC);
    WriteTimestampedLogEntry("[XP] "+GetName(oPC, TRUE)+" gana "+IntToString(xpAmount)+" puntos de experiencia");
}*/


void Experience_poner( object sujeto, int xp ) {
    SetXP( sujeto, xp );
    SetCampaignInt( XP_DATABASE, XPVAR_XP_DATABASE, xp, sujeto );
}


// Nota por Dragoncin: no probé qué pasa si se saca el DelayCommand
void ResetLevel(object oPC)
{
    int iXP = GetXP(oPC);           // XP to restore to.
    int iLevel = GetHitDice(oPC);   // Level to drop below.
    int iXPLastLevel = (iLevel * (iLevel - 1)) / 2 * 1000 - 1;  // XP for current level minus 1.

    // Remove the most recent leveling, and restore it.
    SetXP(oPC, iXPLastLevel);
    DelayCommand(0.5, SetXP(oPC, iXP)); // Delayed so the GUI reacts properly.
}


/*void LegalizeXP( object oPC )
{
    int databaseXP = GetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, oPC);
    int playerXP = GetXP(oPC);

    if (playerXP > databaseXP)
        SetXP(oPC, databaseXP);
    else if (playerXP < databaseXP)
        SetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, playerXP, oPC);
}*/



/* Agregado por Inquisidor BEGIN */

// calcula el nivel en funcion de la XP
int Experience_calcularNivel( int xp ) {
    return ( FloatToInt( pow( IntToFloat( (xp + 125)*5 ), 0.5 ) ) + 25 ) / 50;
}


// control y ajuste de diferencias de XP entre DB y PJ
// Devuelve TRUE cuando el PJ esta en regla o fue automaticamente ajustado para que lo este.
// Devuelve FALSE cuando:
// 1) El PJ fue enviado al banish porque su nivel supera al registrado en la DB.
// 2) El PJ fue enviado al gate porque por alguna razon el PJ tiene menor nivel que el correspondiente a la XP
// registrada en la DB. De suceder esto, el jugador es adviertido que de bajar a Nordock perdería la diferencia.
// 3) El PJ fue pateado por ser nuevo y con el mismo nombre que uno registrado.
int Experience_pasaControlYAjuste( object oPC );
int Experience_pasaControlYAjuste( object oPC ) {
    int xpEnDB = GetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, oPC);
    int xpEnPj = GetXP(oPC);
    int diferenciaNivel = Experience_calcularNivel(xpEnPj) - Experience_calcularNivel(xpEnDB);
    int esAprobado;

    if( xpEnPj == xpEnDB )
        esAprobado = TRUE;
    else if( xpEnPj == 0 ) {// esto nunca debe cumplirse ya que se lo patea en 'mod_onenter'. Sucede si es un nuevo PJ con el mismo nombre que un PJ registrado.
        BootPC( oPC );
        return FALSE;
    }
    else if( 0 < xpEnPj  &&  xpEnPj < xpEnDB ) {
        if( diferenciaNivel == 0 ) {
            SetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, xpEnPj, oPC);
            esAprobado = TRUE;
        } else {
            object gateWP = GetWaypointByTag( "gateWP" );
            AssignCommand( oPC, Location_forcedJump( GetLocation(gateWP) ) );

            int diferencia = xpEnDB - xpEnPj;
            string mensaje = "Por alguna razón desconocida, la experiencia de tu personaje difiere de la esperada.\nTienes dos opciones, hablar con Marduk-DM o inquisidor, o bajar a Nordock y perder la diferencia ("+IntToString(diferencia)+").";
            SendMessageToPC(oPC, mensaje);
            SetLocalInt( oPC, Experience_hayQueAjustar_VN, TRUE ); // la observa y la borra el onExit del gate ("gateout")
            esAprobado = FALSE;
        }
    }
    else if( xpEnPj > xpEnDB && diferenciaNivel == 0 ) {
        SetXP( oPC, xpEnDB );
        esAprobado = TRUE;
    }
    else if( xpEnPj > xpEnDB && diferenciaNivel > 0 ) {
        if( GetPCPublicCDKey(oPC)=="" || GetPCPlayerName(oPC) == "Inquisiclor" || GetLocalInt(oPC,"ajustarXpEnDb") ) {
            SetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, xpEnPj, oPC);  // esto esta para evitarme modificar estas lineas cada vez que hago pruebas localmente.
            DeleteLocalInt( oPC, "ajustarXpEnDb" );
        }
        else {
            object banishWP = GetWaypointByTag( "banishWP" );
            AssignCommand( oPC, Location_forcedJump( GetLocation(banishWP) ) );
            SendMessageToPC( oPC, "Tu personaje no puede entrar a Reinos del Ocaso por tener mas nivel del registrado.\nPor favor contactate con algún DM, y disculpá las molestias." );
        }
        esAprobado = FALSE;
    }
    return esAprobado;
}


// Da experiencia a una criatura y lo registra en la base de datos
// Esta funcion tiene en cuenta penas subraza y por multiclase (concidera clases favorecidas, incluso de las subrazas)
// Si la XP dada fuera a superar el tope, el exceso se convierte en oro.
// Soporta valores negativos de 'xpADar'.
void Experience_dar( object sujeto, int xpADar );
void Experience_dar( object sujeto, int xpADar ) {
    int nivelSujeto = GetHitDice(sujeto);
    int xpSujeto = GetXP(sujeto);
    int modificadorNivelSubraza = GetLocalInt( sujeto, RDO_modificadorNivelSubraza_PN );
    // aplicar compenzador por modificador de nivel debido a subraza
    xpADar = ( xpADar * nivelSujeto ) / ( nivelSujeto + modificadorNivelSubraza );

    // aplicar compenzador por clase favorecida
    xpADar = Races_GetFavouredClassAdjustedXP( xpADar, sujeto );

    if( xpADar > 0 ) {
        // convertir exceso de XP a oro
        int modMaxCr = MODULE_MAX_CR - modificadorNivelSubraza;
        int xpExcedida = xpSujeto + xpADar - 1000 * modMaxCr * modMaxCr / 2;
        if( xpExcedida > 0 ) {
              if( xpExcedida > xpADar ) // esto se cumple cuando el xpSujeto es mayor que el tope. Evita regalar oro a los PJs que ya estan por arriba del tope
                    xpExcedida = xpADar;
              GiveGoldToCreature( sujeto, xpExcedida*nivelSujeto/25 );
              xpADar -= xpExcedida;
        }
    }

    // registrar experiencia de forma persistente
    if( xpADar != 0 ) {
        if( xpADar > 0 ) {
            GiveXPToCreature( sujeto, xpADar );
        //    WriteTimestampedLogEntry("[XP] "+GetName(sujeto, TRUE)+" gana "+IntToString(xpADar)+" puntos de experiencia");
        }
        else {
            SetXP( sujeto, xpADar + xpSujeto );
        //    WriteTimestampedLogEntry("[XP] "+GetName(sujeto, TRUE)+" pierde "+IntToString(xpADar)+" puntos de experiencia");
        }
        SetCampaignInt( XP_DATABASE, XPVAR_XP_DATABASE, GetXP(sujeto), sujeto );
    }
}


// Debe ser llamada desde el onExit handler del área de inicio.
// Si el PJ fue marcado (ver 'Experience_pasaControlYAjuste()') por tener la XP en la DB mayor a la del PJ,
// ajusta la XP de la DB para que sea igual a la del PJ
void Experience_onGateExit( object exitingPc );
void Experience_onGateExit( object exitingPc ) {
    if( GetLocalInt( exitingPc, Experience_hayQueAjustar_VN ) ) {
        DeleteLocalInt( exitingPc, Experience_hayQueAjustar_VN );
        SetCampaignInt(XP_DATABASE, XPVAR_XP_DATABASE, GetXP(exitingPc), exitingPc );
    }
}
// Agregado por Inquisidor END

