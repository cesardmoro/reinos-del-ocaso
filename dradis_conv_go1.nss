const int CLASS_POSITION = 1;

void main()
{
    SetLocalInt(GetPCSpeaker(), "CLASS_POSITION", CLASS_POSITION);
    SetCustomToken(14005, GetStringByStrRef(StringToInt(Get2DAString("classes", "Name", GetClassByPosition(CLASS_POSITION)))));
}
