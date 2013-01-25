Spell Panels
============

Spell Panels is a World of Warcraft AddOn that shows kgPanels (or other frames) when you cast spells.

It also allows you to have the panels fade out after a certain amount of time.

## Usage
To intitialise a frame as a Spell Panel, use the `SpellPanel_OnLoad` function:
```
SpellPanel_OnLoad(frame, spell [, delayTime [, fade [, fadeTime ]]])
```

If using kgPanels, call this in the OnLoad script.

`SpellPanel_OnLoad` takes the following arguments:
* `frame` is the frame object to make into a Spell Panel
* `spell` is either a spell name (string) or spellID (number). This is used to control when the panel shows.
* `delayTime` is the time in seconds between the panel being shown and the panel being hidden or faded out (explained [below](#hiding-and-fading) in further detail). If not specified, the default value defined in core.lua will be used.
* `fade` is set as the [`frame.fade`](#hiding-and-fading) field. If not specified, defaults to true.
* `fadeTime` is the time in seconds that it takes the frame to fade out. If not specified, the default value defined in core.lua will be used. 

### Hiding and Fading
The hiding/fading behaviour is controlled by the `frame.fade` field.

If this field is `true` (or true-equivalent), the frame will be faded out when its delay is finished or another panel is shown.

If this field is `false` or `nil`, the frame will be immediately hidden instead.

## Examples
These examples assume that `self` is a reference to your frame (which it will be in kgPanel OnLoad scripts).


To intialise a panel for Arcane Shot using the default settings, simply put either of these in your OnLoad script (or equivalent):
```
SpellPanel_OnLoad(self, "Arcane Shot")
```
```
SpellPanel_OnLoad(self, 3044)
```

To initialise a panel for Frostbolt using a 5 second delay and a 2 second fade, use either of these:
```
SpellPanel_OnLoad(self, "Frostbolt", 5, true, 2)
```
```
SpellPanel_OnLoad(self, 116, 5, true, 2)
```

To intitialise a panel for Heart Strike using a 10 second delay and an instant hide, use either of these:
```
SpellPanel_OnLoad(self, "Heart Strike", 10, false)
```
```
SpellPanel_OnLoad(self, 117, 10, false)
```
