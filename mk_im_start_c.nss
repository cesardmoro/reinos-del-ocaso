#include "x2_inc_craft"
#include "mk_inc_craft"
#include "IPS_inc"
#include "CIB_frente"

void main()
{
    StoreCameraFacing();

    object oPC = GetPCSpeaker();

    CIB_onClientLeave( oPC );

    // * Make the camera float near the PC
    float fFacing  = GetFacing(oPC) + 315.0;
    if (fFacing > 359.0)
    {
        fFacing -=359.0;
    }
    SetCameraFacing(fFacing, 3.5f, 75.0,CAMERA_TRANSITION_TYPE_FAST ) ;

    CISetCurrentModMode(GetPCSpeaker(),MK_CI_MODMODE_CLOAK );

    object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    object oBackup = CopyItem(oItem,IPGetIPWorkContainer(),TRUE);
    CISetCurrentModBackup(oPC, oBackup);
    CISetCurrentModItem(oPC, oItem);

    if (IPS_Item_getIsAdept(oItem))
        IPS_Item_disableProperties(oItem, oPC);

    //* TODO: Light model to make changes easier to see
    effect eLight = EffectVisualEffect( VFX_DUR_LIGHT_WHITE_20);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLight,oPC);

    //* Immobilize player while crafting
    effect eImmob = EffectCutsceneImmobilize();
    eImmob = ExtraordinaryEffect(eImmob);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eImmob,oPC);
}
