
EFFECT.Mat = Material( "effects/spark" )

function EFFECT:Init( data )

	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	
	self.Dir = self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.TracerTime = math.min( 1, self.StartPos:Distance( self.EndPos ) / 15000 )
	self.Length = math.Rand( 0.1, 0.15 )

	-- Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime

end

function EFFECT:Think()

	if CurTime() > self.DieTime then
		return false
	end

	return true

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5

	render.SetMaterial( self.Mat )

	local sinWave = math.sin( fDelta * math.pi )

	render.DrawBeam( self.EndPos - self.Dir * ( fDelta - sinWave * self.Length ),
		self.EndPos - self.Dir * ( fDelta + sinWave * self.Length ),
		3, 1, 0, Color( 255, 255, 255, 255 ) )

end
