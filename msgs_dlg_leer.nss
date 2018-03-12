#include "mensajeria_inc"

void main()
{
    object lector = GetPCSpeaker();

    AssignCommand( lector, ActionSpeakString( "*lee una carta*" ) );
    AssignCommand( lector, ActionPlayAnimation(ANIMATION_FIREFORGET_READ) );
}
