//:://////////////////////////////////////////////
//:: Get Class & Level by Position include
//:: inc_class_by_pos
//:://////////////////////////////////////////////
/** @file
    Replacements for GetClassByPosition and
    GetLevelByPosition, which do not work with
    custom classes.


    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////
// Function Prototypes      //
//////////////////////////////

/**
 * Sets up the local variables used by PRCGetClassByPosition
 * and PRCGetLevelByPosition. This is automatically run by
 * them if setup has not been done yet.
 *
 * @param oCreature  The creature to do setup for
 */
void SetupPRCGetClassByPosition(object oCreature);


/**
 * A creature can have up to three classes. This function determines the
 * creature's class (CLASS_TYPE_*) based on nClassPosition.
 *
 * @param nClassPosition  1, 2 or 3
 * @param oCreature       Creature whose class to find out
 * @return                CLASS_TYPE_INVALID if the oCreature does not have a class in
 *                        nClassPosition (i.e. a single-class creature will only have a value in
 *                        nClassLocation = 1) or if oCreature is not a valid creature.
 */
int PRCGetClassByPosition(int nClassPosition, object oCreature = OBJECT_SELF);


/**
 * A creature can have up to three classes.  This function determines the
 * creature's class level based on nClass Position.
 *
 * @param nClassPosition  1, 2 or 3
 * @param oCreature       Creature whose class level to find out
 * @return                0 if oCreature does not have a class in nClassPosition
 *                        (i.e. a single-class creature will only have a value in
 *                        nClassLocation = 1) or if oCreature is not a valid creature.
 */
int PRCGetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF);


//////////////////////////////
// Function Definitions     //
//////////////////////////////

void SetupPRCGetClassByPosition(object oCreature)
{
    int i;
    int nCounter = 1;
    //set to defaults, including the +1 for 1start not 0 start
    SetLocalInt(oCreature, "PRC_ClassInPos1", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos2", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassInPos3", CLASS_TYPE_INVALID+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos1", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos2", 0+1);
    SetLocalInt(oCreature, "PRC_ClassLevelInPos3", 0+1);
    for(i = 0; i < 256; i++)
    {
        if(GetLevelByClass(i, oCreature))
        {
            // set to values, including the +1 for 1start not 0 start
            SetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nCounter), i+1);
            SetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nCounter),
                GetLevelByClass(i, oCreature)+1);
            nCounter++;
            if(nCounter >= 4)
                break; // end loop now
        }
    }
}

int PRCGetClassByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return CLASS_TYPE_INVALID;
    int nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}

int PRCGetLevelByPosition(int nClassPosition, object oCreature=OBJECT_SELF)
{
    if(!GetIsObjectValid(oCreature) || GetObjectType(oCreature) != OBJECT_TYPE_CREATURE)
        return 0;
    int nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    if(nClass == 0)
    {
        SetupPRCGetClassByPosition(oCreature);
        nClass = GetLocalInt(oCreature, "PRC_ClassLevelInPos"+IntToString(nClassPosition));
    }
    //correct for 1 start not 0 start
    nClass--;
    return nClass;
}

// Test main
//void main(){}
