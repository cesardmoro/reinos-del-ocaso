void main()
{
  object oPC = OBJECT_SELF;

  if(GetLocalInt(oPC,"cwsm_daisho") != 1)
  {
  CreateItemOnObject("nw_wswka001",oPC);
  CreateItemOnObject("nw_wswss001",oPC);
  SetLocalInt(oPC,"cwsm_daisho",1);
  }
}
