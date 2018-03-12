/****************************************
 Acciones de Vuelo

 Al usarse esta dote en estado de vuelo se tienen 2 opciones:
 - Usarla sobre uno mismo para flotar o dejar de flotar (solo valido con habilidades sobrenaturales)
 - Usarla sobre un punto del terreno para volar hasta ese punto (posible de contar con alas)
****************************************/

#include "Fly_inc"
#include "prc_inc_combat"

void main()
{
    object oTarget = GetSpellTargetObject();
    location targetLocation = GetSpellTargetLocation();
	if (oTarget==OBJECT_SELF)
    {
        if (Fly_GetIsHovering())
            Fly_StopHovering();
        else if (Fly_GetCanHover())
            Fly_StartHovering();
    } 
	else if (Fly_GetCanFly())
    {
        if (!GetIsAreaInterior(GetArea(OBJECT_SELF)))
        {
			if (!GetIsObjectValid(oTarget))
			{
				float distanciaAlObjetivo = GetDistanceBetweenLocations(targetLocation, GetLocation(OBJECT_SELF));
                //SendMessageToPC(OBJECT_SELF, "distanciaAlObjetivo: "+FloatToString(distanciaAlObjetivo));
                if (distanciaAlObjetivo < 0.0) distanciaAlObjetivo = -distanciaAlObjetivo;
                //SendMessageToPC(OBJECT_SELF, "distanciaAlObjetivo: "+FloatToString(distanciaAlObjetivo));
                float tiempoDeVuelo = distanciaAlObjetivo / 10.0;
                if (tiempoDeVuelo < 3.0) tiempoDeVuelo = 3.0;
                //SendMessageToPC(OBJECT_SELF, "tiempoDeVuelo: "+FloatToString(tiempoDeVuelo));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDisappearAppear(targetLocation), OBJECT_SELF, tiempoDeVuelo);
			} 
			else if ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsFriend(oTarget) )
			{
				targetLocation = GetLocation(oTarget);
				float distanciaAlObjetivo = GetDistanceBetweenLocations(targetLocation, GetLocation(OBJECT_SELF));
				//SendMessageToPC(OBJECT_SELF, "distanciaAlObjetivo: "+FloatToString(distanciaAlObjetivo));
				if (distanciaAlObjetivo < 0.0) distanciaAlObjetivo = -distanciaAlObjetivo;
				//SendMessageToPC(OBJECT_SELF, "distanciaAlObjetivo: "+FloatToString(distanciaAlObjetivo));
				float tiempoDeVuelo = distanciaAlObjetivo / 10.0;
				if (tiempoDeVuelo < 3.0) tiempoDeVuelo = 3.0;
				//SendMessageToPC(OBJECT_SELF, "tiempoDeVuelo: "+FloatToString(tiempoDeVuelo));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDisappearAppear(targetLocation), OBJECT_SELF, tiempoDeVuelo);
				DelayCommand(tiempoDeVuelo, PerformAttack(oTarget, OBJECT_SELF, EffectVisualEffect(VFX_NONE), 0.0, 2, DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING, "Dive Attack: HIT!", "Dive Attack: MISS!"));
			}
		}
		else
			FloatingTextStringOnCreature("No puedes volar aqui dentro", OBJECT_SELF, FALSE);
	} 
	else 
	{
		FloatingTextStringOnCreature("Debes tener alas o estar bajo el conjuro Volar para realizar esta accion", OBJECT_SELF, FALSE);
	}
}
