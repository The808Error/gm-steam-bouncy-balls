if SERVER then
    resource.AddWorkshop( "3805938738" )
end

local COLOR_WHITE = Color( 255, 255, 255, 255 )
local DEFAULT_BOUNCE_SOUND = Sound( "garrysmod/balloon_pop_cute.wav" )

local function registerBall( class, iconPath, printName, bounceSound, consumeCallback )
    local ENT = {}
    ENT.Base = "sent_ball"
    ENT.Spawnable = true
    ENT.PrintName = printName
    ENT.Category = "Fun + Games"
    ENT.IconOverride = iconPath

    if CLIENT then
        killicon.Add( class, iconPath, COLOR_WHITE )
    end

    local matBall = Material( iconPath )

    function ENT:Draw()
        render.SetMaterial( matBall )

        local pos = self:GetPos()

        local size = math.Clamp( self:GetBallSize(), self.MinSize, self.MaxSize )
        render.DrawSprite( pos, size, size, COLOR_WHITE )
    end

    bounceSound = bounceSound or DEFAULT_BOUNCE_SOUND
    function ENT:PhysicsCollide( data, physobj )

        -- Play sound on bounce
        if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

            local pitch = 32 + 128 - math.Clamp( self:GetBallSize(), self.MinSize, self.MaxSize )
            sound.Play( bounceSound, self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )

        end

        -- Bounce like a crazy bitch
        local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
        local NewVelocity = physobj:GetVelocity()
        NewVelocity:Normalize()

        LastSpeed = math.max( NewVelocity:Length(), LastSpeed )

        local TargetVelocity = NewVelocity * LastSpeed * 0.9

        physobj:SetVelocity( TargetVelocity )

    end

    if consumeCallback then
        function ENT:Use( activator )
            self:Remove()

            if not activator:IsPlayer() then return end

            activator:SendLua( "achievements.EatBall()" )

            consumeCallback( self, activator )
        end
    end


    scripted_ents.Register( ENT, class )
end


registerBall( "steamball_steamsmug", "steam_balls/steamsmug.png", "Steam Smug" )

-- Steam Happy
registerBall(
    "steamball_steamhappy",
    "steam_balls/steamhappy.png",
    "Steam Happy",
    nil,
    function( _, activator )
        activator:EmitSound( "steam_balls/yippe.wav" )
        activator:SetHealth( activator:Health() + 10 )
    end
)

-- Steam Happy Blue
registerBall(
    "steamball_steamhappy_blue",
    "steam_balls/steamhappy_blue.png",
    "Steam Happy Blue",
    Sound( "items/battery_pickup.wav" ),
    function( _, activator )
        activator:SetArmor( activator:Armor() + 5 )
        activator:EmitSound( "items/battery_pickup.wav" )
    end
)

-- Steam Sad
registerBall(
    "steamball_steamsad",
    "steam_balls/steamsad.png",
    "Steam Sad",
    Sound( "player/death3.wav" ),
    function( ball, activator )
        activator:TakeDamage( 5, ball )
        activator:EmitSound( "player/death3.wav" )
    end
)

-- Steam Beatup
registerBall(
    "steamball_steambeatup",
    "steam_balls/steambeatup.png",
    "Steam Beatup",
    Sound( "Flesh.ImpactHard" ),
    function( ball, activator )
        activator:TakeDamage( math.random( 5, 25 ), ball )
        activator:EmitSound( "Flesh.ImpactHard" )
    end
)
