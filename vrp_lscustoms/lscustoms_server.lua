
local lscustoms = class("lscustoms", vRP.Extension)

tbl = {
[1] = {locked = false, player = nil},
[2] = {locked = false, player = nil},
[3] = {locked = false, player = nil},
[4] = {locked = false, player = nil},
[5] = {locked = false, player = nil},
[6] = {locked = false, player = nil},
}

function lscustoms:__construct()
  vRP.Extension.__construct(self)
end

lscustoms.event = {}

function lscustoms.event:playerLeave(user)
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				self.remote._lockGarage(-1,tbl)
			end
		end
	end
end


lscustoms.tunnel = {}

function lscustoms.tunnel:lockGarage_server(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	self.remote._lockGarage(-1,tbl)
end

function lscustoms.tunnel:getGarageInfo()
	self.remote._lockGarage(-1,tbl)
end

function lscustoms.tunnel:playerDropped()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end

function lscustoms.tunnel:LSC_buttonSelected_S(name, button)
	local user = vRP.users_by_source[source] 
	cfg_bank = true
	if button.purchased == true then
		return true
	else 
		if button.price and cfg_bank == true then
			if button.price >= 0 and user:getBank() >= button.price then	
				self.remote._LSC_buttonSelected(user.source,name, button, true)
				user:setBank(user:getBank()-button.price)
				user:giveWallet(button.price)
			else
			self.remote._LSC_buttonSelected(user.source,name, button, false)
			end
		elseif button.price and cfg_bank == false then 
			if button.price >= 0 and user:getWallet() >= button.price then	
				self.remote._LSC_buttonSelected(user.source,name, button, true)
				user:setWallet(user:getWallet()-button.price)
			else
			self.remote._LSC_buttonSelected(user.source,name, button, false)
			end
		end
	end
end


function lscustoms.tunnel:LSC_finished(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	local color 			= veh.color
	local extracolor 		= veh.extracolor
	local neon 				= veh.neon
	local neoncolor 		= veh.neoncolor
	local smokecolor 		= veh.smokecolor
	local plateindex 		= veh.plateindex
	local windowtint 		= veh.windowtint
	local wheeltype 		= veh.wheeltype
	local bulletProofTyres  = veh.bulletProofTyres
end


function lscustoms.tunnel:lscustom_doPayment(price)
	local user = vRP.users_by_source[source]
	if user:tryPayment(price) then

		self.remote._lscustom_sayPayment(user.source,2)		
	else
		self.remote._lscustom_sayPayment(user.source,3)

	end	
end

vRP:registerExtension(lscustoms)
