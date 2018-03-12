/*
    A samurai who commits ritual suicide has regained their honor.
*/

void main()
{
    object oPC = GetPCSpeaker();
    DelayCommand(29.0, AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 50));
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(0.1,AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,30.0)));
    DelayCommand(0.2, SetCommandable(FALSE, oPC));
    DelayCommand(30.0, SetCommandable(TRUE, oPC));
    DelayCommand(28.0, FloatingTextStringOnCreature("Your honor is restored.", oPC, FALSE));
    effect eDeath = EffectDeath();
    DelayCommand(30.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC));
}

