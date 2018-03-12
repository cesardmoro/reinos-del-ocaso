////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////

#include "Party_generic"  // line inserted by Inquisidor

void main() {
    object oClicker = GetClickingObject();
    object oTarget = GetTransitionTarget(OBJECT_SELF);

    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    AssignCommand(oClicker,JumpToObject(oTarget));

    // Inserted by Inquisidor - BEGIN
    // Send every associate to 'oTarget' in order to avoid they behave dumy trying to find the master while he is loading the destination area.
    Party_jumpAllAssociatesToObject( oClicker, oTarget );
    // Inserted by Inquisidor - END
}
