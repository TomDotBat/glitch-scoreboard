
glitchboard_config = {}

glitchboard_config.backgroundCol = Color(0,0,0,210)

glitchboard_config.servername = "Glitch Fire DarkRP"
glitchboard_config.serveraddress = "darkrp.glitchfire.com"
glitchboard_config.isadmin = function(ply)
	return !(ply:IsUserGroup("user") or ply:IsUserGroup("member") or ply:IsUserGroup("donator"))
end