
void RS_DMC_onActivate() {
//    if( GetIsDM( GetItemActivator() ) )
        AssignCommand( GetItemActivator(), ActionStartConversation( GetItemActivator(), "rs_dmc_conversat", TRUE, FALSE ) );
}
