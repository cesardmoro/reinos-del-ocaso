//::///////////////////////////////////////////////
//:: Name           PRC Respawning Door User Defined event
//:: FileName       door_ud
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This handles re-creating the door after it has been destroyed
    
    To trigger it, send a user defined event no 500 to the door
    
    This will not lock or trap the door again
*/
//:://////////////////////////////////////////////
//:: Created By:    Primogenitor
//:: Created On:    08/05/06
//:://////////////////////////////////////////////


void main()
{
    int nEventID = GetUserDefinedEventNumber();
    switch(nEventID)
    {
        //respawn
        case 500:
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectHeal(GetMaxHitPoints(OBJECT_SELF)-GetCurrentHitPoints(OBJECT_SELF)),
                OBJECT_SELF);
            PlayAnimation(ANIMATION_DOOR_CLOSE);
        }
        break;
    }
}
