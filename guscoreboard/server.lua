mainInfo = {}
lib.callback.register('guscoreboard:getPlayerInfo', function()
      local roleColor = {
        ["Network Founder"] = "#fffa00",
        ["Head Developer"] = "#ff9900",
        ["Staff Director"] = "#276792",
        ["Asst. Staff Director"] = "#276792",
        ["LEO Director"] = "#276792",
        ["Asst. LEO Director"] = "#276792",
        ["Civilian Director"] = "#276792",
        ["Asst. Civilian Director"] = "#276792",
        ["Sr. Admin"] = "#d8106a",
        ["Admin"] = "#ff00d1",
        ["Mod"] = "#ff0004",
        ["KCSO"] = "#03722f",
        ["Certified Civilian"] = "#3D99D9",
        ["Civilian"] = "#95A5A6",
      }
      local tbl = {}
      for _, i in pairs(GetActivePlayers()) do
        local hRole = getHighestRole(i)
        table.insert(tbl, {job=hRole, ping=GetPlayerPing(i), id=i, avatar=getPlayerAvatar(i), nickname=getNickname(i), steam=GetPlayerName(i), color=roleColor[hRole]})
      end
    return tbl
end)
RegisterServerEvent("guscoreboard:UpdateTBL")
AddEventHandler("guscoreboard:UpdateTBL", function(src)
  local lic = ExtractIdentifiers(src).license
  mainInfo[lic] = {roles=exports.gupermissions:GetDiscordRoles(src), avatar=exports.gupermissions:GetDiscordAvatar(src), nickname=exports.gupermissions:GetDiscordNickname(src)}
end)

function getNickname(src)
  local lic = ExtractIdentifiers(src).license
  return mainInfo[lic].nickname
end

function getPlayerAvatar(src)
  local lic = ExtractIdentifiers(src).license
  return mainInfo[lic].avatar
end

function getHighestRole(src)
  local role = "Civilian"
  local tbl = {
    ["760161015211229234"] = "Network Founder",
    ["807775125713321985"] = "Head Developer",
    ["807761960921071666"] = "Staff Director",
    ["807762708832190495"] = "Asst. Staff Director",
    ["807515892379942933"] = "LEO Director",
    ["807768680145485835"] = "Asst. LEO Director",
    ["807768975030091807"] = "Civilian Director",
    ["807769235823919115"] = "Asst. Civilian Director",
    ["807770185184444466"] = "Sr. Admin",
    ["807763215001190400"] = "Admin",
    ["807763160354390056"] = "Mod",
    ["807762869532885033"] = "KCSO",
    ["807778114922348564"] = "Certified Civilian",
    ["807762603384111114"] = "Civilian",
  }
  local lic = ExtractIdentifiers(src).license
  if not mainInfo[lic] then
    mainInfo[lic] = {roles=exports.gupermissions:GetDiscordRoles(src), avatar=exports.gupermissions:GetDiscordAvatar(src), nickname=exports.gupermissions:GetDiscordNickname(src)}
  end
  local roles = formatTable(mainInfo[lic].roles)
  if roles then
    if roles["760161015211229234"] then
      return tbl["760161015211229234"]
    elseif roles["807775125713321985"] then
        return tbl["807775125713321985"]
    elseif roles["807761960921071666"] then
        return tbl["807761960921071666"]
    elseif roles["807762708832190495"] then
        return tbl["807762708832190495"]
    elseif roles["807515892379942933"] then
        return tbl["807515892379942933"]
    elseif roles["807768680145485835"] then
        return tbl["807768680145485835"]
    elseif roles["807768975030091807"] then
        return tbl["807768975030091807"]
    elseif roles["807769235823919115"] then
        return tbl["807769235823919115"]
    elseif roles["807770185184444466"] then
        return tbl["807770185184444466"]
    elseif roles["807763215001190400"] then
        return tbl["807763215001190400"]
    elseif roles["807763160354390056"] then
        return tbl["807763160354390056"]
    elseif roles["807762869532885033"] then
        return tbl["807762869532885033"]
    elseif roles["807778114922348564"] then
        return tbl["807778114922348564"]
    elseif roles["807762603384111114"] then
        return tbl["807762603384111114"]
    end
  end
  return role
end
function formatTable(tbl)
  local a = json.decode("{" .. json.encode(tbl):gsub('%"([^"]+)%"', '"%1":true'):sub(2, -2) .. "}")
  return a
end
function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = string.gsub(id, "license2:", "")
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end