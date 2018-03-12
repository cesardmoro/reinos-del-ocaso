const int DEBUG = TRUE;

void main()
{
    object oClicker = GetClickingObject();
    object oTransition = GetWaypointByTag("WP_"+GetTag(OBJECT_SELF));
    object oTarget = GetTransitionTarget(OBJECT_SELF);

    vector vClicker = GetPosition(oClicker);
    vector vTransition = GetPosition(oTransition);
    vector vTarget = GetPosition(oTarget);

    vector vEnd = vTarget + vClicker - vTransition;
//        vEnd.x = fabs( vTarget.x + vClicker.x - vTransition.x );
//        vEnd.y = fabs( vTarget.y + vClicker.y - vTransition.y );
//        vEnd.z = vTarget.z;

    location lTarget = Location(GetArea(oTarget), vEnd, GetFacing(oClicker));

    AssignCommand(oClicker, ActionJumpToLocation(lTarget));
}
