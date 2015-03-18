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
#include "Vector.h"

class Ball;
class Wall;
class RenderableSprite;

enum InputEventType {
    Began,
    Moved,
    Ended,
    Cancelled
};

struct Touch {
    void *identifier;
    Vector3 prev;
    Vector3 curr;
    
};

class Game
{
public:
    Game();
    void update(float dt);
    void handleInput(InputEventType type, const std::vector<Touch>& touches);
    ~Game();
    
    const std::vector<Ball*>& getBalls() { return _balls; }
    const std::vector<Wall*>& getGroundBodies() { return _groundBodies; }
    const std::vector<RenderableSprite*>& getUpcomingBallPreview() { return _upcomingPreview; }
private:
    void emitABall(const Vector3& direction, bool reactive);
    void updateProximity();
    void updateBallDrawData();

    std::vector<RenderableSprite*> _upcomingPreview;
    std::vector<std::string> _upcomingBalls;
    std::vector<Ball*> _balls;
    void* _trackedTouch = nullptr;
    Vector3 _trackedTouchStart;
    std::vector<Wall*> _groundBodies;
    b2World* world;
    TextureLoader* textureLoader;
};

#endif /* defined(__HelloOpenGL__Game__) */
