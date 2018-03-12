int StartingConditional() {
    ClearAllActions();
    ActionDoCommand( ActionWait( 30.0 ) );
    return !GetCampaignInt("PVP", "Assasin", GetLastSpeaker() );
}
