//
//  Ball.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#include "Ball.h"

Ball::Ball(b2World* world, float radius)
{
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
    
    fixtureDef.restitution = 0.8f;
    
    // Add the shape to the body.
    _body->CreateFixture(&fixtureDef);
    
}

