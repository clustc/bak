local lfs = require("lfs")

local path = lfs.currentdir().."../../../trunk/trunk/sim/apphome/res/cn/image"

tb={}
function traversingRecur(path)
	for file in lfs.dir(path) do 
		if file ~= "." and file ~= ".." then
			local dir = path.."/"..file
			local attr = lfs.attributes(dir)
			local mode = attr.mode
			if mode == "directory" then
				traversingRecur(dir)
			elseif mode == "file" then
				if string.find(file,"%.PNG$") or string.find(file, "%.JPG$") then
					tb[file] = string.match(dir,"cn/image/.*")
				end
			end
		end
	end
end

traversingRecur(path)

local bSucceed = true
for k, v in pairs(tb) do 
	print(v)
	bSucceed = false
end

if bSucceed then
	print("succeed ~~ ")
end
