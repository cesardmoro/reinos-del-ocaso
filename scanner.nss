#include "rs_onenter"

void scanner( object activator )
{
    object area = GetArea( GetItemActivator() );

    object iterator = GetFirstObjectInArea(area);
    while( iterator != OBJECT_INVALID ) {
        string type = "";
        switch( GetObjectType( iterator ) ) {
//            case OBJECT_TYPE_ITEM: type = "item"; break;
//            case OBJECT_TYPE_WAYPOINT: type = "waypoint"; break;
            case OBJECT_TYPE_PLACEABLE:
                if( GetHasInventory( iterator ) )
                    type = "placeable";
                break;
            case OBJECT_TYPE_CREATURE:
                if( GetIsDead( iterator ) )
                    type = "creature";
                break;
        }
        if( type != "" ) {
            SendMessageToPC( activator, "type="+type+", hasInvetory="+IntToString(GetHasInventory(iterator) )+", ResRef="+GetResRef(iterator)+", tag="+GetTag(iterator)+", name="+GetName(iterator) );

            object oPri = GetFirstItemInInventory(iterator);
            while(oPri != OBJECT_INVALID) {
                SendMessageToPC( activator, "    dropeable="+(GetDroppableFlag(oPri)?"si":"no")+", ResRef="+GetResRef(oPri)+", tag="+GetTag(oPri)+", name="+GetName(oPri) );
                oPri = GetNextItemInInventory(iterator);
            }
        }
//        RS_destruir( iterator );
        iterator = GetNextObjectInArea( area );
    }
}
