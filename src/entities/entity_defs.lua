--[[ definitions of certain parameters for the objects]]


ENTITY_DEFS = {['player'] = {['speed'] = PLAYER_SPEED,
                              ['width'] = TILE_SIZE,
                              ['height'] = TILE_SIZE,
                              ['collidable'] = true,
                              ['animated'] = true,
                              ['texture'] = 'characters',
                              ['startingAnimation'] = 'idle-down',
                              ['animations'] = {['walk-down'] = {frames = {1, 2, 3, 2},
                                                                interval = PLAYER_ANIMATION_INTERVAL},
                                                              
                                              ['walk-left'] = {frames = {16, 17, 18, 17},
                                                              interval = PLAYER_ANIMATION_INTERVAL},
                                                            
                                              ['walk-right'] = {frames = {31, 32, 33, 32},
                                                              interval = PLAYER_ANIMATION_INTERVAL},
                                                            
                                              ['walk-up'] = {frames = {46, 47, 48, 47},
                                                              interval = PLAYER_ANIMATION_INTERVAL},
                                              
                                              ['idle-down'] = {frames = {2},
                                                                interval = 1},
                                              
                                              ['idle-left'] = {frames = {17},
                                                              interval = 1},
                                              
                                              ['idle-right'] = {frames = {32},
                                                                interval = 1},
                                                              
                                              ['idle-up'] = {frames = {47},
                                                                interval = 1}
                                                              
                                                            
                              }
                              },
                              
                              
                ['chest'] = {['width'] = TILE_SIZE,
                            ['height'] = TILE_SIZE,
                            ['collidable'] = true,
                            ['animated'] = false,
                            ['texture'] = 'chests',
                            ['id'] = 1
                            }
  
  }