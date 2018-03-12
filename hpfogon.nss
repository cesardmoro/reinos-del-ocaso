void main()
{
    object oFogon = OBJECT_SELF;
    int iFogonHP = GetCurrentHitPoints(oFogon);
    if( iFogonHP == 1 )
    {
    ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

    }
    if( GetWeather(GetArea(OBJECT_SELF)) == WEATHER_RAIN && iFogonHP > 1 )
    {
     ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
     SpeakString("La Fogata se apaga por la lluvia", TALKVOLUME_TALK);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(OBJECT_SELF)-1), oFogon);
     return;
    }
    if (iFogonHP == 5)
        {
            SpeakString("El fuego comienza a apagarse", TALKVOLUME_TALK);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oFogon);
        }
    if (iFogonHP <= 5 && iFogonHP > 1 )
        {
           //SpeakString("El fuego comienza a apagarse", TALKVOLUME_TALK);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oFogon);
        }
if (iFogonHP > 5)
        {
           // SpeakString("El fuego comienza a apagarse", TALKVOLUME_TALK);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oFogon);
        }
    }

//  Linea que muestra el HP del fuego.
//  SpeakString(IntToString(iFogonHP), TALKVOLUME_TALK);


