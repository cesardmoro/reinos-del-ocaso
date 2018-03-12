/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

void main() {
    object user = GetPCSpeaker();
    object targetObject = GetLocalObject( user, RCW_targetObject_VN );

    if( GetObjectType( targetObject) == OBJECT_TYPE_CREATURE ){
        object userArea = GetArea( user );
        int numberOfMembers;
        object leader = GetFactionLeader( targetObject );
        object memberIterator = GetFirstFactionMember( leader, FALSE );
        while( memberIterator != OBJECT_INVALID ) {
            if( GetArea(memberIterator) == userArea ) {
                string message;
                switch( GetAssociateType( memberIterator ) ) {
                    case ASSOCIATE_TYPE_ANIMALCOMPANION:    message = "animal companion of "+GetName(GetMaster(memberIterator)); break;
                    case ASSOCIATE_TYPE_DOMINATED:          message = "dominated by "+GetName(GetMaster(memberIterator)); break;
                    case ASSOCIATE_TYPE_FAMILIAR:           message = "familiar of "+GetName(GetMaster(memberIterator)); break;
                    case ASSOCIATE_TYPE_HENCHMAN:           message = "henchmen of "+GetName(GetMaster(memberIterator)); break;
                    case ASSOCIATE_TYPE_SUMMONED:           message = "summon of "+GetName(GetMaster(memberIterator)); break;
                    case ASSOCIATE_TYPE_NONE:
                        if( memberIterator == leader )      message = "party leader";
                        else                                message = "follower";
                        break;
                }
                AssignCommand( memberIterator, SpeakString( message ) );
            }
            memberIterator = GetNextFactionMember( leader, FALSE );
            numberOfMembers += 1;
        }
        SendMessageToPC( user, "The target's party has "+IntToString(numberOfMembers)+" members."  );
    }
    else
        SendMessageToPC( user, "Failure! The target must be a creature." );
}
