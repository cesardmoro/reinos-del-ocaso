void main()
{
// If no one is about - Exit to save CPU!
if (GetAILevel() == AI_LEVEL_VERY_LOW) return;
int nUser = GetUserDefinedEventNumber();
object oCustomer = GetLocalObject(OBJECT_SELF, "CUSTOMER");

int nRandom = Random(8);    // Set this to the approx number of NPC's in the room
object oBar = GetWaypointByTag("WP_BAR_BEN");   // Place this waypoint where she gets drinks from
object oRest = GetWaypointByTag("WP_REST_BEN"); // Place this waypoint where she returns to rest
object oCook = GetObjectByTag("COOK_BEN");      // Place an NPC Cook in the kitchen with this tag
object oBartend = GetObjectByTag("BARTEND_BEN");// Place an NPC Bartender at bar with this tag
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
                case 0: ActionSpeakString ("Puedo traerte algo?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_YES,oCustomer)); break;
                case 1: ActionSpeakString ("Que quieres?"); break;
                case 2: ActionSpeakString ("Como te esta llendo?"); break;
                case 3: ActionSpeakString ("Otra vuelta?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_GOODIDEA,oCustomer)); break;
                }
            ActionWait(5.0); //Wait, then order drinks from bar
            ActionDoCommand (SetLocalInt(OBJECT_SELF, "BARMAID_STATE", 2));
            ActionMoveToObject(oBar);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Dos cervezas y una buena botella de licor");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CANDO,oCook)); break;
                case 1: ActionSpeakString ("Tu mejor licor"); break;
                case 2: ActionSpeakString ("Quieren una buena pinta de cerveza y algo de pan");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_CANTDO,oCook)); break;
                case 3: ActionSpeakString ("Una botella de vino y dos vasos, por favor");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE,oCook)); break;
                }
            ActionWait(8.0); //Wait, then deliver the drinks
            ActionDoCommand (SetLocalInt(OBJECT_SELF, "BARMAID_STATE", 3));
            ActionMoveToObject(oCustomer);
            switch(Random(4))
                {
                case 0: ActionSpeakString ("Disfruta esto amigo"); break;
                case 1: ActionSpeakString ("100 monedas... *se rie suave* era un chiste, solo 5 monedas para ti");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_LAUGH,oCustomer)); break;
                case 2: ActionSpeakString ("Veo que te va bien con eso eh!"); break;
                case 3: ActionSpeakString ("Una buena cosecha... que lo disfruten");
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
                case 0: ActionSpeakString ("Una noche tranquila hoy, no?");
                        ActionDoCommand(PlayVoiceChat(VOICE_CHAT_YES,oBartend)); break;
                case 1: ActionSpeakString ("Los pies me estan matando."); break;
                case 2: ActionSpeakString ("Hey! Estos tipos dan buenas propinas!"); break;
                case 3: ActionSpeakString ("Wow! mira ese tipo");
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

