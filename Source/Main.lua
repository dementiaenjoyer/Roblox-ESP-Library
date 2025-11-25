-- Services
local Service = setmetatable({ }, {__index = function(Self, Index)
    return game.GetService(game, Index);
end})

local Players = Service.Players;
local Workspace = Service.Workspace;

-- Imports
local BetterDrawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/Better-Drawing/refs/heads/main/Main.lua"))();

-- Variables
local DrawingFlag = BetterDrawing.FLAG;

local Camera = Workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;

-- Cache
local WorldToViewportPoint = Camera.WorldToViewportPoint;

local FindFirstChild = game.FindFirstChild;
local GetChildren = game.GetChildren;

local GetPlayers = Players.GetPlayers;

local Color3New = Color3.new;
local Color3FromRGB = Color3.fromRGB;

local DrawingNew = Drawing.new;

local Vector3New, Vector2New, Vector3Zero, Vector2Zero = Vector3.new, Vector2.new, Vector3.zero, Vector2.zero;
local CFrameNew, CFrameZero = CFrame.new, CFrame.identity;

local Round, Tan, Rad, Floor, Max, Min = math.round, math.tan, math.rad, math.floor, math.max, math.min;
local TableInsert, TableClone, TableUnpack = table.insert, table.clone, table.unpack;

local Black, White = Color3New(0, 0, 0), Color3New(1, 1, 1);

-- Functions
local Utility = { }; do
    function Utility:ReverseKeys(Old, Hello)
        local Table = { };

        for Index, Value in Old do
            if (typeof(Index) == "number") and Hello then
                Value, Index = Value.Name, Value;
            end

            Table[Value] = Index;
        end

        return Table;
    end
end

-- Main
do
    local SettingsTemplate = {
        ["Box"] = { ["Enabled"] = true, ["Colors"] = { White, Black }},
        ["Name"] = { ["Enabled"] = true, ["Colors"] = { White, Black }},
        ["Healthbar"] = { ["Enabled"] = true, ["Colors"] = { White, Black }}
    };

    local Library = { Connections = { }, Settings = SettingsTemplate }; do
        local Components = { Callbacks = { } }; do -- component's callback will not get called unless there is a key with the same name in the Settings table
            function Components:Add(Name, Callback): nil
                self.Callbacks[Name] = Callback;
            end

            Components:Add("Box", function(Self, Options)
                local Position, Size = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                local Outline = DrawingNew("Square", DrawingFlag);
                Outline.Color = OutlineColor;
                Outline.Visible = true;
                Outline.Transparency = 1;
                Outline.Thickness = 3;
                Outline.Size = Size;
                Outline.Position = Position;

                local Square = DrawingNew("Square", DrawingFlag);
                Square.Visible = true;
                Square.Transparency = 1;
                Square.Color = Color;
                Square.Thickness = 1;
                Square.Size = Size;
                Square.Position = Position;
            end)

            Components:Add("Name", function(Self, Options)
                local Position, Size = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                local Text = DrawingNew("Text", DrawingFlag);
                Text.Color = Color;
                Text.Visible = true;
                Text.Transparency = 1;
                Text.Font = 2;
                Text.Size = 13;
                Text.Outline = true;
                Text.OutlineColor = OutlineColor;
                Text.Center = true;
                Text.Text = Self:GetName();
                Text.Position = Vector2New(Position.X + (Size.X / 2), Position.Y - 15);
            end)

            Components:Add("Healthbar", function(Self, Options)
                local Position, Size, Character = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                local PositionX, PositionY = Position.X - 4, Position.Y;

                local Outline, Bar = DrawingNew("Line", DrawingFlag), DrawingNew("Line", DrawingFlag);
                Outline.Transparency, Outline.Visible, Bar.Transparency, Bar.Visible = 1, true, 1, true;

                local Top = Floor(PositionY + 0.5);
                local Bottom = Floor(PositionY + Size.Y + 0.5);

                local Health, MaxHealth = Self:GetHealth(Character);

                Bar.Color = Color;
                Bar.Thickness = 1;
                Bar.From = Vector2New(PositionX, Bottom);
                Bar.To = Vector2New(PositionX, Bottom - Floor(Max(0, Min(1, Health / MaxHealth)) * (Bottom - Top) + 0.5));

                Outline.Color = OutlineColor;
                Outline.Thickness = 3;
                Outline.From = Vector2New(PositionX, Bottom + 1);
                Outline.To = Vector2New(PositionX, Top - 1);
            end)
        end

        local PlayerManager = { }; do
            local PlayerObject = { Position = Vector2Zero, Size = Vector2Zero, Tick = -1 }; do
                function PlayerObject:GetName(): string
                    return tostring(self.Player);
                end

                function PlayerObject:GetRender(): ( Vector2, Vector2, table ) --[[  Position, Size, Character  ]]
                    local Character, PrimaryPart = self:GetCharacter();

                    if (not PrimaryPart) then
                        return;
                    end

                    local Position = PrimaryPart.Position;
                    local ScreenPosition, OnScreen = WorldToViewportPoint(Camera, Position - Vector3New(0, 0.5, 0));

                    if (not OnScreen) then
                        return;
                    end

                    local Distance = ScreenPosition.Z;
                    local Scale = (2 * Camera.ViewportSize.Y) / ((2 * Distance * Tan(Rad(Camera.FieldOfView) / 2)) * 1.5);

                    local Width, Height = Round(3 * Scale), Round(4 * Scale);

                    local Size = Vector2New(Width, Height);
                    local Center = Vector2New(Round(ScreenPosition.X - (Width / 2)), Round(ScreenPosition.Y - (Height / 2)));

                    return Center, Size, Character;
                end

                function PlayerObject:GetHealth(Character): number
                    local Humanoid = Character.Humanoid;

                    if (not Humanoid) then
                        return 100, 100;
                    end

                    return Humanoid.Health, Humanoid.MaxHealth;
                end
                
                function PlayerObject:GetCharacter(): ( table, Instance )
                    local Player = self.Player;
                    local Character = Player.Character;

                    if (not Character) then
                        return;
                    end

                    return Utility:ReverseKeys(GetChildren(Character), true), FindFirstChild(Character, "HumanoidRootPart");
                end

                function PlayerObject:Update(): nil
                    for Feature, Options in Library.Settings do
                        if (not Options.Enabled) then
                            continue;
                        end

                        Components.Callbacks[Feature](self, Options);
                    end
                end

                PlayerObject = setmetatable(PlayerObject, { __call = function(Self, Player): table
                    local Object = TableClone(Self);
                    Object.Player = Player;

                    return Object;
                end })
            end

            function PlayerManager:Get(): table
                local Objects = { };

                for _, Player in GetPlayers(Players) do
                    if (Player == LocalPlayer) then
                        continue;
                    end

                    TableInsert(Objects, PlayerObject(Player));
                end
                
                return Objects;
            end

            PlayerManager.PlayerObject = PlayerObject;
        end

        function Library:Update(): nil
            local EntityManager = self.Players;

            for _, Player in EntityManager:Get() do
                Player:Update();
            end
        end

        function Library:Initiate(): nil
            BetterDrawing:Init(function(DeltaTime)
                Library:Update(DeltaTime);
            end)
        end

        --[[
        function Library:Destroy(): nil
            for _, Connection in self.Connections do
                Connection:Disconnect();
            end
        end
        ]]

        function Library:SetPlayerObject(Index, Value): nil
            PlayerManager.PlayerObject = Value;
        end

        Library.Players = PlayerManager;
        Library.Components = Components;
    end

    -- Library:Initiate();
    return Library;
end
