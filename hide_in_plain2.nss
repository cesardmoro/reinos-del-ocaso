/* created by evenflw
- trying to improve hide in plain sight */

#include "X0_I0_SPELLS"
void StopBattle(object Self) {
    // check for stopping battle
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(Self), OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget)) {
        //SendMessageToPC(OBJECT_SELF, GetTag(oTarget));
        if(oTarget!=Self && GetIsReactionTypeHostile(Self, oTarget)
            && !GetHasEffect(EFFECT_TYPE_ULTRAVISION, oTarget)) {
            if(GetAttackTarget(oTarget)==Self ||
                GetLastAttacker(Self)==oTarget) {
                AssignCommand(oTarget, ClearAllActions());
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(Self), TRUE, OBJECT_TYPE_CREATURE);
    }
}

void main()
{
    //int ranger=GetLevelByClass(CLASS_TYPE_RANGER);
    int assassin=GetLevelByClass(CLASS_TYPE_ASSASSIN);
    int shadow=GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
    if(GetLevelByClass(CLASS_TYPE_RANGER)>16
        &&!GetIsAreaNatural(GetArea(OBJECT_SELF)) && !shadow && assassin<8) { // rangers can't use inside
        SendMessageToPC(OBJECT_SELF, "Necesitas estar en un area natural para usar esta habilidad");
        return;
        }
    if(GetLevelByClass(CLASS_TYPE_RANGER)<17
        && GetIsAreaAboveGround(GetArea(OBJECT_SELF)) && GetIsDay()) { // rangers can't use inside
        SendMessageToPC(OBJECT_SELF, "No encuentras sombra dado que es de dia");
        return;
    } /*else if(GetIsAreaNatural(GetArea(OBJECT_SELF)) && GetIsDay() && ranger<17) {
        SendMessageToPC(OBJECT_SELF, "You require the night to hide yourself outdoors.");
        return;
    }*/
    int slot, nID, darkness=0;
    object inventory, oTarget;
    itemproperty itemp;
    effect eAOE;
    //Search through the valid effects on the hider
    eAOE = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eAOE)) {
            nID = GetEffectSpellId(eAOE);
            if(GetEffectType(eAOE)==EFFECT_TYPE_DARKNESS || nID==SPELL_DARKNESS || nID == SPELLABILITY_AS_DARKNESS
            || nID == SPELL_SHADOW_CONJURATION_DARKNESS || nID == 688)
            {
                darkness=1;
                break;
            }
        eAOE = GetNextEffect(OBJECT_SELF);
    }
    if(GetLocalInt(OBJECT_SELF, "EVENFLWHASBEENHITDARKNESS")) darkness=1;
    if(!darkness) {
    for(slot=0;slot<NUM_INVENTORY_SLOTS;slot++) { // worn glowing items
        inventory=GetItemInSlot(slot);
        if(GetHasSpellEffect(SPELL_LIGHT,OBJECT_SELF) == TRUE || GetHasSpellEffect(SPELL_CONTINUAL_FLAME,OBJECT_SELF) == TRUE)
         {
          SendMessageToPC(OBJECT_SELF, "Algun hechizo emite luz");
            return;
         }
        if(GetBaseItemType(inventory)==BASE_ITEM_TORCH) {
            SendMessageToPC(OBJECT_SELF, "Estas sosteniendo una antorcha");
            return;
        }
        itemp=GetFirstItemProperty(inventory);
        while(GetIsItemPropertyValid(itemp)) {
            if(GetItemPropertyType(itemp)==ITEM_PROPERTY_LIGHT) {
                SendMessageToPC(OBJECT_SELF, "Algun item que posees emite luz");
                return;
            }
            itemp=GetNextItemProperty(inventory);
        }
    }
    // checking for near lightsources
    oTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF), OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget)) {
         if(GetHasSpellEffect(SPELL_LIGHT,oTarget) == TRUE || GetHasSpellEffect(SPELL_CONTINUAL_FLAME,oTarget) == TRUE)
         {
          SendMessageToPC(OBJECT_SELF, "Estas muy cerca de una luz");
            return;
         }
        if(GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE && GetPlaceableIllumination(oTarget)) {
            SendMessageToPC(OBJECT_SELF, "Estas muy cerca de una luz");
            return;
        } else if(GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
            for(slot=0;slot<NUM_INVENTORY_SLOTS;slot++) { // look for worn glowing items
                inventory=GetItemInSlot(slot, oTarget);
                if(GetBaseItemType(inventory)==BASE_ITEM_TORCH) {
                    SendMessageToPC(OBJECT_SELF, "Estas muy cerca de una luz");
                    return;
                }
                itemp=GetFirstItemProperty(inventory);
                while(GetIsItemPropertyValid(itemp)) {
                    if(GetItemPropertyType(itemp)==ITEM_PROPERTY_LIGHT) {
                        SendMessageToPC(OBJECT_SELF, "Estas muy cerca de una luz");
                        return;
                    }
                    itemp=GetNextItemProperty(inventory);
                }
            }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
    }
    }

    //SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
    //StopBattle(OBJECT_SELF);
     // hide
    //DelayCommand(0.21f, UseStealthMode());
    //DelayCommand(0.2f, ActionUseSkill(SKILL_HIDE, OBJECT_SELF));
    //DelayCommand(0.2f, ActionUseSkill(SKILL_MOVE_SILENTLY, OBJECT_SELF));


    effect eSanc = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect stop = EffectCutsceneImmobilize();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanc, OBJECT_SELF, 0.5f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, stop, OBJECT_SELF, 3.0f); //half round action
    DelayCommand(0.2f, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
    //SendMessageToPC(OBJECT_SELF, "You attempt to hide in plain sight.");

}
