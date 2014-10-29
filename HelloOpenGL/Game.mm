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

void Game::emitBalls(float dt)
{
    if (balls.size() < MAX_BALLS && secondsSinceEmit >= SECONDS_BETWEEN_BALLS)
    {
        secondsSinceEmit = 0.0f;
        Ball* ball = new Ball(world, BALL_RADIUS, std::string("item_powerup_fish.png"),textureLoader);
        ball->allocBuffers();
        ball->setupVBO();
        ball->setPosition(Vector3(RandomDoubleBetween(0.0f, SCREEN_WIDTH)-(SCREEN_WIDTH/2.0f), 5.0f, 0.0f));
        balls.push_back(ball);
    }
    secondsSinceEmit += dt;
}

void Game::updateBallDrawData()
{
    for (int i = 0; i < balls.size(); i++)
    {
        balls[i]->onUpdated();
    }
}

#define PROXIMITY 0.1f
#define PROXIMITY_COUNT 3
void Game::updateProximity()
{
    std::set<Ball*> toRemove;
    for (int i=0; i < balls.size(); i++)
    {
        std::vector<Ball*> closeEnough;
        closeEnough.clear();
        for (int j=0; j < balls.size(); j++)
        {
            //if (i == j) continue;
            
            float dist = distance(balls[i]->getPosition(), balls[j]->getPosition());
            float minDist = PROXIMITY + balls[i]->getRadius() + balls[j]->getRadius();
            if (dist < minDist)
            {
                closeEnough.push_back(balls[j]);
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

    for (std::vector<Ball*>::iterator iter = balls.begin();
         iter != balls.end(); )
    {
        if (toRemove.find(*iter) != toRemove.end())
        {
            Ball* ball = *iter;
            iter = balls.erase(iter);
            delete ball;
        }
        else
        {
            iter++;
        }
    }
}

void Game::update(float dt)
{
    //this won't happen in real lyphe
    emitBalls(dt);
    
    //physics
    int32 velocityIterations = 6;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);

    //do we need to blow some up?
    updateProximity();
    
    //rendering data
    updateBallDrawData();

}




