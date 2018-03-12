//::///////////////////////////////////////////////
//:: FileName sc_questBenzor 10/6/2008
//:://////////////////////////////////////////////
//:: Autor: Marduk
//:: Funcion: Checkea la variable "hayQuestBenzor"
//:: en el area que se inicio la conversacion, si
//:: el valor es 1, muestra este nodo.
//:://////////////////////////////////////////////

int StartingConditional() {
       object configurationHolder = GetArea(OBJECT_SELF);
       return GetLocalInt( configurationHolder, "hayQuestBenzor" );
}
