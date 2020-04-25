# Cycle Limit (`cycle_limit`)

Makes switching between inventory slots take time.

## About

Cycle Limit only depends on [`modlib`](https://github.com/appgurueu/cellestial/modlib). Code by Lars Mueller aka LMD or appguru(eu) and licensed under the MIT license.

Part of the Limit Series: [`item_limit`](https://github.com/appgurueu/item_limit), [`place_limit`](https://github.com/appgurueu/place_limit) and [`cycle_limit`](https://github.com/appgurueu/cycle_limit)

## Features

* When switching between inventory slots, the item you are switching to will be "hidden"
* A bar appears showing you the time left, and after it's over (or if you switch again) the hidden items reappear
* During switching you can only use your hand
* Hidden items are not lost if the server crashes

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

Configuration can be found under `<worldpath>/conf/cycle_limit.json`.

Default configuration:

```json
{
    "name": "Switching",
    "duration": 2,
    "color": "545AA7"
}
```

* `name` is the timer name
* `duration` is the time it takes to switch in seconds
* `color` is a hex color (but without `#`)