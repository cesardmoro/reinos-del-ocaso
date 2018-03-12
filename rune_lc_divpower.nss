void main()
{

object oPC = OBJECT_SELF;
object oScribe = GetFirstItemInInventory(oPC);

     while(GetIsObjectValid(oScribe))
      {
           if(GetResRef(oScribe) == "runescarreddagge")
           {
            SetLocalString(oScribe, "lc_divpower", "1");
           }
      oScribe = GetNextItemInInventory(oPC);
      }
}
