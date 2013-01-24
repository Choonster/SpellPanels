Spell Panels
============

Spell Panels is a World of Warcraft AddOn that shows kgPanels (or other frames) when you cast spells.

It also allows you to have the panels fade out after a certain amount of time.

## Usage <a id="usage" href="#usage">#</a>
To intitialise a frame as a Spell Panel, use the `SpellPanel_OnLoad` function:
```
SpellPanel_OnLoad(frame, spell [, delayTime [, fadeTime]])
```

If using kgPanels, call this in the OnLoad script.

`SpellPanel_OnLoad` takes the following arguments:
* `frame` is the frame object to make into a Spell Panel
* `spell` is either a spell name (string) or spellID (number). This is used to control when the panel shows.
* `delayTime` is the time in seconds between the panel being shown and the panel being hidden or faded out (explained in further detail [below](#hidefade)). If not specified, the default value defined in core.lua will be used. 
* `fadeTime` is the time in seconds that it takes the frame to fade out. If not specified, the default value defined in core.lua will be used. 

### Hiding and Fading <a id="hidefade" href="#hidefade">#</a>
The hiding/fading behaviour is controlled by the `frame.fade` field.

If this field is `true` (or true-equivalent), the frame will be faded out when its delay is finished or another panel is shown.

If this field is `false` or `nil`, the frame will be immediately hidden instead.