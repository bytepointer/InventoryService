## HOW TO USE

- put `InventoryService.luau` in ServerScriptService and your childrens in `SubModules` folder
- put `InventoryModules.luau` in `ServerScriptService`
- Create the remotes events
- Put `itemsList.luau` in `ReplicatedStorage/Items`

You can download the rbxl file to test the service.

## FEATURES

- Get Inventory;
- Has Item;
- Add Item;
- Remove Item;
- Change Item Position;
- Drop Item;
- Split Item

## Methods

### Get Inventory

Used to get the inventory in database.

```
InventoryService.getInventory(player)
```
- player = Player Instance

### Has Item

```
local item = {
     id: 3,
     amount: 1
}

InventoryService.hasItem(player, item)
```
 
- player = Player Instance

### Add Item

Add item to a player's inventory.

```
local item = {
   id = 4,
   amount = 2
}

InventoryService:AddItem(player, item)
```

- player = Player Instance

### Remove Inventory Item By Slot

Remove a player's item using slot and amount.

```
local item = {
    slot: 4,
    amount: 2
}

InventoryService:RemoveItem(player, item)
```

- player = Player Instance


### Remove Inventory Item By Id

Remove a player's item using item ID and amount.

```
local item = {
    id: 4,
    amount: 2
}

InventoryService:RemoveItem(player, item)
```

- player = Player Instance

### Change Item Position in Inventory

Change a item's slot.

```
local sourceSlot = 1 -- origin slot that will be moved

let targetSlot = 2 -- target slot that was selected by user to change with sourceslot

InventoryService:ChangeInventory(player, sourceSlot, targetSlot)
```

- player = Player Instance

### Drop Item On The Ground

Drop a item on the ground using slot number.

```
local itemSlot = 4

InventoryService:Drop(player, itemSlot)
```

- player = Player Instance

### Split Item

Split items using their slot and new amount.

```
local item = {
    slot: 4,
    amount: 2
}

InventoryService:Split(player, item) -- splits 2 items
```

- player = Player Instance

## Save Data

Save cache data to the database.

```

game.Players.
Inventory:SaveData(player)
```

- player = Player Instance
