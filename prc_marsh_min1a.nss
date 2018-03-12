#include "prc_alterations"
#include "prc_add_spl_pen"
#include "prc_misc_const"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oTarget = GetEnteringObject();
    object PCMarshal = GetAreaOfEffectCreator();
    
    string sMes = "";

    int MarshCha = GetAbilityModifier(ABILITY_CHARISMA, PCMarshal);
    
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))   
    {
            //Demand Fortitude
            if(GetHasSpellEffect(3500, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_FORT, MarshCha, SAVING_THROW_TYPE_ALL), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Force of Will
            if(GetHasSpellEffect(3501, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_WILL, MarshCha, SAVING_THROW_TYPE_ALL), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Watchful Eye
            if(GetHasSpellEffect(3502, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, MarshCha, SAVING_THROW_TYPE_ALL), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Charisma
            if(GetHasSpellEffect(3503, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_BLUFF, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_INTIMIDATE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_PERFORM, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_PERSUADE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_TAUNT, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_IAIJUTSU_FOCUS, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Constitution
            if(GetHasSpellEffect(3504, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_CONCENTRATION, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Dexterity
            if(GetHasSpellEffect(3505, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_HIDE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_MOVE_SILENTLY, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_OPEN_LOCK, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_PARRY, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_PICK_POCKET, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SET_TRAP, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_TUMBLE, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Intelligence
            if(GetHasSpellEffect(3506, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SPELLCRAFT, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SEARCH, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_LORE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_DISABLE_TRAP, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_CRAFT_WEAPON, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_CRAFT_TRAP, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_CRAFT_ARMOR, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_APPRAISE, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Strength
            if(GetHasSpellEffect(3507, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_DISCIPLINE, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_JUMP, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Boost Wisdom
            if(GetHasSpellEffect(3508, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SPOT, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_LISTEN, MarshCha), oTarget);
              ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_HEAL, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
            //Determined Caster
            if(GetHasSpellEffect(3509, PCMarshal)) 
              {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
                 SetLocalInt(oTarget,"Marshal_DetCast",MarshCha);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
              }
    }
    
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))   
   {
               //Art of War
               if(GetHasSpellEffect(3510, PCMarshal))
                 {
              if (GetLocalInt(PCMarshal,"MarshalMinor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillDecrease(SKILL_DISCIPLINE, MarshCha), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMinor",1);
                 }
                 }
   }
}
