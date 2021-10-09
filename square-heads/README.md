# square-heads
_by @angrykoala_
A simple cooperative top-down shooter, loosely based on boxhead

## "Arquitecture"

* Addons: External Godot plugins
* Assets: Lovely music and images
* Autoload: Anything that goes into autoload (i.e singletons)
* Components: Reusable scenes to be used anywhere
* Entities: Game Domain-specific scenes (e.g. player, enemy...)
* Scenes: Main game scenes (e.g Menu, Main...) and top-level scripts
* Scripts: Any general scripts (good ol' classes)
* Services: General services to handle stuff (music, network...). To be loaded dynamically into the autoload services.gs (serviceLocator)

## Credits

* Gun Sounds by KonitaTutorials <https://opengameart.org/content/gun-sound-effects> CC-BY-SA 3.0
* [light_sprite.png](https://www.gdquest.com/tutorial/godot/2d/lighting-with-normal-maps/) by gdquest.com
