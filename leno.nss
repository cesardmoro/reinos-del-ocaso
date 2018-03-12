//#include "x2_inc_switches"

void main()
{


        object oItem = GetItemActivated();
        object oTarget = GetItemActivatedTarget();
        object oPC = GetItemActivator();
        if(GetDistanceBetweenLocations(GetLocation(oPC), GetItemActivatedTargetLocation()) > 5.0)
    {
    SendMessageToPC(oPC, "Estas muy lejos de ese lugar");
    return;
    }
    if(!((GetIsAreaInterior(GetArea(oPC)) == FALSE) && (GetIsAreaAboveGround(GetArea(oPC)) == TRUE) && (GetIsAreaNatural(GetArea(oPC)) == TRUE)))
{
SendMessageToPC(oPC, "Solo puedes usar este objeto en areas exteriores sobre la tierra y no artificiales");
return;
}
if (GetItemActivatedTarget()!=OBJECT_INVALID) {
        SendMessageToPC(oPC, "Este objeto debe ser usado sobre el piso");
        return;
    }
        if (GetResRef(oTarget) == "fogon" )
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(30), oTarget);
            FloatingTextStringOnCreature("*alimenta el fuego con mas maderas*", oPC);
            DestroyObject(oItem, 0.1);
        } else {
            location lTarget = GetItemActivatedTargetLocation();
            object oLeno = CreateObject(OBJECT_TYPE_PLACEABLE, "fogon", lTarget, TRUE);
            DestroyObject(oItem, 0.1);
        }


}
