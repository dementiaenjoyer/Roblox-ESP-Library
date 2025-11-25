local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/Roblox-ESP-Library/refs/heads/main/Source/Main.lua"))();
Library.Settings.Box.Enabled = true;
Library.Settings.Name.Enabled = true;
Library.Settings.Healthbar.Enabled = true;

Library.Settings.Box.Colors[1] = Color3.new(1, 0, 0);
Library.Settings.Name.Colors[1] = Color3.new(1, 0, 0);
Library.Settings.Healthbar.Colors[1] = Color3.new(0, 1, 0);

Library:Initiate();
