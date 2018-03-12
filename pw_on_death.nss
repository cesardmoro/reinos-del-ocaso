#include "NW_I0_GENERIC"

void main()
{
    //I'm dead, find all the pc's in my stomach and let them out.
    //If I died underground then surface first.

    location lTo = GetLocation(OBJECT_SELF);
    object oPWI = GetObjectByTag("InsidePurpleWorm");
    if(GetAreaFromLocation(lTo)==GetObjectByTag("PWUnderground"))
    {
        lTo = GetLocalLocation(OBJECT_SELF,"PW_FROM");
        ClearAllActions();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectDisappearAppear(lTo),OBJECT_SELF,0.0);
    }

    object oPC = GetFirstObjectInArea(oPWI);
    while(GetIsObjectValid(oPC))
    {
        if(GetLocalObject(oPC,"PW_FROM")==OBJECT_SELF)
        {
            SendMessageToPC(oPC,"The worms muscles suddenly relax..");
            AssignCommand(oPC,ClearAllActions());
            AssignCommand(oPC,JumpToLocation(lTo));
        }
        oPC = GetNextObjectInArea(oPWI);
    }
    SetIsDestroyable(FALSE,FALSE,FALSE);
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);
    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
}
