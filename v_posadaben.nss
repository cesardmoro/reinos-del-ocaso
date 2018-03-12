void main()
{
// If no one is about - Exit to save CPU!
if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
int nUser = GetUserDefinedEventNumber();
object oCustomer = GetLocalObject(OBJECT_SELF, "CUSTOMER");

int nRandom = Random(8);    // Set this to the approx number of NPC's in the room
object oBar = GetWaypointByTag("WP_MASTIN1");   // Place this waypoint where she gets drinks from
object oRest = GetWaypointByTag("WP_MASTIN2"); // Place this waypoint where she returns to rest
object oCook = GetObjectByTag("MASTINCL1");      // Place an NPC Cook in the kitchen with this tag
object oBartend = GetObjectByTag("MASTINCL2");// Place an NPC Bartender at bar with this tag
if (nUser == 1001) // OnHeartbeat event
    {
    if (!GetIsObjectValid(oCustomer) && GetLocalInt(OBJECT_SELF, "BARMAID_STATE") < 1)
        { //Valid customer and state
        oCustomer = GetNearestCreature (CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, nRandom);
        if (oCustomer != oCook && oCustomer != oBartend && oCustomer != OBJECT_SELF && GetIsObjectValid(oCustomer))
            { //Customer is not cook, bartend or self & is valid
            SetLocalInt (OBJECT_SELF, "BARMAID_STATE", 1);
            SetLocalObject (OBJECT_SELF, "CUSTOMER", oCustomer);
            ActionMoveToObject(oCustomer);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Esta usted bien?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_YES,oCustomer)); break;
                case 1: ActionSpeakString ("Necesita algo"); break;
                case 2: ActionSpeakString ("Seria bueno recibir alguna noticia de las ciudades del norte"); break;
                case 3: ActionSpeakString ("Deberias visitar a tus parientes en Trondor");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_GOODIDEA,oCustomer)); break;
                }
            ActionWait(5.0); //Wait, then order drinks from bar
            ActionDoCommand (SetLocalInt(OBJECT_SELF, "BARMAID_STATE", 2));
            ActionMoveToObject(oBar);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Hay novedades?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CANDO,oCook)); break;
                case 1: ActionSpeakString ("Pudo enviar esa mercaderia a los puertos?"); break;
                case 2: ActionSpeakString ("Veo que no consiguio viajar finalmente");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CANTDO,oCook)); break;
                case 3: ActionSpeakString ("Consiguieron encontrar aquel objeto que buscaban?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE,oCook)); break;
                }
            ActionWait(8.0); //Wait, then deliver the drinks
            ActionDoCommand (SetLocalInt(OBJECT_SELF, "BARMAID_STATE", 3));
            ActionMoveToObject(oCustomer);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Se entero de lo que le ocurrio al ultimo que intento bajar a las cloacas?"); break;
                case 1: ActionSpeakString ("Dicen que en el Perro Salado hay una nueva camarera");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oCustomer)); break;
                case 2: ActionSpeakString ("Espero que les aproveche su estancia"); break;
                case 3: ActionSpeakString ("Tome esto, un obsequio de la casa");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_THANKS,oCustomer)); break;
                }
            ActionWait(3.0); // Wait, then back to bar to take a break
            ActionDoCommand (SetLocalObject(OBJECT_SELF, "CUSTOMER", OBJECT_INVALID));
            ActionMoveToObject(oRest);
            //Enter the direction for her to face while on break or comment line below out!
            //DelayCommand(4.0,AssignCommand(OBJECT_SELF,SetFacing(DIRECTION_SOUTH)));
            ActionWait(5.0);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Que noche agitada");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_YES,oBartend)); break;
                case 1: ActionSpeakString ("Esta vieja rodilla mia es todo un tema estos dias humedos"); break;
                case 2: ActionSpeakString ("Deberian ver la pareja que subio a la habitacion 4"); break;
                case 3: ActionSpeakString ("El viejo Boilin pinto su casa de verde con el ultimo grupo de orco que se acerco a su propiedad");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oBartend)); break;
                }
            ActionWait(5.0);//Wait then reset our variable for next go around
            ActionDoCommand (SetLocalInt(OBJECT_SELF, "BARMAID_STATE", 0));
            }
        }
    }
if (nUser == 1004) // OnDialogue event so you can talk to them.
    {
    SetLocalObject (OBJECT_SELF, "CUSTOMER", OBJECT_INVALID);
    SetLocalInt (OBJECT_SELF, "BARMAID_STATE", 0);
    }
}

