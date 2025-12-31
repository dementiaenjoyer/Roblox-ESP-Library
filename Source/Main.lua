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
    function Utility:ReverseKeys(Keys, MakeString)
        local Table = { };

        for Index, Value in Keys do
            if (typeof(Index) == "number") and MakeString then
                Value, Index = Value.Name, Value;
            end

            Table[Value] = Index;
        end

        return Table;
    end

    function Utility:Drawing(Class, Properties)
        local DrawingObject = DrawingNew(Class, DrawingFlag);

        for Index, Property in Properties do
            DrawingObject[Index] = Property;
        end

        return DrawingObject;
    end
end

-- Main
do
    local SettingsTemplate = {
        ["Healthbar"] = { ["Enabled"] = false, ["Colors"] = { White, Black }},
        ["Corner"] = { ["Enabled"] = false, ["Colors"] = { White, Black }},
        ["Name"] = { ["Enabled"] = false, ["Colors"] = { White, Black }},
        ["Box"] = { ["Enabled"] = false, ["Colors"] = { White, Black }},
    };

    local Library = { Connections = { }, Settings = SettingsTemplate }; do
        local Components = { Callbacks = { } }; do
            function Components:Set(Name, Callback): nil
                self.Callbacks[Name] = Callback;
            end

            Components:Set("Box", function(Self, Options)
                local Position, Size = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                Position = Vector2New(Round(Position.X), Round(Position.Y));
                Size = Vector2New(Round(Size.X), Round(Size.Y));

                Utility:Drawing("Square", {
                    ["Color"] = OutlineColor;
                    ["Visible"] = true;
                    ["Transparency"] = 1;
                    ["Thickness"] = 3;
                    ["Size"] = Size;
                    ["Position"] = Position;
                    ["ZIndex"] = 0;
                });

                Utility:Drawing("Square", {
                    ["Color"] = Color;
                    ["Visible"] = true;
                    ["Transparency"] = 1;
                    ["Thickness"] = 1;
                    ["Size"] = Size;
                    ["Position"] = Position;
                    ["ZIndex"] = 1;
                });
            end)

            Components:Set("Corner", function(Self, Options) -- forgive me for this code
                local Position, Size = Self:GetRender();

                if (not Position) then
                    return;
                end
            
                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                Position = Vector2New(Round(Position.X), Round(Position.Y));
                Size = Vector2New(Round(Size.X), Round(Size.Y));
            
                local PositionX, PositionY = Position.X, Position.Y;
                local SizeX, SizeY = Size.X, Size.Y;
            
                local Width = Round(SizeX * 0.2);
                local Height = Round(SizeY * 0.2);

                local PositionScale = PositionX + Width;
                local HeightScale = PositionY + Height;

                local From = Vector2New(PositionX, PositionY);
                        
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX - 1, PositionY);
                    ["To"] = Vector2New(PositionScale + 2, PositionY);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = From;
                    ["To"] = Vector2New(PositionScale + 1, PositionY);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX, PositionY - 1);
                    ["To"] = Vector2New(PositionX, HeightScale + 2);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = From;
                    ["To"] = Vector2New(PositionX, HeightScale + 1);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX + SizeX + 1, PositionY);
                    ["To"] = Vector2New(PositionX + SizeX - Width - 2, PositionY);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY);
                    ["To"] = Vector2New(PositionX + SizeX - Width - 1, PositionY);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY - 1);
                    ["To"] = Vector2New(PositionX + SizeX, HeightScale + 2);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY);
                    ["To"] = Vector2New(PositionX + SizeX, HeightScale + 1);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX - 1, PositionY + SizeY - 1);
                    ["To"] = Vector2New(PositionScale + 2, PositionY + SizeY - 1);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX, PositionY + SizeY - 1);
                    ["To"] = Vector2New(PositionScale + 1, PositionY + SizeY - 1);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX, PositionY + SizeY + 1);
                    ["To"] = Vector2New(PositionX, PositionY + SizeY - Height - 1);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX, PositionY + SizeY);
                    ["To"] = Vector2New(PositionX, PositionY + SizeY - Height);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX + SizeX + 1, PositionY + SizeY - 1);
                    ["To"] = Vector2New(PositionX + SizeX - Width - 2, PositionY + SizeY - 1);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY + SizeY - 1);
                    ["To"] = Vector2New(PositionX + SizeX - Width - 1, PositionY + SizeY - 1);
                    ["ZIndex"] = 1;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = OutlineColor;
                    ["Thickness"] = 3;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY + SizeY + 1);
                    ["To"] = Vector2New(PositionX + SizeX, PositionY + SizeY - Height - 1);
                    ["ZIndex"] = 0;
                });
            
                Utility:Drawing("Line", {
                    ["Visible"] = true;
                    ["Color"] = Color;
                    ["Thickness"] = 1;
                    ["From"] = Vector2New(PositionX + SizeX, PositionY + SizeY);
                    ["To"] = Vector2New(PositionX + SizeX, PositionY + SizeY - Height);
                    ["ZIndex"] = 1;
                });
            end);

            Components:Set("Name", function(Self, Options)
                local Position, Size = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                local Name = Self:GetName();

                Position = Vector2New(Round(Position.X), Round(Position.Y));
                Size = Vector2New(Round(Size.X), Round(Size.Y));

                Utility:Drawing("Text", {
                    ["Color"] = Color;
                    ["Visible"] = true;
                    ["Transparency"] = 1;
                    ["Font"] = 2;
                    ["Size"] = 13;
                    ["Outline"] = true;
                    ["OutlineColor"] = OutlineColor;
                    ["Center"] = true;
                    ["Text"] = Name;
                    ["Position"] = Vector2New(Position.X + (Size.X * 0.5), Position.Y - 15);
                    ["ZIndex"] = 2;
                });
            end)

            Components:Set("Healthbar", function(Self, Options)
                local Position, Size, Character = Self:GetRender();

                if (not Position) then
                    return;
                end

                local Colors = Options.Colors;
                local Color, OutlineColor = Colors[1], Colors[2];

                Position = Vector2New(Round(Position.X), Round(Position.Y));
                Size = Vector2New(Round(Size.X), Round(Size.Y));

                local PositionX, PositionY = Position.X - 4, Position.Y;

                local Top, Bottom = Floor(PositionY + 0.5), Floor(PositionY + Size.Y + 0.5);
                local Health, MaxHealth = Self:GetHealth(Character);
                local HealthRatio = Max(0, Min(1, Health / MaxHealth));
                local HealthHeight = Bottom - Floor(HealthRatio * (Bottom - Top) + 0.5);

                Utility:Drawing("Line", {
                    ["Visible"] = true,
                    ["Color"] = OutlineColor,
                    ["Thickness"] = 3,
                    ["From"] = Vector2New(PositionX, Bottom + 1),
                    ["To"] = Vector2New(PositionX, Top - 1),
                    ["ZIndex"] = 0,
                });

                Utility:Drawing("Line", {
                    ["Visible"] = true,
                    ["Color"] = Color,
                    ["Thickness"] = 1,
                    ["From"] = Vector2New(PositionX, Bottom),
                    ["To"] = Vector2New(PositionX, HealthHeight),
                    ["ZIndex"] = 1,
                });
            end)
        end

        local PlayerManager = { }; do
            local PlayerObject = { Position = Vector2Zero, Size = Vector2Zero, Tick = -1 }; do
                function PlayerObject:GetRender(): ( Vector2, Vector2, table )
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
                    local Scale = (2 * Camera.ViewportSize.Y) / ((2 * Distance * Tan(Rad(Camera.FieldOfView) * 0.5)) * 1.5);

                    local Width, Height = Round(3 * Scale), Round(4 * Scale);

                    local Size = Vector2New(Width, Height);
                    local Center = Vector2New(Round(ScreenPosition.X - (Width * 0.5)), Round(ScreenPosition.Y - (Height * 0.5)));

                    return Center, Size, Character;
                end

                function PlayerObject:GetPlayer()
                    return self.Player;
                end

                function PlayerObject:GetName(): string
                    return tostring(self:GetPlayer());
                end

                function PlayerObject:GetHealth(Character): number
                    local Humanoid = Character.Humanoid;

                    if (not Humanoid) then
                        return 100, 100;
                    end

                    return Humanoid.Health, Humanoid.MaxHealth;
                end
                
                function PlayerObject:GetCharacter(): ( table, Instance )
                    local Player = self:GetPlayer();
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
                end });
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
        
        function Library:GetPlayerObject(): table
            return PlayerManager.PlayerObject;
        end

        Library.Players = PlayerManager;
        Library.Components = Components;
    end

    -- Library:Initiate();
    return Library;
end
