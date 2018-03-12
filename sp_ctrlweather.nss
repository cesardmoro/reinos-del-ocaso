/************************************
Spell Control Weather
**************************************/

#include "x2_inc_spellhook"
#include "rdo_spell_const"

const string ControlWeather_IS_STORM = "ControlWeather_IS_STORM";
const int NATURE_CASTER_LEVEL = 10;

// Lanza rayos en el area al azar
void DoStorm();
void DoStorm()
{
    if (GetLocalInt(OBJECT_SELF, ControlWeather_IS_STORM)==TRUE)
    {
        int randomId = Random(40);
        int iterador = 0;
        object objetoIterado = GetFirstObjectInArea(OBJECT_SELF);
        int nDamage = d6(NATURE_CASTER_LEVEL);
        effect eVisRayo = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        while (GetIsObjectValid(objetoIterado))
        {
            if (randomId==iterador)
            {
                nDamage = GetReflexAdjustedDamage(nDamage, objetoIterado, 15, SAVING_THROW_TYPE_ELECTRICITY);
                effect eDanRayo = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanRayo, objetoIterado);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisRayo, objetoIterado);
            }
            iterador++;
            objetoIterado = GetNextObjectInArea(OBJECT_SELF);
        }
        for (iterador=1; iterador<=d4(); iterador++)
        {
            float xRayo = IntToFloat(Random(GetAreaSize(AREA_WIDTH, OBJECT_SELF) * 30));
            float yRayo = IntToFloat(Random(GetAreaSize(AREA_HEIGHT, OBJECT_SELF) * 30));
            vector posicionRayo = Vector(xRayo, yRayo, 0.0);
            location locacionRayo = Location(OBJECT_SELF, posicionRayo, 0.0);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisRayo, locacionRayo);
        }
        DelayCommand(IntToFloat(Random(61)+30), AssignCommand(OBJECT_SELF, DoStorm()));
    }
}

void ResetWeather( float fDelay, int normalSkyBox );
void ResetWeather( float fDelay, int normalSkyBox )
{
    DelayCommand((fDelay+2.0), SetWeather(OBJECT_SELF, WEATHER_USE_AREA_SETTINGS));
    DelayCommand(fDelay, SetSkyBox(normalSkyBox, OBJECT_SELF));
    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, ControlWeather_IS_STORM));
}

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oArea = GetArea(OBJECT_SELF);

    if (!GetIsAreaInterior(oArea))
    {
        int nDuration = d12(2);
        nDuration *= (GetMetaMagicFeat()==METAMAGIC_EXTEND) ? 2 : 1;
        float fDuration = HoursToSeconds(nDuration);

        int weatherType = WEATHER_USE_AREA_SETTINGS;
        int skyBox = GetSkyBox(oArea);
        int spellId = GetSpellId();
        switch (spellId) {
            case SPELL_CONTROL_WEATHER_CLEAR:   weatherType = WEATHER_CLEAR;
                                                skyBox = SKYBOX_GRASS_CLEAR;
                                                break;
            case SPELL_CONTROL_WEATHER_RAIN:    weatherType = WEATHER_RAIN;
                                                skyBox = SKYBOX_GRASS_CLEAR;
                                                break;
            case SPELL_CONTROL_WEATHER_STORM:   weatherType = WEATHER_RAIN;
                                                skyBox = SKYBOX_GRASS_STORM;
                                                break;
            case SPELL_CONTROL_WEATHER_SNOW:    weatherType = WEATHER_SNOW;
                                                skyBox = SKYBOX_ICY;
                                                break;
        }

        int normalSkyBox = GetSkyBox(oArea);
        DelayCommand(TurnsToSeconds(1), SetWeather(oArea, weatherType));
        DelayCommand(TurnsToSeconds(1), SetSkyBox(skyBox, oArea));

        AssignCommand(oArea, ResetWeather(fDuration, normalSkyBox));

        // Si el conjurador pidio una tormenta, tirar rayos por todos lados
        if (spellId==SPELL_CONTROL_WEATHER_STORM)
        {
            SetLocalInt(oArea, ControlWeather_IS_STORM, TRUE);
            DelayCommand(TurnsToSeconds(1), AssignCommand(oArea, DoStorm()));
        }
        else
            DeleteLocalInt(oArea, ControlWeather_IS_STORM);
    }
    else
        FloatingTextStringOnCreature("Solo puedes usar este conjuro en areas exteriores", OBJECT_SELF, FALSE);
}
