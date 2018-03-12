/******************************
Sistema de creacion de cartas
by Dragoncin & Varda
27/04/2008

******************************/

#include "dmfi_voice_inc"

///////////////////// CONSTANTES ///////////////////////
const int Mensajeria_DEBUG                  = TRUE;

const string Mensajeria_papel_RN            = "msgs_papel";
const string Mensajeria_sobre_RN            = "msgs_sobre";
const string Mensajeria_carta_RN            = "msgs_carta";
const string Mensajeria_pluma_RN            = "msgs_pluma";
const string Mensajeria_tinta_RN            = "msgs_tinta";
const string Mensajeria_listener_RN         = "mensajeria_place";

const string Mensajeria_mensaje_VN          = "msgs_mensaje";
const string Mensajeria_idioma_VN           = "msgs_idioma";

const string Mensajeria_idiomaElegido_VN    = "msgs_sellang";
const string Mensajeria_remitenteElegido_VN = "msgs_selfrom";
const string Mensajeria_destinataElegido_VN = "msgs_selto";
const string Mensajeria_mensajeElegido_VN   = "msgs_selmsg";
const string Mensajeria_papelElegido_VN     = "msgs_selpap";

/////////////////////// FUNCIONES ///////////////////////

int personajeSabeEscribir( object oPC );
int personajeSabeEscribir( object oPC )
{
    if (Mensajeria_DEBUG) return TRUE;

    int puntosEnLore = GetSkillRank( SKILL_LORE_ARCANA, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_ARCHITECTURE, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_DUNGEONEERING, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_GEOGRAPHY, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_HISTORY, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_LOCAL, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_NATURE, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_NOBILITY, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_RELIGION, oPC, TRUE );
    puntosEnLore += GetSkillRank( SKILL_LORE_PLANES, oPC, TRUE );

    return ( puntosEnLore >= 2 ||
             (GetClassByPosition( 1, oPC ) == CLASS_TYPE_BARBARIAN &&
              GetClassByPosition( 2, oPC ) == CLASS_TYPE_INVALID)
            );
}

// Escribe una carta creando un item "sobre" con el nombre
// "Carta de nombreRemitente para nombreDestinatario"
// y guarda el mensaje y el idioma de la misma
object EscribirCarta( object papel, object pjEscriba, string nombreDestinatario, string nombreRemitente, string mensaje, int idioma = IDIOMA_COMUN );
object EscribirCarta( object papel, object pjEscriba, string nombreDestinatario, string nombreRemitente, string mensaje, int idioma = IDIOMA_COMUN )
{
    // Creamos un nuevo sobre
    object sobre = CreateItemOnObject( Mensajeria_sobre_RN, pjEscriba );

    // Definimos el nombre que tendra el item en base al destinatario y el remitente
    // Si alguno esta vacio, no lo agregamos
    // La idea es que quede "Carta de Pepito para Mengano"
    string titulo = "Carta ";
    if ( GetStringLength(nombreRemitente) > 0 )
        {
        titulo += "de "+nombreRemitente;
        }
    if ( GetStringLength(nombreDestinatario) > 0 )
        {
        titulo += " para "+nombreDestinatario;
        }
    SetName( sobre, titulo );
    // Guardamos el mensaje y el idioma
    SetLocalString( sobre, Mensajeria_mensaje_VN, mensaje );
    SetLocalInt( sobre, Mensajeria_idioma_VN, idioma );

    // Borramos el papel
    DestroyObject( papel );

    // Devolvemos el sobre por utilidad en el resto del script
    return sobre;
}

// Abre un sobre lacrado
// Esto es util On Rol ya que permite saber si una carta fue leida o no
object AbrirSobre( object sobre, object lector );
object AbrirSobre( object sobre, object lector )
{
    // Obtenemos la informacion del sobre
    string titulo = GetName( sobre );
    int idioma = GetLocalInt( sobre, Mensajeria_idioma_VN );
    string mensaje = GetLocalString( sobre, Mensajeria_mensaje_VN );

    // Creamos la carta y le ponemos el nombre correcto
    object carta = CreateItemOnObject( Mensajeria_carta_RN, lector );
    SetName( carta, titulo );
    // Guardamos el mensaje y el idioma
    SetLocalString( carta, Mensajeria_mensaje_VN, mensaje );
    SetLocalInt( carta, Mensajeria_idioma_VN, idioma );

    // Borramos el sobre
    DestroyObject( sobre );

    // Devolvemos la carta por utilidad en el resto del script
    return carta;
}

const string Mensajeria_dialogoDinamico_mensaje_VN  = "msgs_leercart";
const string Mensajeria_dialogoDinamico_RN          = "msgs_dyndlg";

//
void LeerCarta( object carta, object lector );
void LeerCarta( object carta, object lector )
{
    // Obtenemos el idioma y nos fijamos si el lector lo conoce
    int idioma = GetLocalInt( carta, Mensajeria_idioma_VN );
    if (Idiomas_pjSabeIdioma( lector, idioma ))
    {
        // Obtenemos el mensaje de la carta
        string mensaje = GetLocalString( carta, Mensajeria_mensaje_VN );
		SetCustomToken( 31416, mensaje );
        AssignCommand( lector, ActionStartConversation( lector, Mensajeria_dialogoDinamico_RN, TRUE, FALSE ) );
    }
    else
    {
        // Si el lector no conoce el idioma, se lo decimos
        SendMessageToPC( lector, "No conoces el idioma en el que esta escrita la carta" );
    }
}

const string Mensajeria_dialogoPapel_RN     = "msgs_dlgpapel";

// Abre un dialogo para escribir una carta
void Mensajeria_activarPapelVacio( object papel, object escriba );
void Mensajeria_activarPapelVacio( object papel, object escriba )
{
    if ( personajeSabeEscribir( escriba ) )
    {
        if ( GetIsObjectValid( GetItemPossessedBy(escriba, Mensajeria_pluma_RN) ) )
        {
            if ( GetIsObjectValid( GetItemPossessedBy(escriba, Mensajeria_tinta_RN) ) )
            {
                SetLocalObject( escriba, Mensajeria_papelElegido_VN, papel );
                object carta_listener = CreateObject( OBJECT_TYPE_PLACEABLE, Mensajeria_listener_RN, GetLocation(escriba) );
                SetListening( carta_listener, TRUE );
                SetListenPattern(carta_listener, "**", 939);
                if (Mensajeria_DEBUG) SendMessageToPC( GetFirstPC(), "start listening" );
                // Abrimos un dialogo parecido al del orfebre
                AssignCommand( escriba, ActionStartConversation( carta_listener, Mensajeria_dialogoPapel_RN, TRUE, FALSE ) );
            }
            else
            {
                SendMessageToPC( escriba, "Necesitas tinta para escribir una carta" );
            }
        }
        else
        {
            SendMessageToPC( escriba, "Necesitas una pluma para escribir una carta" );
        }
    }
    else
    {
        SendMessageToPC( escriba, "//Tu personaje no sabe escribir. Debes inventir al menos 2 puntos en conocimientos." );
    }
}

// Abre un sobre lacrado
void Mensajeria_activarSobre( object sobre, object lector );
void Mensajeria_activarSobre( object sobre, object lector )
{
    AbrirSobre( sobre, lector );
}

// Lee una carta
void Mensajeria_activarCarta( object carta, object lector );
void Mensajeria_activarCarta( object carta, object lector )
{
    LeerCarta( carta, lector );
}


