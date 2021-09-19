local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

local Prefs =
{
	SongOpt =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	AltResult =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	MenuFix =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	InvertAccel =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	DefLives =
	{
		Default = "Auto",
		Choices = { 1, 5, 10, 20, 40, 50, "Auto" },
		Values = { 1, 5, 10, 20, 40, 50, -1 }
	},
	CboUnder =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	DefDifficulties =
	{
		Default = false,
		Choices = { "Set", "Calculated" },
		Values = { false, true }
	},
	ComboIsPerRow =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
}

ThemePrefs.InitAll(Prefs)