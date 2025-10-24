-- Services
local Service = setmetatable({ }, {__index = function(Self, Index)
    return game.GetService(game, Index);
end})

local Players = Service.Players;
local Workspace = Service.Workspace;

-- Imports
local BetterDrawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/Better-Drawing/refs/heads/main/Main.lua"))();

-- Cache
local Black = Color3.new(0, 0, 0);

local DrawingNew = Drawing.new;

local Vector3New, Vector2New, Vector3Zero = Vector3.new, Vector2.new, Vector3.zero;
local CFrameNew, CFrameZero = CFrame.new, CFrame.identity;

local Round, Tan, Rad, Floor, Max, Min = math.round, math.tan, math.rad, math.floor, math.max, math.min;

-- Variables
local DrawingFlag = BetterDrawing.FLAG;

local Camera = Workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;

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
    local Library = { Connections = { } }; do
        local PlayerManager = { }; do
            local PlayerObject = { }; do
                function PlayerObject:GetName(): string
                    return tostring(self.Player);
                end

                function PlayerObject:GetHealth(Character): number
                    local Humanoid = Character.Humanoid;

                    if (not Humanoid) then
                        return 100, 100;
                    end

                    return Humanoid.Health, Humanoid.MaxHealth;
                end
                
                function PlayerObject:GetCharacter(): (table, Instance)
                    local Player = self.Player;
                    local Character = Player.Character;

                    if (not Character) then
                        return;
                    end

                    return Utility:ReverseKeys(Character:GetChildren(), true), Character:FindFirstChild("HumanoidRootPart");
                end

                function PlayerObject:Update(): nil
                    local Character, PrimaryPart = self:GetCharacter();

                    if (not PrimaryPart) then
                        return;
                    end

                    local Name, Position = self:GetName(), PrimaryPart.Position;
                    local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Position - Vector3New(0, 0.5, 0));

                    if (not OnScreen) then
                        return;
                    end

                    local Distance = ScreenPosition.Z;
                    local Scale = (2 * Camera.ViewportSize.Y) / ((2 * Distance * Tan(Rad(Camera.FieldOfView) / 2)) * 1.5);

                    local Width, Height = Round(3 * Scale), Round(4 * Scale);
                    local Size = Vector2New(Width, Height);

                    local Center = Vector2New(Round(ScreenPosition.X - (Width / 2)), Round(ScreenPosition.Y - (Height / 2)));

                    -- Box
                    do
                        local Outline = DrawingNew("Square", DrawingFlag);
                        Outline.Visible = true;
                        Outline.Transparency = 1;
                        Outline.Color = Black;
                        Outline.Thickness = 3;
                        Outline.Size = Size;
                        Outline.Position = Center;

                        local Square = DrawingNew("Square", DrawingFlag);
                        Square.Visible = true;
                        Square.Transparency = 1;
                        Square.Color = Color3.new(1, 1, 1);
                        Square.Thickness = 1;
                        Square.Size = Size;
                        Square.Position = Center;
                    end

                    -- Name
                    do
                        local Text = DrawingNew("Text", DrawingFlag);
                        Text.Visible = true;
                        Text.Transparency = 1;
                        Text.Color = Color3.new(1, 1, 1);
                        Text.Font = 2;
                        Text.Size = 13;
                        Text.Outline = true;
                        Text.OutlineColor = Black;
                        Text.Center = true;
                        Text.Text = Name;
                        Text.Position = Vector2New(Center.X + (Width / 2), Center.Y - 17);
                    end

                    -- Healthbar
                    do
                        local PositionX, PositionY = Center.X - 4, Center.Y;

                        local Outline, Bar = DrawingNew("Line", DrawingFlag), DrawingNew("Line", DrawingFlag);
                        Outline.Transparency, Outline.Visible, Bar.Transparency, Bar.Visible = 1, true, 1, true;

                        local Top = Floor(PositionY + 0.5);
                        local Bottom = Floor(PositionY + Height + 0.5);

                        local Health, MaxHealth = self:GetHealth(Character);

                        Bar.Color = Color3.new(1, 1, 1);
                        Bar.Thickness = 1;
                        Bar.From = Vector2New(PositionX, Bottom);
                        Bar.To = Vector2New(PositionX, Bottom - Floor(Max(0, Min(1, Health / MaxHealth)) * (Bottom - Top) + 0.5));

                        Outline.Color = Black;
                        Outline.Thickness = 3;
                        Outline.From = Vector2New(PositionX, Bottom + 1);
                        Outline.To = Vector2New(PositionX, Top - 1);
                    end
                end

                PlayerObject = setmetatable(PlayerObject, {__call = function(Self, Player): table
                    local Object = table.clone(Self);
                    Object.Player = Player;

                    return Object;
                end})
            end

            function PlayerManager:Get(): table
                local Objects = { };

                for _, Player in Players:GetPlayers() do
                    if (Player == LocalPlayer) then
                        continue;
                    end

                    table.insert(Objects, PlayerObject(Player));
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
            table.insert(self.Connections, BetterDrawing:Init(function(DeltaTime)
                Library:Update(DeltaTime);
            end))
        end

        function Library:Destroy(): nil
            for _, Connection in self.Connections do
                Connection:Disconnect();
            end
        end

        function Library:SetPlayerObject(Index, Value)
            rawset(PlayerManager.PlayerObject, Index, Value);
        end

        Library.Players = PlayerManager;
    end

    -- Library:Initiate();
    return Library;
end
