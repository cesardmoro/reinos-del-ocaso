#include "prc_alterations"
#include "inc_item_props"

const int IPRP_FEAT_EPIC_REST = 399;

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int addProp = 1;

	// I took this logic from the inc_epicspells.nss file in the
	// Epic Spells Directory.
    if (GetCasterLvl(TYPE_CLERIC, oPC) >= 21
			|| GetCasterLvl(TYPE_DRUID, oPC) >= 21
			|| GetCasterLvl(TYPE_SORCERER, oPC) >= 21
			|| GetCasterLvl(TYPE_WIZARD, oPC) >= 21) {

		// Determine if the property is already on the skin
		itemproperty ip = GetFirstItemProperty(oSkin);
		while (GetIsItemPropertyValid(ip)) {
			if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT) {
				// Reference iprp_feats.2da
				if (GetItemPropertySubType(ip) == IPRP_FEAT_EPIC_REST) {
					addProp = 0;
					break;
				}
			}

			// Get the next property
			ip = GetNextItemProperty(oSkin);
		}

		if (addProp > 0) {
			AddItemProperty(DURATION_TYPE_PERMANENT,
					ItemPropertyBonusFeat(IPRP_FEAT_EPIC_REST), oSkin);
		}
	}
}
