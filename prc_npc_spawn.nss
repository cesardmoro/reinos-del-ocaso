//::///////////////////////////////////////////////
//:: OnSpawn NPC eventscript
//:: prc_npc_spawn
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_clsfunc"

void ChecksOnMaster()
{
    if(MyPRCGetRacialType(OBJECT_SELF)==RACIAL_TYPE_UNDEAD)
    {
        object oMaster = GetMaster();
        if(GetIsObjectValid(oMaster))
        {
            CorpseCrafter(oMaster, OBJECT_SELF);
        }
    }

}

void main()
{
    //this has to be delayed since
    //master is not valid onSpawn for summons
    DelayCommand(0.1, ChecksOnMaster());
    
    //check for local varaible for XP and convert to real XP
    if(GetLocalInt(OBJECT_SELF, PRC_NPC_XP))
        SetXP(OBJECT_SELF, GetLocalInt(OBJECT_SELF, PRC_NPC_XP));
}