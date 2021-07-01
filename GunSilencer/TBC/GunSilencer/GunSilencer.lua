local MutedSounds = {
--DON'T TOUCH THE FOLLOWING 17 LINES if u don't understand what are u doing!!!
922086, --	sound/spells/spell_hu_bowrelease_01.ogg
922088, --	sound/spells/spell_hu_bowrelease_02.ogg
922090, --	sound/spells/spell_hu_bowrelease_03.ogg
922092, --	sound/spells/spell_hu_bowrelease_04.ogg
922094, --	sound/spells/spell_hu_bowrelease_05.ogg
925549, --	sound/spells/spell_hu_crossbowshoot_01.ogg
925551, --	sound/spells/spell_hu_crossbowshoot_02.ogg
925553, --	sound/spells/spell_hu_crossbowshoot_03.ogg
925555, --	sound/spells/spell_hu_crossbowshoot_04.ogg
925557, --	sound/spells/spell_hu_crossbowshoot_05.ogg
925559, --	sound/spells/spell_hu_crossbowshoot_06.ogg
921248, --	sound/spells/spell_hu_blunderbuss_weaponfire_01.ogg
921250, --	sound/spells/spell_hu_blunderbuss_weaponfire_02.ogg
921252, --	sound/spells/spell_hu_blunderbuss_weaponfire_03.ogg
921254, --	sound/spells/spell_hu_blunderbuss_weaponfire_04.ogg
921256, --	sound/spells/spell_hu_blunderbuss_weaponfire_05.ogg
921258, --	sound/spells/spell_hu_blunderbuss_weaponfire_06.ogg
--U can delete the following lines, if u don't want the addon to mute the sounds. Add another ones u want to mute. Use this database https://wow.tools/files/
1591768, --	sound/spells/spell_hu_arcaneshot_impact_01.ogg
1591769, --	sound/spells/spell_hu_arcaneshot_impact_02.ogg
1591770, --	sound/spells/spell_hu_arcaneshot_impact_03.ogg
1591771, --	sound/spells/spell_hu_arcaneshot_impact_04.ogg
1591772, --	sound/spells/spell_hu_arcaneshot_impact_05.ogg
1595634, --	sound/spells/spell_hu_barrage_impact_01.ogg
1595635, --	sound/spells/spell_hu_barrage_impact_02.ogg
1595636, --	sound/spells/spell_hu_barrage_impact_03.ogg
1595637, --	sound/spells/spell_hu_barrage_impact_04.ogg
1595638, --	sound/spells/spell_hu_barrage_impact_05.ogg
1595639, --	sound/spells/spell_hu_barrage_impact_06.ogg
1595640, --	sound/spells/spell_hu_barrage_missle_loop_01.ogg
1595641, --	sound/spells/spell_hu_barrage_missle_loop_02.ogg
1603120, --	sound/spells/spell_hu_barrage_cast_01.ogg
1603121, --	sound/spells/spell_hu_barrage_cast_02.ogg
1603122, --	sound/spells/spell_hu_barrage_cast_03.ogg
1603123, --	sound/spells/spell_hu_barrage_cast_04.ogg
569707, --	sound/spells/spell_hu_cobrashot_impact_01.ogg
568665, --	sound/spells/spell_hu_cobrashot_impact_02.ogg
568498, --	sound/spells/spell_hu_cobrashot_impact_03.ogg
569505, --	sound/spells/spell_hu_cobrashot_impact_04.ogg
568259, --	sound/spells/spell_hu_cobrashot_impact_05.ogg
1589899, --	sound/spells/spell_hu_cobrashot_impact_06.ogg
1303796, --	sound/spells/spell_hu_killcommand_cast.ogg
569021, --	sound/spells/spell_hu_killcommand_impact.ogg
1591066, --	sound/spells/spell_hu_kill_command_cast_01.ogg
1591067, --	sound/spells/spell_hu_kill_command_cast_02.ogg
1591068, --	sound/spells/spell_hu_kill_command_cast_03.ogg
1318266, --	sound/spells/spell_hu_multishot_impact01.ogg
1318267, --	sound/spells/spell_hu_multishot_impact02.ogg
1318268, --	sound/spells/spell_hu_multishot_impact03.ogg
1360714, --	sound/spells/spell_ro_pistolshot_cast_01.ogg
1360715, --	sound/spells/spell_ro_pistolshot_cast_02.ogg
1360716, --	sound/spells/spell_ro_pistolshot_cast_03.ogg
1360717, --	sound/spells/spell_ro_pistolshot_cast_04.ogg
1360718 --	sound/spells/spell_ro_pistolshot_cast_05.ogg
}

local GunSilencer = CreateFrame("Frame", "GunSilencer01", nil)
local Triggert, Triggernew = nil, nil
local ReloadS=999999999
local Bow, CBow, Gun = nil, nil, nil
local Bowname, CBowname, Gunname = "Bows", "Crossbows", "Guns"
local filen, filer = nil, nil
local timedelay, timereset = 0.6, 0.7
local mini, maxi = 0, 18
local eltimer=0
local loginp=0
local TransmogLocationMixin={}
local transmogLocation = CreateFromMixins(TransmogLocationMixin)
transmogLocation.slotID=16
transmogLocation.type=0
transmogLocation.modification=0



local function MuteUnmute()
	if Bow then
		mini=0
		maxi=6
	elseif CBow then
		mini=5
		maxi=12
	elseif Gun then
		mini=11
		maxi=18
	else
		mini=0
		maxi=18
	end
	if _GunSilencer == "on" then
		for k, fileid in pairs(MutedSounds) do
			if (k<maxi and k>mini) or k>17 then
				MuteSoundFile(fileid)
			else 
				UnmuteSoundFile(fileid)
			end
		end
	else
		for _, fileid in pairs(MutedSounds) do
			UnmuteSoundFile(fileid)
		end
	end
end

local function ChWeapon()
	Bow, CBow, Gun = IsEquippedItemType(Bowname), IsEquippedItemType(CBowname), IsEquippedItemType(Gunname)

	if Bow or CBow or Gun then
		local tosh=select(3,C_Transmog.GetSlotVisualInfo(transmogLocation))
		local tname=nil
		if tosh~=0 then
			for k, v in pairs(C_TransmogCollection.GetSourceInfo(tosh)) do
				if k=="itemID" then
					tname=select(7,GetItemInfo(v))
					Bow, CBow, Gun = tname==Bowname, tname==CBowname, tname==Gunname
				end
			end
		end
	end

	if Bow then
		filen="Interface\\AddOns\\GunSilencer\\spell_hu_bowrelease_0"
		filer="Interface\\AddOns\\GunSilencer\\spell_hu_bowpullback_0"
		timedelay=0.7
		timereset=0.8
	elseif CBow then
		filen="Interface\\AddOns\\GunSilencer\\spell_hu_crossbowshoot_0"
		filer="Interface\\AddOns\\GunSilencer\\spell_hu_crossbowload_0"
		timedelay=0.6
		timereset=0.7
	else
		filen="Interface\\AddOns\\GunSilencer\\spell_hu_blunderbuss_weaponfire_0"
		filer="Interface\\AddOns\\GunSilencer\\spell_hu_blunderbuss_reload_0"
		timedelay=0.6
		timereset=0.7
	end
end

local function onEvent(self, event, ...)
	local arg1, arg2, arg3 = ...
	if (event == "PLAYER_CONTROL_LOST") or (event == "PLAYER_DEAD") then
		ReloadS=999999999
	elseif (event == "PLAYER_EQUIPMENT_CHANGED") or (event == "TRANSMOGRIFY_SUCCESS") or (event == "PLAYER_ENTERING_WORLD") then
		loginp=0
	elseif _GunSilencer == "on" and (event == "UNIT_SPELLCAST_START") and (arg1 == "player") then
		if (arg3==56641 or arg3==19434) then
			ReloadS=999999998
			if Bow then
				PlaySoundFile(filer .. math.random(3) .. ".ogg")
			end
		else
			ReloadS=999999999
		end
	elseif (event == "ADDON_LOADED" and arg1 == "GunSilencer") then
		if _GunSilencer == nil then
			_GunSilencer = "on"
		end
		local cloc = GetLocale()
		if cloc == "frFR" then
			Bowname, CBowname, Gunname = "Arcs", "Arbal\195\168tes", "Fusils"
		elseif cloc == "deDE" then
			Bowname, CBowname, Gunname = "Bogen", "Armbr\195\188ste", "Schusswaffen"
		elseif cloc == "esES" or cloc == "esMX" then
			Bowname, CBowname, Gunname = "Arcos", "Ballestas", "Armas de fuego"
		elseif cloc == "itIT" then
			Bowname, CBowname, Gunname = "Archi", "Balestre", "Armi da fuoco"
		elseif cloc == "ptBR" then
			Bowname, CBowname, Gunname = "Arcos", "Bestas", "Armas de Fogo"
		elseif cloc == "ruRU" then
			Bowname, CBowname, Gunname = "\208\155\209\131\208\186\208\184", "\208\144\209\128\208\177\208\176\208\187\208\181\209\130\209\139", "\208\158\208\179\208\189\208\181\209\129\209\130\209\128\208\181\208\187\209\140\208\189\208\190\208\181"
		elseif cloc == "koKR" then
			Bowname, CBowname, Gunname = "\237\153\156\235\165\152", "\236\132\157\234\182\129\235\165\152", "\236\180\157\234\184\176\235\165\152"
		elseif cloc == "zhCN" then
			Bowname, CBowname, Gunname = "\229\188\147", "\229\188\169", "\230\158\170\230\162\176"
		elseif cloc == "zhTW" then
			Bowname, CBowname, Gunname = "\229\188\147", "\229\188\169", "\230\167\141\230\162\176"
		end
	elseif (event == "PLAYER_LOGIN") then
		print("|cffe6cc80GunSilencer Loaded. Type |cff00c0ff/gs|cffe6cc80 to switch on/off alternative shot sounds")
	elseif _GunSilencer == "on" and (event == "UNIT_SPELLCAST_SUCCEEDED") and (arg1 == "player") then
		
		if arg3==75 or arg3==193455 or arg3==53209 or arg3==2643 or arg3==257620 or arg3==212431 or arg3==198670 or arg3==56641 or arg3==271788 or arg3==120361 or arg3==217200 or arg3==5116 or arg3==147362 or arg3==185358 or arg3==19434 then
			if ReloadS~=999999998 or arg3==56641 or arg3==19434 then
				ReloadS=GetTime()
			end
			Triggert=1
			PlaySoundFile(filen .. math.random(3) .. ".ogg")
		elseif arg3==19577 or arg3==259489 then
			ReloadS=999999999
			PlaySoundFile("Interface\\AddOns\\GunSilencer\\spell_hu_kill_command_cast.ogg")
		elseif arg3==34026 then
			ReloadS=GetTime()
			Triggert=1
			PlaySoundFile("Interface\\AddOns\\GunSilencer\\spell_hu_kill_command_cast.ogg")
		elseif arg3==58984 or arg3==5384 or arg3==257044 then
			ReloadS=999999999
		elseif arg3==185763 then
			PlaySoundFile("Interface\\AddOns\\GunSilencer\\spell_ro_pistolshot_cast_0" .. math.random(3) .. ".ogg")
		elseif 	ReloadS~=999999999 or ReloadS~=999999998 then
			ReloadS=GetTime()
		end

--		print(arg3)
	end
end

local function onUp(self, elapsed)
	if eltimer>0.015 then 
		eltimer=0
		if loginp==20 or loginp==250 then 
			ChWeapon()
			MuteUnmute()
		end
		loginp = loginp + 1
		if _GunSilencer == "on" and UnitCanAttack("player","target") and Triggert then
			if GetTime()-ReloadS > timedelay then 
				ReloadS=999999999
				Triggert=nil
				PlaySoundFile(filer .. math.random(6) .. ".ogg")
			elseif GetTime()-ReloadS > timereset then
				ReloadS=999999999
			end
		end
	else
		eltimer=eltimer+elapsed
	end
end


SlashCmdList["GUNSILENCER"] = function(msg)
	if _GunSilencer == "on" then
		_GunSilencer = "off"
		print("|cffe6cc80Gun Silencer are OFF")
	else 
		_GunSilencer = "on"
		print("|cffe6cc80Gun Silencer are ON")
	end
	MuteUnmute()
end
SLASH_GUNSILENCER1 = "/gs"
GunSilencer:RegisterEvent("ADDON_LOADED")
GunSilencer:RegisterEvent("PLAYER_ENTERING_WORLD")
GunSilencer:RegisterEvent("PLAYER_LOGIN")
GunSilencer:RegisterEvent("PLAYER_CONTROL_LOST")
GunSilencer:RegisterEvent("PLAYER_DEAD")
GunSilencer:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
GunSilencer:RegisterEvent("TRANSMOGRIFY_SUCCESS")
GunSilencer:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
GunSilencer:RegisterEvent("UNIT_SPELLCAST_START")
GunSilencer:SetScript("OnEvent", onEvent)
GunSilencer:SetScript("OnUpdate", onUp)
