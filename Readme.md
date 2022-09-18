# Cycle Limit (`cycle_limit`)

Makes switching between inventory slots take time.

## About

Cycle Limit only depends on [`modlib`](https://github.com/appgurueu/modlib). Code by Lars Mueller aka LMD or appguru(eu) and licensed under the MIT license.

Part of the Limit Series: [`item_limit`](https://github.com/appgurueu/item_limit), [`place_limit`](https://github.com/appgurueu/place_limit) and [`cycle_limit`](https://github.com/appgurueu/cycle_limit)

## Features

* When switching between inventory slots, the item you are switching to will be "hidden"
* A bar appears showing you the time left, and after it's over (or if you switch again) the hidden items reappear
* During switching you can only use your hand
* Hidden items are not lost if the server crashes
* `cycle_limit` priv allows evasion
* Alternative mode works by granting/removing `interact`
  * To prevent players from having interact, revoke both `interact` and `interact_mods`

Known issues:

* The item is temporarily removed from the inventory
  * Can't be circumvented because else `get_wield_item` would return item that is being switched to
  * Accordingly, it can't be seen

## Screenshot

![Screenshot](screenshot.png)

### Links

* [GitHub](https://github.com/appgurueu/cycle_limit)
* [Discord](https://discordapp.com/invite/ysP74by)
* [ContentDB](https://content.minetest.net/packages/LMD/cycle_limit)
* [Minetest Forum](https://forum.minetest.net/viewtopic.php?f=9&t=24614)

## Configuration

<!--modlib:conf:2-->
### `color`

Hexadecimal RRGGBB color (without a leading `#`)

* Type: string
* Default: `545AA7`

### `duration`

Time it takes to switch slots in seconds

* Type: number
* Default: `2`
* &gt;= `0`

### `interact`

Whether the `interact` privilege should be revoked temporarily

* Type: boolean
* Default: `true`

### `name`

Timer text

* Type: string
* Default: `Switching`
<!--modlib:conf-->