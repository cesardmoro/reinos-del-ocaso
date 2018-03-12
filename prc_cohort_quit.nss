//used when a cohort is fired via conversation

#include "prc_alterations"
#include "prc_inc_leadersh"
void main()
{
    RemoveCohortFromPlayer(OBJECT_SELF, GetPCSpeaker());
}
