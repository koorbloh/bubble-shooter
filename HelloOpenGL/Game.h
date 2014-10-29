//
//  Game.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/25/14.
//
//

#ifndef __HelloOpenGL__Game__
#define __HelloOpenGL__Game__

#include <stdio.h>
#include <vector>
#include <Box2D/Box2D.h>
#include "TextureLoader.h"

class Ball;

class Game
{
public:
    Game();
    void update(float dt);
    ~Game();
    
    std::vector<Ball*>& getBalls() { return balls; }
private:
    void emitBalls(float dt);
    void updateProximity();
    void updateBallDrawData();
    
    std::vector<Ball*> balls;    
    std::vector<b2Body*> groundBodies;
    b2World* world;
    TextureLoader* textureLoader;
};

#endif /* defined(__HelloOpenGL__Game__) */
