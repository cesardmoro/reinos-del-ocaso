 // Zero, esto es BASURA!!!!!! No podes ser tan trucho!!!!!!!
#include "areainclude"
void borrado2()
{

    if(GetLocalInt(GetArea(OBJECT_SELF), "numero") == 0)
    {
        object oTriger = GetFirstObjectInArea(OBJECT_SELF);

        while(oTriger != OBJECT_INVALID)
        {
            DelayCommand(90.0, deactivar(oTriger)); // Zero, esto es BASURA!!!!!! No podes ser tan trucho!!!!!!!
            oTriger = GetNextObjectInArea(OBJECT_SELF);
        }
    }

}

void main()
{
    if(GetLocalInt(GetArea(OBJECT_SELF), "numero") == 0)
    {
        object oTriger = GetFirstObjectInArea(OBJECT_SELF);

        while(oTriger != OBJECT_INVALID)
        {
            AssignCommand(oTriger, SetIsDestroyable(TRUE,TRUE,TRUE));
            DelayCommand(90.0, deactivar(oTriger)); // Zero, esto es BASURA!!!!!! No podes ser tan trucho!!!!!!!
            oTriger = GetNextObjectInArea(OBJECT_SELF);
        }
    }
    //DelayCommand(3.0, borrado2());
}
