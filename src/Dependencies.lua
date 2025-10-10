--all the lua files used

--libraries
Timer = require 'lib/knife/timer'
push = require 'lib/push'
sti = require 'lib/sti' -- Simple Tiled Implementation. 
Class = require 'lib/class'



require 'lib/util'

require 'src/Animation'
require 'src/constants'
require 'src/entities/Entity'
require 'src/entities/entity_defs'

require 'src/states/StateMachine'
require 'src/states/BaseState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityMoveState'

require 'src/world/Tile'
require 'src/world/Tile_defs'
require 'src/world/Tilemap'