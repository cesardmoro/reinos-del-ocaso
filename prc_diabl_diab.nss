void main()
{
    object oCaster = OBJECT_SELF;
    
    if (GetLocalInt(oCaster, "Diabolism") == FALSE)
    {
       	SetLocalInt(oCaster, "Diabolism", TRUE);
    	FloatingTextStringOnCreature("Diabolism On", oCaster, FALSE);
    }
    else
    {
       	SetLocalInt(oCaster, "Diabolism", FALSE);
    	FloatingTextStringOnCreature("Diabolism Off", oCaster, FALSE);
    }   
    //FloatingTextStringOnCreature(IntToString(GetLocalInt(oCaster, "Diabolism")), oCaster, FALSE);
}