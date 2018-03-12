/******************************************************************************
Notas sobre este evento - by dragoncin

La idea de este evento es poder modificar el volumen y el texto de los mensajes
que escriban los jugadores.
Por ende, toda funcion que se ejecute y haga cambios sobre el mensaje debe
devolver un struct ChatMessage asi se sigue modificando el mensaje
y al final llamar a SetPCChatMessage();

En consecuencia, hay que tener mucho cuidado con el orden en que se llama a
cada cosa.
******************************************************************************/

#include "Colors_inc"
#include "DMFI_Voice_inc"
//#include "Tester_inc"
#include "VolumeCtrl_inc"
#include "DMSpy_inc"

const string SILENCED_MESSAGE   = "...";
const string ASLEEP_MESSAGE     = "zzz";

// Altera el mensage en base a que efectos negativos tenga activos el personaje
// Si tiene paralisis, stun o silencio, cambia el mensaje por SILENCED_MESSAGE
// Si esta dormido cambia el mensaje por ASLEEP_MESSAGE
struct ChatMessage AlterMessageByEffects( struct ChatMessage message );

const string OUT_OF_CHARACTER_TAG = "//";

// Devuelve si el mensaje fue "off rol" o no
// La convencion es que el mensaje debe comenzar con OUT_OF_CHARACTER_TAG
int GetIsOutOfCharacter( struct ChatMessage message );

// Colorea de gris los mensajes "off rol"
struct ChatMessage ColorOOC( struct ChatMessage message );

void main()
{
    // La declaracion del struct ChatMessage se encuentra en inc_msg.nss
    struct ChatMessage message;
    message.speaker     = GetPCChatSpeaker();
    message.volume      = GetPCChatVolume();
    message.content     = GetPCChatMessage();

    //Herramientas de testeo varias (es mas comodo meter cosas aca que andar creando varitas)
    //Tester_onPlayerChat( message.content, message.speaker );

    message = AlterMessageByEffects( message );

    if ( GetIsOutOfCharacter(message) ) {
        message = ColorOOC( message );
    } else {
        //reacciona frente a emoticons pero no modifica el mensaje
        ParseEmote( message.content, message.speaker );

        // traduce el mensaje a otro idioma
        message = Idiomas_traducir( message );
    }

    // copia mensajes y los envia a los dms
    message = DMSpy_onPlayerChat( message );

    // Esto deberia llamarse siempre al final por convencion
    message = VolumeControl_execute( message );

    SetPCChatMessage( message.content );
    SetPCChatVolume( message.volume );
}

struct ChatMessage AlterMessageByEffects( struct ChatMessage message )
{
    if ( message.volume != TALKVOLUME_SILENT_SHOUT )
    {
        effect efectoIterado = GetFirstEffect( message.speaker );
        while ( GetIsEffectValid(efectoIterado) )
        {
            if ( GetEffectType(efectoIterado) == EFFECT_TYPE_PARALYZE ||
                 GetEffectType(efectoIterado) == EFFECT_TYPE_PETRIFY ||
                 GetEffectType(efectoIterado) == EFFECT_TYPE_SILENCE ||
                 GetEffectType(efectoIterado) == EFFECT_TYPE_STUNNED )
            {
                message.content = SILENCED_MESSAGE;
                break;
            } else if ( GetEffectType(efectoIterado) == EFFECT_TYPE_SLEEP )
            {
                message.content = ASLEEP_MESSAGE;
                break;
            }
            efectoIterado = GetNextEffect( message.speaker );
        }
    }
    return message;
}

int GetIsOutOfCharacter( struct ChatMessage message )
{
    return ( (GetStringLeft(message.content, 2) == "//" || GetStringRight(message.content, 2) == "//") && !GetIsDM(message.speaker) );
}

struct ChatMessage ColorOOC( struct ChatMessage message )
{
    message.content = ColorString( message.content, COLOR_GREY );
    return message;
}
