//
//  Game.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/25/14.
//
//

#include "Game.h"


#include "Ball.h"
#include "Wall.h"
#include "CC3Math.h"
#include "Missions.h"
#include <set>


// Construct a world object, which will hold and simulate the rigid bodies.

#define MAX_BALLS 30

#define BOTTOM_OF_SCREEN -6.0f
#define SCREEN_WIDTH 8.0f
#define SECONDS_BETWEEN_BALLS 0.5f
#define BALL_RADIUS 0.5f
#define GRAVITY -4.9f
float secondsSinceEmit = SECONDS_BETWEEN_BALLS;

#define NUM_TEXTURES 5
std::string textureNames[] = { "stone_icon.png","oil_icon.png","gold_icon.png","pyrocite_icon.png","wood_icon.png","steel_icon.png" };

Game::Game()
{
    textureLoader = new TextureLoader();
    world = new b2World(b2Vec2(0.0f, GRAVITY));
    _groundBodies.push_back(Wall::wallFactory(world, Vector3(0.0f, BOTTOM_OF_SCREEN + 1.0f, 0.0f),
                                              Vector3(50.0f, 1.0f, 0.0f),
                                              textureLoader, "stone_icon.png"));
    _groundBodies.push_back(Wall::wallFactory(world, Vector3(-SCREEN_WIDTH/2.0f + 1.0f, 0.0f, 0.0f),
                                              Vector3(1.0f, 50.0f, 0.0f),
                                              textureLoader, "stone_icon.png"));
    _groundBodies.push_back(Wall::wallFactory(world, Vector3(SCREEN_WIDTH/2.0f, 0.0f, 0.0f),
                                              Vector3(1.0f, 50.0f, 0.0f),
                                              textureLoader, "stone_icon.png"));
    
    
    Vector3 previewPosition = Vector3(-SCREEN_WIDTH/2.0f + 1, 4.0f, 0.0f);
    for (int i = 0; i < 150; i++)
    {
        std::string type = textureNames[RandomUIntBelow(NUM_TEXTURES)];
        _upcomingBalls.push_back(type);
        
        RenderableSprite* preview = new RenderableSprite();
        preview->allocBuffers();
        preview->setupVBO();
        preview->updatePosition(previewPosition, BALL_RADIUS);
        preview->loadTexture(type, textureLoader);
        preview->updateVBO();
        
        _upcomingPreview.push_back(preview);
        
        previewPosition.setY(previewPosition.y() - 1.0f);
    }
    
    for (int i = 0; i < 30; i++)
    {
        emitABall(Vector3(RandomFloatBetween(10.0f, 12.0f), RandomFloatBetween(-1.0f, 0.0f), 0.0f), false);
    }

}

Game::~Game()
{
    for (Wall* wall : _groundBodies)
    {
        Wall::wallDisposal(wall);
    }
    delete world;
    world = NULL;

    delete textureLoader;
}


void Game::emitABall(const Vector3& direction, bool reactive)
{
    if (_upcomingBalls.size() > 0)
    {
        std::string type = _upcomingBalls.front();
        _upcomingBalls.erase(_upcomingBalls.begin());
        RenderableSprite* sprite = _upcomingPreview.front();
        delete sprite;
        _upcomingPreview.erase(_upcomingPreview.begin());
        std::string texture = type;
        Vector3 pos = Vector3(-SCREEN_WIDTH/2.0f + 2, 4.0f, 0.0f);
        Ball* ball = Ball::ballFactory(world, pos, BALL_RADIUS, type, textureLoader, texture, reactive);
        ball->setVelocity(direction);
        _balls.push_back(ball);
        
        Vector3 previewPosition = Vector3(-SCREEN_WIDTH/2.0f + 1, 4.0f, 0.0f);
        for (int i = 0; i < _upcomingPreview.size(); i ++)
        {
            RenderableSprite* sprite = _upcomingPreview[i];
            sprite->updatePosition(previewPosition, BALL_RADIUS);
            previewPosition.setY(previewPosition.y() - 1.0f);
            sprite->updateVBO();
        }
    }
    else
    {
        NSLog(@"OUT OF BALLS");
    }
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

bool atLeastOneReactive(const std::vector<Ball*>& balls)
{
    for (Ball* ball : balls)
    {
        if (ball->isReactive())
            return true;
    }
    return false;
}

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
        if (closeEnough.size() >= PROXIMITY_COUNT && atLeastOneReactive(closeEnough))
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
    for (Touch touch : touches)
    {
        switch (type) {
            case InputEventType::Began:
                if (_trackedTouch == nullptr)
                {
                    _trackedTouch = touch.identifier;
                    _trackedTouchStart = touch.curr;
                }
                break;
            case InputEventType::Moved:
                break;
            case InputEventType::Ended:
            {
                Vector3 impulse = _trackedTouchStart - touch.curr;
                if (impulse.lengthSq() >= 0.05f) {
                    impulse.setY(impulse.y() * -1.0f);
                    emitABall(impulse * 30.0f, true);
                }
            }
                //intentionall fallthrough
            case InputEventType::Cancelled: //intentionall fallthrough
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




