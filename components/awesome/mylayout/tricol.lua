local pairs = pairs

local math = { min = math.min, max = math.max } 

local tricol = {}


tricol.name = "tricol"

function do_tricol(screen)
	local area = screen.workarea
	local maxColumns = 3

	local numColumns = math.min(maxColumns, #screen.clients)
	local targetWidth = area.width / numColumns
	local targetHeight = area.height
	local idx = 1
	for _, client in pairs(screen.clients) do
		local currentColumn = 0
		if numColumns == 3 then
			if idx == 1 then
				currentColumn = 1
			else
				currentColumn = 2 * (idx % 2)
			end
		elseif numColumns == 2 then
			if idx == 1 then
				currentColumn = 0
			else
				currentColumn = 1
			end
		elseif numColumns == 1 then
			currentColumn = 0
		end
		local clientOffsetX = currentColumn * targetWidth

		screen.geometries[client] = {
			x = area.x + clientOffsetX,
			y = area.y,
			width = targetWidth,
			height = targetHeight
		}
		idx = idx + 1
	end
end

function tricol.arrange(screen)
	return do_tricol(screen)
end

return tricol
