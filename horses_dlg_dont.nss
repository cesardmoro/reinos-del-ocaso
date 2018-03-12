#include "Horses_const"
#include "rdo_const_skill"

void main()
{
    SetLocalInt(OBJECT_SELF, Horses_OWNER_ALLOWS_OTHERS_TO_RIDE, GetSkillRank(SKILL_RIDE, GetPCSpeaker()));
}
