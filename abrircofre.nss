#include "RTG_inc"

void main()
{
    if(GetLocalInt(OBJECT_SELF, "usado") == 0)
    {
        if(d20(1) == 1)
        {
            object oMimeto = CreateObject(OBJECT_TYPE_CREATURE, "mimeto001", GetLocation(OBJECT_SELF), FALSE);
            AssignCommand(oMimeto, ActionAttack(GetLastOpenedBy()));
            object oPri = GetFirstItemInInventory();
            while(oPri != OBJECT_INVALID)
            {
                DestroyObject(oPri, 0.0);
                oPri = GetNextItemInInventory();
            }
            DestroyObject(OBJECT_SELF, 0.0);
        }
        else {

            //  SetIsDestroyable(FALSE, TRUE, TRUE);
            RTG_determineLoot( OBJECT_SELF, Random_generateLevel( GetLocalInt(GetArea(OBJECT_SELF), "Cr") ), 1.0, OBJECT_INVALID, 100.0 );
            SetLocalInt(OBJECT_SELF, "usado", 1);
        }
    }
}
