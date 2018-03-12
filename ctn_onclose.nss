void main() {
    object user = GetLastClosedBy();
    if( GetHasSkill( SKILL_OPEN_LOCK, user ) ) {
        SetLockLockable( OBJECT_SELF, TRUE );
        int dc = GetSkillRank( SKILL_OPEN_LOCK, user, TRUE ) + GetSkillRank( SKILL_OPEN_LOCK, user, FALSE );
        dc /= 2;
        SetLockLockDC( OBJECT_SELF, dc );
        SetLockUnlockDC( OBJECT_SELF, dc );
    }
}
