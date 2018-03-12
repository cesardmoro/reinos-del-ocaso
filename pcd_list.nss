/************************ Persistent Containder Delegate ***********************
Author: Inquisidor
Descripcion: Delegado de un contenedor implementado con una lista doblemente enlazada.
*******************************************************************************/


const string PCD_DB_NAME_PREFIX = "PCD";
const string PCD_List_NODE_ID_SEQUENCER = "sequencer";
const string PCD_List_Node_NEXT_PREFIX = "nodeNext";
const string PCD_List_Node_PREVIOUS_PREFIX = "nodePrev";
const string PCD_List_Node_VALUE_PREFIX = "nodeValue";
const string PCD_List_FIRST_NODE = "first";
const string PCD_List_LAST_NODE = "last";

const string PCD_List_ERROR_VALUE = "";


///////////////////////// Container Delegate ///////////////////////////////////
struct PCD_List {
    string name;
    object player;
};


// Creates a delegate asociated to the list whose name is the received in parameter 'name'.
struct PCD_List PCD_List_createDelegate( string name, object player=OBJECT_INVALID );
struct PCD_List PCD_List_createDelegate( string name, object player=OBJECT_INVALID ) {
    struct PCD_List list;
    list.name = name;
    list. player = player;
    return list;
}


int PCD_List_insertNodeBetween( string dbName, object player, int previousNodeId, int nextNodeId, string value ) {
    // generate the identifier for the new node
    int newNodeId = 1 + GetCampaignInt( dbName, PCD_List_NODE_ID_SEQUENCER, player );
    SetCampaignInt( dbName, PCD_List_NODE_ID_SEQUENCER, newNodeId, player );

    if( previousNodeId == 0 ) {
        SetCampaignInt( dbName, PCD_List_FIRST_NODE, newNodeId, player );
    } else {
        SetCampaignInt( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(previousNodeId), newNodeId, player );
        SetCampaignInt( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(newNodeId), previousNodeId, player );
    }
    if( nextNodeId == 0 ) {
        SetCampaignInt( dbName, PCD_List_LAST_NODE, newNodeId, player );
    } else {
        SetCampaignInt( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(nextNodeId), newNodeId, player );
        SetCampaignInt( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(newNodeId), nextNodeId, player );
    }
    SetCampaignString( dbName, PCD_List_Node_VALUE_PREFIX + IntToString(newNodeId), value, player );
    return newNodeId;
}

struct PCD_List_Node {
    int previousNodeId;
    int nextNodeId;
};

struct PCD_List_Node PCD_List_removeNode( string dbName, object player, int nodeId ) {
    struct PCD_List_Node node;
    node.previousNodeId = GetCampaignInt( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(nodeId), player );
    node.nextNodeId = GetCampaignInt( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(nodeId), player );

    if( node.previousNodeId == 0 ) {
        SetCampaignInt( dbName, PCD_List_FIRST_NODE, node.nextNodeId, player );
    } else {
        SetCampaignInt( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(node.previousNodeId), node.nextNodeId, player );
    }

    if( node.nextNodeId == 0 ) {
        SetCampaignInt( dbName, PCD_List_LAST_NODE, node.previousNodeId, player );
    } else {
        SetCampaignInt( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(node.nextNodeId), node.previousNodeId, player );
    }

    DeleteCampaignVariable( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(nodeId), player );
    DeleteCampaignVariable( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(nodeId), player );
    DeleteCampaignVariable( dbName, PCD_List_Node_VALUE_PREFIX + IntToString(nodeId), player );

    return node;
}


// Appends an element before the first element of the list this delegate is asociated to.
void PCD_List_appendFront( struct PCD_List list, string value );
void PCD_List_appendFront( struct PCD_List list, string value ) {
    string dbName = PCD_DB_NAME_PREFIX + list.name;
    int firstNodeId = GetCampaignInt( dbName, PCD_List_FIRST_NODE, list.player );
    PCD_List_insertNodeBetween( dbName, list.player, 0, firstNodeId, value );
}


// Appends an element after the last element of the list this delegate is asociated to.
void PCD_List_appendBack( struct PCD_List list, string value );
void PCD_List_appendBack( struct PCD_List list, string value ) {
    string dbName = PCD_DB_NAME_PREFIX + list.name;
    int lastNodeId = GetCampaignInt( dbName, PCD_List_LAST_NODE, list.player );
    PCD_List_insertNodeBetween( dbName, list.player, lastNodeId, 0, value );
}


// Removes the first element of the list this delegate is asociated to.
// Gives the value of the removed element
void PCD_List_removeFront( struct PCD_List list );
void PCD_List_removeFront( struct PCD_List list ) {
    string dbName = PCD_DB_NAME_PREFIX + list.name;
    int firstNodeId = GetCampaignInt( dbName, PCD_List_FIRST_NODE, list.player );
    struct PCD_List_Node node = PCD_List_removeNode( dbName, list.player, firstNodeId );
}


// Removes the last element of the list this delegate is asociated to.
// Gives the value of the removed element
void PCD_List_removeBack( struct PCD_List list );
void PCD_List_removeBack( struct PCD_List list ) {
    string dbName = PCD_DB_NAME_PREFIX + list.name;
    int lastNodeId = GetCampaignInt( dbName, PCD_List_LAST_NODE, list.player );
    struct PCD_List_Node node = PCD_List_removeNode( dbName, list.player, lastNodeId );
}


///////////////////////////// Iterator /////////////////////////////////////////

struct PCD_ListIterator {
    string listName;
    object listPlayer;
    int currentNodeId; // node to which this iterator is pointing to
};


// Creates an iterator which starts pointing to the first element of the list this delegate is asociated to.
struct PCD_ListIterator PCD_List_createIteratorAtBegining( struct PCD_List list );
struct PCD_ListIterator PCD_List_createIteratorAtBegining( struct PCD_List list ) {
    struct PCD_ListIterator iterator;
    iterator.listName = list.name;
    iterator.listPlayer = list.player;
    iterator.currentNodeId = GetCampaignInt( PCD_DB_NAME_PREFIX + list.name, PCD_List_FIRST_NODE, list.player );
    return iterator;
}

// Creates an iterator which starts pointing to the last element of the list this delegate is asociated to.
struct PCD_ListIterator PCD_List_createIteratorAtEnd( struct PCD_List list );
struct PCD_ListIterator PCD_List_createIteratorAtEnd( struct PCD_List list ) {
    struct PCD_ListIterator iterator;
    iterator.listName = list.name;
    iterator.listPlayer = list.player;
    iterator.currentNodeId = GetCampaignInt( PCD_DB_NAME_PREFIX + list.name, PCD_List_LAST_NODE, list.player );
    return iterator;
}

// Gives true if this iterator is pointing to an element of the list this iterator is asociated to.
// Gives false if this iterator was moved after the last element, or before the first.
int PCD_ListIterator_isInRange( struct PCD_ListIterator listIterator );
int PCD_ListIterator_isInRange( struct PCD_ListIterator listIterator ) {
    return listIterator.currentNodeId != 0;
}


// Makes this iterator to point to the element that is after the element this iterator is currently pointing to.
struct PCD_ListIterator PCD_ListIterator_goForward( struct PCD_ListIterator iterator );
struct PCD_ListIterator PCD_ListIterator_goForward( struct PCD_ListIterator iterator ) {
    iterator.currentNodeId = GetCampaignInt( PCD_DB_NAME_PREFIX + iterator.listName, PCD_List_Node_NEXT_PREFIX + IntToString(iterator.currentNodeId), iterator.listPlayer );
    return iterator;
}


// Makes this iterator to point to the element that is before the element this iterator is currently pointing to.
struct PCD_ListIterator PCD_ListIterator_goBackward( struct PCD_ListIterator iterator );
struct PCD_ListIterator PCD_ListIterator_goBackward( struct PCD_ListIterator iterator ) {
    iterator.currentNodeId = GetCampaignInt( PCD_DB_NAME_PREFIX + iterator.listName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(iterator.currentNodeId), iterator.listPlayer );
    return iterator;
}


// Gets the value of the element this iterator is pointing to.
string PCD_ListIterator_getValue( struct PCD_ListIterator iterator );
string PCD_ListIterator_getValue( struct PCD_ListIterator iterator ) {
    return GetCampaignString( PCD_DB_NAME_PREFIX + iterator.listName, PCD_List_Node_VALUE_PREFIX + IntToString(iterator.currentNodeId), iterator.listPlayer );
}

// Changes the value of the element this iterator is pointing to.
void PCD_ListIterator_setValue( struct PCD_ListIterator iterator, string value );
void PCD_ListIterator_setValue( struct PCD_ListIterator iterator, string value ) {
    SetCampaignString( PCD_DB_NAME_PREFIX + iterator.listName, PCD_List_Node_VALUE_PREFIX + IntToString(iterator.currentNodeId), value, iterator.listPlayer );
}

// Inserts an element between the element this iterator is pointing to, and the next element.
// After this operation, this iterator will point to the inserted element.
struct PCD_ListIterator PCD_ListIterator_insertAfterCurrent( struct PCD_ListIterator iterator, string value );
struct PCD_ListIterator PCD_ListIterator_insertAfterCurrent( struct PCD_ListIterator iterator, string value ) {
    string dbName = PCD_DB_NAME_PREFIX + iterator.listName;
    int nextNodeId = GetCampaignInt( dbName, PCD_List_Node_NEXT_PREFIX + IntToString(iterator.currentNodeId), iterator.listPlayer );
    iterator.currentNodeId = PCD_List_insertNodeBetween( dbName, iterator.listPlayer, iterator.currentNodeId, nextNodeId, value );
    return iterator;
}


// Inserts an element between the element this iterator is pointing to, and the previous element.
// After this operation, this iterator will point to the inserted element.
struct PCD_ListIterator PCD_ListIterator_insertBeforeCurrent( struct PCD_ListIterator iterator, string value );
struct PCD_ListIterator PCD_ListIterator_insertBeforeCurrent( struct PCD_ListIterator iterator, string value ) {
    string dbName = PCD_DB_NAME_PREFIX + iterator.listName;
    int previousNodeId = GetCampaignInt( dbName, PCD_List_Node_PREVIOUS_PREFIX + IntToString(iterator.currentNodeId), iterator.listPlayer );
    iterator.currentNodeId = PCD_List_insertNodeBetween( dbName, iterator.listPlayer, previousNodeId, iterator.currentNodeId, value );
    return iterator;
}


// Removes the element this iterator is pointing to, and makes this iterator to point to the element that was after the removed element.
struct PCD_ListIterator PCD_ListIterator_removeCurrentAndGoForward( struct PCD_ListIterator iterator );
struct PCD_ListIterator PCD_ListIterator_removeCurrentAndGoForward( struct PCD_ListIterator iterator ) {
    string dbName = PCD_DB_NAME_PREFIX + iterator.listName;
    struct PCD_List_Node node = PCD_List_removeNode( dbName, iterator.listPlayer, iterator.currentNodeId );
    iterator.currentNodeId = node.nextNodeId;
    return iterator;
}


// Removes the element this iterator is pointing to, and makes this iterator to point to the element that was before the removed element.
struct PCD_ListIterator PCD_ListIterator_removeCurrentAndGoBackward( struct PCD_ListIterator iterator );
struct PCD_ListIterator PCD_ListIterator_removeCurrentAndGoBackward( struct PCD_ListIterator iterator ) {
    string dbName = PCD_DB_NAME_PREFIX + iterator.listName;
    struct PCD_List_Node node = PCD_List_removeNode( dbName, iterator.listPlayer, iterator.currentNodeId );
    iterator.currentNodeId = node.previousNodeId;
    return iterator;
}


/////////////////////// Usefull operations /////////////////////////////////////

string PCD_List_getAt( struct PCD_List list, int index );
string PCD_List_getAt( struct PCD_List list, int index ) {
    struct PCD_ListIterator iterator = PCD_List_createIteratorAtBegining( list );
    while( --index >= 0 && iterator.currentNodeId != 0 ) {
        iterator = PCD_ListIterator_goForward( iterator );
    }
    // if 'index' is outside bounds
    if( iterator.currentNodeId == 0 )
        return PCD_List_ERROR_VALUE;
    // if 'index' is inside bounds
    else
        return PCD_ListIterator_getValue( iterator );
}


void PCD_List_insertAfter( struct PCD_List list, string value, int index );
void PCD_List_insertAfter( struct PCD_List list, string value, int index ) {
    struct PCD_ListIterator iterator = PCD_List_createIteratorAtBegining( list );
    while( --index >= 0 && iterator.currentNodeId != 0 ) {
        iterator = PCD_ListIterator_goForward( iterator );
    }
    // if 'index' is inside bounds
    if( iterator.currentNodeId != 0 )
        PCD_ListIterator_insertAfterCurrent( iterator, value );
}


void PCD_List_removeAt( struct PCD_List list, int index );
void PCD_List_removeAt( struct PCD_List list, int index ) {
    struct PCD_ListIterator iterator = PCD_List_createIteratorAtBegining( list );
    while( --index >= 0 && iterator.currentNodeId != 0 ) {
        iterator = PCD_ListIterator_goForward( iterator );
    }
    // if 'index' is inside bounds
    if( iterator.currentNodeId != 0 )
        PCD_ListIterator_removeCurrentAndGoForward( iterator );
}

