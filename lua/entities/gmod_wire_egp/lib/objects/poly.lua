-- Author: Divran
local Obj = EGP:NewObject( "Poly" )
Obj.w = nil
Obj.h = nil
Obj.x = nil
Obj.y = nil
Obj.vertices = {}
Obj.verticesindex = "vertices"
Obj.Draw = function( self )
	if (self.a>0 and #self.vertices>2) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawPoly( self.vertices )
	end
end
Obj.Transmit = function( self )
	EGP.umsg.Char(#self.vertices)
	for i=1,#self.vertices do
		EGP.umsg.Short( self.vertices[i].x )
		EGP.umsg.Short( self.vertices[i].y )
		EGP.umsg.Short( self.vertices[i].u or 0 )
		EGP.umsg.Short( self.vertices[i].v or 0 )
	end
	EGP.umsg.Short( self.parent )
	EGP:SendMaterial( self )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	local nr = um:ReadChar()
	tbl.vertices = {}
	for i=1,nr do
		tbl.vertices[ #tbl.vertices+1 ] = { x = um:ReadShort(), y = um:ReadShort(), u = um:ReadShort(), v = um:ReadShort() }
	end
	tbl.parent = um:ReadShort()
	EGP:ReceiveMaterial( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end
Obj.DataStreamInfo = function( self )
	return { vertices = self.vertices, material = self.material, r = self.r, g = self.g, b = self.b, a = self.a, parent = self.parent }
end