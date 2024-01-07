--# selene: allow(unused_variable , shadowing , manual_table_clone , parenthese_conditions , multiple_statements , deprecated , incorrect_standard_library_use , roblox_incorrect_color3_new_bounds , empty_if)
--[[
Made By Aidaren / 廾阁 / 究极挨打人
:v

Version - 1.0.0

ContactMe:
WeChat: AidarenADR
Discord: aidasense
--]]

local RoLottery = {}
local RandomGenerator = Random.new()

----------<Main Functions>----------

--[[
	ENG: Items of the same rarity will have the combined weights treated as one weight, and then a random value will be returned from the selected rarity weights

	CN: 相同稀有度的物品将合并权重视为一个权重，再从被选择的稀有度权重中随机返回一个值

	```lua
	--<Template>--
	ItemTable = {
		[Index] = {
 	       RarityName = RarityName
  	  }
	}
	RarityTable = {
		"RarityName" = {
			Weight = X
		}
	}
	```
--]]
function RoLottery:ByRarity(ItemTable, RarityTable)
	--<创建一个按权重分类的表>--
	local CategorizedKeys = {}

	for _, ItemInfo in pairs(ItemTable) do
		local WeightForItem = RarityTable[ItemInfo.RarityName].Weight
		--<创建按权重分类的表>--
		if not CategorizedKeys[WeightForItem] then
			CategorizedKeys[WeightForItem] = {}
		end
		--<将物品添加进权重分类表中>--
		table.insert(CategorizedKeys[WeightForItem], ItemInfo.UUID)
	end

	--<根据物品创建一个新的稀有度权重表>--
	local NewRarityTable = {}
	for _, ItemInfo in ItemTable do
		if not NewRarityTable[ItemInfo.RarityName] then
			NewRarityTable[ItemInfo.RarityName] = {
				Weight = RarityTable[ItemInfo.RarityName].Weight,
			}
		end
	end
	--?可能的问题：找不到物品对应的权重--

	--<根据权重随机选择一个分类>--k
	local TotalWeight = 0
	for _, RarityInfo in pairs(NewRarityTable) do
		TotalWeight = TotalWeight + RarityInfo.Weight
	end

	--<获取随机权重>--
	local RandomWeight = RandomGenerator:NextNumber() * TotalWeight
	local AccumulatedWeight = 0
	local SelectedWeight = nil
	for _, RarityInfo in pairs(NewRarityTable) do
		AccumulatedWeight = AccumulatedWeight + RarityInfo.Weight
		if RandomWeight <= AccumulatedWeight then
			SelectedWeight = RarityInfo.Weight
			break
		end
	end

	local KeysOfSelectedWeight = CategorizedKeys[SelectedWeight]
	local RandomIndex = math.random(1, #KeysOfSelectedWeight)
	return KeysOfSelectedWeight[RandomIndex]
end

--[[
	ENG: The corresponding weights for each index will be calculated separately

	CN: 每个索引的对应权重将单独计算

	```lua
	--<Template>--
	ItemTable = {
		[Index] = {
 	       Weight = WeightValue
  	  }
	}
	```
--]]
function RoLottery:ByIndexWeight(ItemTable): (table, number)
	--<获取总权重>--
	local TotalWeight = 0
	for Index, ItemInfo in ItemTable do
		TotalWeight += ItemInfo["Weight"]
	end

	--<获取随机权重>--
	local RandomWeight = RandomGenerator:NextNumber() * TotalWeight

	--<根据权重随机选择一个项目>--
	local AccumulatedWeight = 0
	for Index, ItemInfo in ItemTable do
		AccumulatedWeight = AccumulatedWeight + ItemInfo["Weight"]
		if RandomWeight <= AccumulatedWeight then
			return ItemInfo, Index
		end
	end
end

--[[
	ENG: works in much the same way as ByIndexWeight, except that the ItemTable and return value will not have the Index

	CN: 与ByIndexWeight的工作方式基本相同，但ItemTable和返回值中将不会带有Index

	```lua
	--<Template>--
	ItemTable = {
		{ "RandomValue", WeightValue },
		{ "RandomValue2", WeightValue},
		{ "RandomValue3", WeightValue  },
	}
	```
--]]
function RoLottery:ByDictionaryWeight(ItemTable)
	local ElementTable = ItemTable

	--<如果只有一个元素，则直接返回该元素>--
	if #ElementTable < 2 then
		return ElementTable[1][1]
	end

	--<计算总权重>--
	local TotalWeight = 0
	for _, Element in ipairs(ElementTable) do
		TotalWeight = TotalWeight + Element[2]
	end

	--<生成一个随机数>--
	local RandomWeight = RandomGenerator:NextNumber() * TotalWeight

	--<根据随机数选择一个元素>--
	local accumulatedWeight = 0
	for _, item in ipairs(ItemTable) do
		accumulatedWeight = accumulatedWeight + item[2]
		if RandomWeight <= accumulatedWeight then
			return item[1]
		end
	end
end
----------<Simulation Functions>----------

function RoLottery:SimulateByRarity(ItemTable, RarityTable, TestTimes)
	--<测试次数>--
	TestTimes = TestTimes or 100000

	--<模拟抽奖>--
	local function SimulateDraws()
		local ResultTable = {}
		for i = 1, TestTimes do
			local result = self:ByRarity(ItemTable, RarityTable)
			ResultTable[result] = (ResultTable[result] or 0) + 1
		end
		return ResultTable
	end

	--<获取概率表>--
	local ResultTable = SimulateDraws()
	local Probabilities = {}
	for ItemName, RolledTimes in pairs(ResultTable) do
		Probabilities[ItemName] = RolledTimes / TestTimes
	end

	--<输出概率>--
	for ItemName, Probability in pairs(Probabilities) do
		print(ItemName, string.format("%.3f%%", Probability * 100), ResultTable[ItemName] .. " in " .. TestTimes)
	end
end

function RoLottery:SimulateByIndexWeight(ItemTable, TestTimes)
	--<测试次数>--
	TestTimes = TestTimes or 100000

	--<模拟抽奖>--
	local function SimulateDraws()
		local ResultTable = {}
		for i = 1, TestTimes do
			local result = self:ByIndexWeight(ItemTable)
			ResultTable[result] = (ResultTable[result] or 0) + 1
		end
		return ResultTable
	end

	--<获取概率表>--
	local ResultTable = SimulateDraws()
	local Probabilities = {}
	for ItemName, RolledTimes in pairs(ResultTable) do
		Probabilities[ItemName] = RolledTimes / TestTimes
	end

	--<输出概率>--
	for ItemName, Probability in pairs(Probabilities) do
		print(ItemName, string.format("%.3f%%", Probability * 100), ResultTable[ItemName] .. " in " .. TestTimes)
	end
end

function RoLottery:SimulateByDictionaryWeight(ItemTable, TestTimes)
	--<测试次数>--
	TestTimes = TestTimes or 100000

	--<模拟抽奖>--
	local function SimulateDraws()
		local ResultTable = {}
		for i = 1, TestTimes do
			local result = self:ByDictionaryWeight(ItemTable)
			ResultTable[result] = (ResultTable[result] or 0) + 1
		end
		return ResultTable
	end

	--<获取概率表>--
	local ResultTable = SimulateDraws()
	local Probabilities = {}
	for ItemName, RolledTimes in pairs(ResultTable) do
		Probabilities[ItemName] = RolledTimes / TestTimes
	end

	--<输出概率>--
	for ItemName, Probability in pairs(Probabilities) do
		print(ItemName, string.format("%.3f%%", Probability * 100), ResultTable[ItemName] .. " in " .. TestTimes)
	end
end

----------<Info Functions>----------

function RoLottery:GetProbabilityByRarity(ItemTable, RarityTable)
	--<创建一个按权重分类的表>--
	local CategorizedKeys = {}

	for _, ItemInfo in pairs(ItemTable) do
		local WeightForItem = RarityTable[ItemInfo.RarityName].Weight
		--<创建按权重分类的表>--
		if not CategorizedKeys[WeightForItem] then
			CategorizedKeys[WeightForItem] = {}
		end
		--<将物品添加进权重分类表中>--
		table.insert(CategorizedKeys[WeightForItem], ItemInfo.UUID)
	end

	--<根据物品创建一个新的稀有度权重表>--
	local NewRarityTable = {}
	for _, ItemInfo in ItemTable do
		if not NewRarityTable[ItemInfo.RarityName] then
			NewRarityTable[ItemInfo.RarityName] = {
				Weight = RarityTable[ItemInfo.RarityName].Weight,
			}
		end
	end
	--?可能的问题：找不到物品对应的权重--

	--<根据权重随机选择一个分类>--k
	local TotalWeight = 0
	for _, RarityInfo in pairs(NewRarityTable) do
		TotalWeight = TotalWeight + RarityInfo.Weight
	end

	for Name, Stats in NewRarityTable do
		print("Rarity: " .. Name, string.format("%.8f%%", Stats.Weight / TotalWeight * 100))
	end
end

function RoLottery:GetProbabilityByIndexWeight(ItemTable)
	--<获取总权重>--
	local TotalWeight = 0
	for Index, ItemInfo in ItemTable do
		TotalWeight += ItemInfo["Weight"]
	end

	--<获取随机权重>--
	local RandomWeight = RandomGenerator:NextNumber() * TotalWeight

	for Index, Stats in ItemTable do
		print("Index: " .. Index, string.format("%.8f%%", Stats.Weight / TotalWeight * 100))
	end
end

function RoLottery:GetProbabilityByDictionaryWeight(ItemTable)
	local ElementTable = ItemTable

	--<如果只有一个元素，则直接返回该元素>--
	if #ElementTable < 2 then
		return ElementTable[1][1]
	end

	--<计算总权重>--
	local TotalWeight = 0
	for _, Element in ipairs(ElementTable) do
		TotalWeight = TotalWeight + Element[2]
	end

	--<生成一个随机数>--
	local RandomWeight = RandomGenerator:NextNumber() * TotalWeight

	for Index, Element in ipairs(ElementTable) do
		print("Item: " .. Element[1], string.format("%.8f%%", Element[2] / TotalWeight * 100))
	end
end

return RoLottery
