void main()
{

object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

     while(GetIsObjectValid(oScribe))
      {
           if(GetResRef(oScribe) == "runescarreddagge")
           {
            SetLocalString(oScribe, "rh_rest", "1");
           }
      oScribe = GetNextItemInInventory(oPC);
      }
}
