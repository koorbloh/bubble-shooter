//
//  Wall.m
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 1/4/15.
//
//

#import <Foundation/Foundation.h>
#include "Wall.h"
#include "Vector.h"

Wall* Wall::wallFactory(b2World* world, const Vector3& position, const Vector3& size,
                        TextureLoader* textureLoader, const std::string& textureName)
{
    Wall* wall = new Wall(world, position, size);
    wall->allocBuffers();
    wall->setupVBO();
    
    wall->updatePosition(position, size);
    wall->loadTexture(textureName, textureLoader);
    wall->setColor(0.5f, 0.15f, 0.2f, 1.0f);
    wall->updateVBO();
    
    return wall;
}

void Wall::wallDisposal(Wall *&wall)
{
    delete wall;
    wall = NULL;
}

Wall::Wall(b2World* world, const Vector3& position, const Vector3& size)
{
    _world = world;

    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(position.x(), position.y());

    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    _body = world->CreateBody(&groundBodyDef);

    // Define the ground box shape.
    b2PolygonShape groundBox;
    
    // The extents are the half-widths of the box.
    groundBox.SetAsBox(size.x(), size.y());
    
    // Add the ground fixture to the ground body.
    _fixture = _body->CreateFixture(&groundBox, 0.0f);
}

Wall::~Wall()
{
    _body->DestroyFixture(_fixture);
    _world->DestroyBody(_body);
    _fixture = NULL;
    _body = NULL;
    _world = NULL;
}