/*********************** Party - generic tools *********************************
Package: Party - generic tools - include
Author: Inquisidor
*******************************************************************************/

// Da la cantidad de PJs en el party del que el PJ 'pjMiembroParty' es miembro,
// y que esten en el mismo area.
// Nota: pjMiembroParty debe ser un PJ.
int Party_getCantPjsMismaArea( object pjMiembro );
int Party_getCantPjsMismaArea( object pjMiembro ) {
    int cantPjsEnParty = 0;
    object pjMiembroIterator = GetFirstFactionMember( pjMiembro, TRUE );
    while( pjMiembroIterator != OBJECT_INVALID ) {
        if( GetArea(pjMiembroIterator) == GetArea( pjMiembro ) )
            cantPjsEnParty += 1;
        pjMiembroIterator = GetNextFactionMember( pjMiembro, TRUE );
    }
    return cantPjsEnParty;
}


// Aplies the 'JumpToObject(destination)' action to every associate of the received 'pc'.
// if 'pc' is not a PC, nothing happends.
// Notice that the choice of JumpToObject instead of JumpToLocation was necesary because JumpToObject does implicit extra work when the destination is a door.
void Party_jumpAllAssociatesToObject( object pc, object destination );
void Party_jumpAllAssociatesToObject( object pc, object destination ) {
    if( !GetIsPC(pc) )
        return;

    object member = GetFirstFactionMember( pc, FALSE );
    while( member != OBJECT_INVALID ) {
//        SendMessageToPC( GetFirstPC(), "Party_jumpAllAssociatesToObject: member="+GetName(member) );
        if( GetMaster( member ) == pc )
            AssignCommand( member, JumpToObject(destination) );

        member = GetNextFactionMember( pc, FALSE);
    }
}


