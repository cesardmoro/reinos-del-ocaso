#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    //30feet is the default speed 
    //rather than try to fudge around biowares differences
    //Ill just scale relative to that
    int nCurrentSpeed = 30;
    int nNewSpeed = nCurrentSpeed;
    //test for racial movement changes
    if(GetPRCSwitch(PRC_PNP_RACIAL_SPEED))
    {
        nNewSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));
        //some races dont have a speed listed
        if(!nNewSpeed)
            nNewSpeed = nCurrentSpeed;
    }    
    //test for armor movement changes    
    if(GetPRCSwitch(PRC_PNP_ARMOR_SPEED))
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        //in an onunequip event the armor is still in the slot
        if(GetLocalInt(oPC,"ONEQUIP")==1)
            oArmor = OBJECT_INVALID;
        int nArmorType = GetArmorType(oArmor);
        if(nArmorType == ARMOR_TYPE_MEDIUM)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.75);
        else if(nArmorType == ARMOR_TYPE_HEAVY)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.666);
    }    
    //scale by PC speed
    if(GetPRCSwitch(PRC_REMOVE_PLAYER_SPEED) 
        && (GetIsPC(oPC)
            || GetMovementRate(oPC) == 0))
    {
        //PCs move at 4.0 NPC "normal" is 3.5
        nCurrentSpeed = FloatToInt(IntToFloat(nCurrentSpeed)*(4.0/3.5));
    }  
    //no change, abort
    if(nNewSpeed == nCurrentSpeed)
        return;
    //only apply it in a valid area
    if(!GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        return;
    //get relative change    
    float fSpeedChange = IntToFloat(nNewSpeed)/IntToFloat(nCurrentSpeed);
    if(DEBUG) DoDebug("prc_speed NewSpeed = "+IntToString(nNewSpeed)+" OldSpeed = "+IntToString(nCurrentSpeed)+" SpeedChange = "+FloatToString(fSpeedChange));  
    if(DEBUG) DoDebug("GetMovementRate() = "+IntToString(GetMovementRate(oPC)));
    //get the object thats going to apply the effect
    //this strips previous effects too
    object oWP = GetObjectToApplyNewEffect("WP_SpeedEffect", oPC, TRUE);
    //its an increase
    if(fSpeedChange > 1.0)
    {
        int nChange = FloatToInt((fSpeedChange-1.0)*100.0);
        if(nChange < 0)
            nChange = 0;
        else if(nChange > 199)
            nChange = 199;
DoDebug("Applying an increase in speed "+IntToString(nChange));
        AssignCommand(oWP, 
            ActionDoCommand(
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(
                        EffectMovementSpeedIncrease(nChange)),
                    oPC)));  
    }
    else if(fSpeedChange < 1.0)
    {
        int nChange = FloatToInt((1.0-fSpeedChange)*100.0);
        if(nChange < 0)
            nChange = 0;
        else if(nChange > 99)
            nChange = 99;
DoDebug("Applying an decrease in speed "+IntToString(nChange));
        AssignCommand(oWP, 
            ActionDoCommand(
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(
                        EffectMovementSpeedDecrease(nChange)),
                    oPC)));  
    }
}