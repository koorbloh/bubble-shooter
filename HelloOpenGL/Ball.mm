//
//  Ball.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#include "Ball.h"

/*static*/
Ball* Ball::ballFactory(b2World* world, const Vector3& position, float radius, const std::string& type,
                         TextureLoader* textureLoader, const std::string& textureName, bool reactive)
{
    Ball* ball = new Ball(world, radius);
    ball->allocBuffers();
    ball->setupVBO();
    ball->setPosition(position);
    ball->loadTexture(textureName, textureLoader);
    ball->setType(textureName);
    ball->_reactive = reactive;
    return ball;
}

/*static*/
void Ball::ballDisposal(Ball* &ball)
{
    delete ball;
    ball = NULL;
}



Ball::Ball(b2World* world, float radius)
{
    _world = world;
    // Define the dynamic body. We set its position and call the body factory.
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(0.0f, 4.0f);
    _body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
    dynamicCircle.m_radius = radius;
    _radius = radius;
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicCircle;
    
    // Set the box density to be non-zero, so it will be dynamic.
    fixtureDef.density = 1.0f;
    
    // Override the default friction.
    fixtureDef.friction = 0.3f;
    
    fixtureDef.restitution = 0.5f;
    
    // Add the shape to the body.
    _fixture = _body->CreateFixture(&fixtureDef);
    
}

Ball::~Ball()
{
    _body->DestroyFixture(_fixture);
    _world->DestroyBody(_body);
    _fixture = NULL;
    _body = NULL;
    _world = NULL;
}

void Ball::makeBomb()
{
    _isBomb = true;
    setColor(0.5f, 0.5f, 0.5f, 1.0f);
}

