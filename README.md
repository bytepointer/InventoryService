## HOW TO USE

- put `InventoryService.luau` in ServerScriptService and your childrens in `SubModules` folder
- put `InventoryModules.luau` in `ServerScriptService`
- Create the remotes events
- Put `itemsList.luau` in `ReplicatedStorage/Items`

You can download the rbxl file to test the service.

## Methods

### Get Inventory

```
InventoryService.getInventory(player)
```
- player = Player Instance

### Has Item By Id

```
local item = {
     id: 3,
     amount: 1
}

InventoryService.hasItem(player, item)
```
 
- player = Player Instance

### Add Item

```
local item = {
   id = 4,
   amount = 2
}

InventoryService:AddItem(player, item)
```

- player = Player Instance

### Remove Inventory Item By Slot

```
local item = {
    slot: 4,
    amount: 2
}

InventoryService:RemoveItem(player, item)
```

- player = Player Instance


### Remove Inventory Item By Id

```
local item = {
    id: 4,
    amount: 2
}

InventoryService:RemoveItem(player, item)
```

- player = Player Instance

### Change Item Position in Inventory

```
local sourceSlot = 1 -- origin slot that will be moved

let targetSlot = 2 -- target slot that was selected by user to change with sourceslot

InventoryService:ChangeInventory(player, sourceSlot, targetSlot)
```

- player = Player Instance

### Drop Item On The Ground

```
local itemSlot = 4

InventoryService:Drop(player, itemSlot)
```

- player = Player Instance

### Split Item

```
local item = {
    id: 4,
    amount: 2
}

InventoryService:RemoveItem(player, item) -- splits 2 items
```

- player = Player Instance

## Save Data

```
Inventory:SaveData(player)
```

- player = Player Instance
