//
//  Game.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/25/14.
//
//

#include "Game.h"


#include "Ball.h"
#include "CC3Math.h"

#include <set>


// Construct a world object, which will hold and simulate the rigid bodies.

#define MAX_BALLS 30

#define BOTTOM_OF_SCREEN -6.0f
#define SCREEN_WIDTH 8.0f
#define SECONDS_BETWEEN_BALLS 0.5f
#define BALL_RADIUS 0.5f
#define GRAVITY -4.9f
float secondsSinceEmit = SECONDS_BETWEEN_BALLS;


static b2Body* createWall(b2World* world, float posX, float posY, float sizeX, float sizeY)
{
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(posX, posY);
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;
    
    // The extents are the half-widths of the box.
    groundBox.SetAsBox(sizeX, sizeY);
    
    // Add the ground fixture to the ground body.
    groundBody->CreateFixture(&groundBox, 0.0f);
    
    return groundBody;
}

Game::Game()
{
    textureLoader = new TextureLoader();
    
    world = new b2World(b2Vec2(0.0f, GRAVITY));

    groundBodies.push_back(createWall(world, 0.0f, BOTTOM_OF_SCREEN, 50.0f, 1.0f));
    groundBodies.push_back(createWall(world, -SCREEN_WIDTH/2.0f, 0.0f, 1.0f, 50.0f));
    groundBodies.push_back(createWall(world, SCREEN_WIDTH/2.0f, 0.0f, 1.0f, 50.0f));

}

Game::~Game()
{
    for (b2Body* body : groundBodies)
    {
        world->DestroyBody(body);
    }
    delete world;
    world = NULL;

    delete textureLoader;
}

#define NUM_TEXTURES 3
std::string textureNames[] = { "stone_icon.png","oil_icon.png","gold_icon.png","pyrocite_icon.png","wood_icon.png","steel_icon.png" };

void Game::emitABall(const Vector3& direction)
{
    std::string texture = textureNames[RandomUIntBelow(NUM_TEXTURES)];
    std::string type = texture; //one and the same for now, I guess?
    Vector3 pos = Vector3(0.0f, 4.0f, 0.0f);
    Ball* ball = Ball::ballFactory(world, pos, BALL_RADIUS, type, textureLoader, texture);
    ball->setVelocity(direction);
    _balls.push_back(ball);
}

void Game::updateBallDrawData()
{
    for (int i = 0; i < _balls.size(); i++)
    {
        _balls[i]->onUpdated();
    }
}

#define PROXIMITY 0.1f
#define PROXIMITY_COUNT 3
void Game::updateProximity()
{
    std::set<Ball*> toRemove;
    for (int i=0; i < _balls.size(); i++)
    {
        std::vector<Ball*> closeEnough;
        closeEnough.clear();
        for (int j=0; j < _balls.size(); j++)
        {
            //if (i == j) continue;
            
            float dist = distance(_balls[i]->getPosition(), _balls[j]->getPosition());
            float minDist = PROXIMITY + _balls[i]->getRadius() + _balls[j]->getRadius();
            if (dist < minDist && _balls[i]->getType() == _balls[j]->getType())
            {
                closeEnough.push_back(_balls[j]);
            }
        }
        if (closeEnough.size() >= PROXIMITY_COUNT)
        {
            //kill'em
            while (closeEnough.size())
            {
                toRemove.insert(closeEnough[0]);
                closeEnough.erase(closeEnough.begin());
            }
        }
    }

    for (std::vector<Ball*>::iterator iter = _balls.begin();
         iter != _balls.end(); )
    {
        if (toRemove.find(*iter) != toRemove.end())
        {
            Ball* ball = *iter;
            iter = _balls.erase(iter);
            Ball::ballDisposal(ball);
        }
        else
        {
            iter++;
        }
    }
}

void Game::handleInput(InputEventType type, const std::vector<Touch>& touches)
{
//    NSLog(@"HANDLING TOUCHES");
    for (Touch touch : touches)
    {
//        NSLog(@"touch: %3.3f %3.3f : %3.3f %3.3f", touch.curr.x(),touch.curr.y(),touch.prev.x(),touch.prev.y());
        
        switch (type) {
            case InputEventType::Began:
                NSLog(@"start");
                if (_trackedTouch == nullptr)
                {
                    NSLog(@"tracked");
                    _trackedTouch = touch.identifier;
                    _trackedTouchStart = touch.curr;
                }
                break;
            case InputEventType::Moved:
                break;
            case InputEventType::Ended:
            {
                NSLog(@"Ended");
                Vector3 impulse = _trackedTouchStart - touch.curr;
                if (impulse.lengthSq() >= 0.1f) {
                    NSLog(@"Shot");
                    impulse.setY(impulse.y() * -1.0f);
                    emitABall(impulse * 10.0f);
                }
            }
                //intentionall fallthrough
            case InputEventType::Cancelled: //intentionall fallthrough
                NSLog(@"untracked");
                _trackedTouch = nullptr;
            default:
                break;
        }
    }
}

void Game::update(float dt)
{
    //physics
    int32 velocityIterations = 6;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);

    //do we need to blow some up?
    updateProximity();
    
    //rendering data
    updateBallDrawData();

}




