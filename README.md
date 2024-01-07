# Ro-Lottery | Version - 1.0.0

## 中文简介/Chinese Language
**这个模块有什么用？   
为市面上主流的数据结构提供取决于权重的抽奖算法**
### **脚本功能：**
* **支持三种不同数据结构的抽奖算法**
* **模拟真实游戏中的抽奖**
* **获取抽奖算法的理想概率**

## 英文简介/English Language
**What is the use of this module?    
Providing weight-dependent lottery algorithms for the dominant data structures on the roblox**
### **Script Feature:**
* **Lottery algorithms supporting three different data structures**
* **Simulates a lottery in a real game**
* **Getting the ideal probability of a lottery algorithm**

## Docs / Api
### Main Functions
```lua
RoLottery:ByRarity(ItemTable , RarityTable)

--[[
Explain:
ENG: Items of the same rarity will have the combined weights treated as one weight, and then a random value will be returned from the selected rarity weights
CN: 相同稀有度的物品将合并权重视为一个权重，再从被选择的稀有度权重中随机返回一个值
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
--]]
```
```lua
RoLottery:ByIndexWeight(ItemTable)

--[[
Explain:
ENG: The corresponding weights for each index will be calculated separately
CN: 每个索引的对应权重将单独计算
--<Template>--
ItemTable = {
	[Index] = {
		Weight = WeightValue
	}
}
--]]
```
```lua
RoLottery:ByDictionaryWeight(ItemTable)

--[[
Explain:
ENG: works in much the same way as ByIndexWeight, except that the ItemTable and return value will not have the Index
CN: 与ByIndexWeight的工作方式基本相同，但ItemTable和返回值中将不会带有Index
--<Template>--
ItemTable = {
	{ "RandomValue", WeightValue },
	{ "RandomValue2", WeightValue },
	{ "RandomValue3", WeightValue },
}
--]]
```
### Simulation Functions
```lua
RoLottery:SimulateByRarity(ItemTable, RarityTable, TestTimes)
```
```lua
RoLottery:SimulateByIndexWeight(ItemTable, TestTimes)
```
```lua
RoLottery:SimulateByDictionaryWeight(ItemTable, TestTimes)
```
### Info Functions
```lua
RoLottery:GetProbabilityByRarity(ItemTable, RarityTable)
```
```lua
RoLottery:GetProbabilityByIndexWeight(ItemTable)
```
```lua
RoLottery:GetProbabilityByDictionaryWeight(ItemTable)
```
### **Made By Aidaren / 廾阁 / 究极挨打人**
### **微信: AidarenADR**
### **Discord: aidasense**
