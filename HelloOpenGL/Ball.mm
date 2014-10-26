//
//  Ball.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#include "Ball.h"

Ball::Ball(b2World* world)
{
    // Define the dynamic body. We set its position and call the body factory.
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(0.0f, 4.0f);
    body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2CircleShape dynamicCircle;
    dynamicCircle.m_radius = 0.5f;
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicCircle;
    
    // Set the box density to be non-zero, so it will be dynamic.
    fixtureDef.density = 1.0f;
    
    // Override the default friction.
    fixtureDef.friction = 0.3f;
    
    fixtureDef.restitution = 0.8f;
    
    // Add the shape to the body.
    body->CreateFixture(&fixtureDef);
    
}

/*
// Define the dynamic body. We set its position and call the body factory.
b2BodyDef bodyDef;
bodyDef.type = b2_dynamicBody;
bodyDef.position.Set(0.0f, 4.0f);
b2Body* body = world.CreateBody(&bodyDef);

// Define another box shape for our dynamic body.
b2PolygonShape dynamicBox;
dynamicBox.SetAsBox(1.0f, 1.0f);

// Define the dynamic body fixture.
b2FixtureDef fixtureDef;
fixtureDef.shape = &dynamicBox;

// Set the box density to be non-zero, so it will be dynamic.
fixtureDef.density = 1.0f;

// Override the default friction.
fixtureDef.friction = 0.3f;

// Add the shape to the body.
body->CreateFixture(&fixtureDef);
*/