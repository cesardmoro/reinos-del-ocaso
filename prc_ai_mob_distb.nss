void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_distrb", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondisturb", OBJECT_SELF);
    ExecuteScript("prc_npc_disturb", OBJECT_SELF);
}