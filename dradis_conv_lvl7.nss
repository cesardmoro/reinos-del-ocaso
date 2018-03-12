const int SPELL_LEVEL = 7;

void main()
{
    SetLocalInt(GetPCSpeaker(), "SPELL_LEVEL", SPELL_LEVEL);
    SetCustomToken(14001, IntToString(SPELL_LEVEL));
}
