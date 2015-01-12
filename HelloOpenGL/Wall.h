//
//  Wall.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 1/4/15.
//
//

#ifndef HelloOpenGL_Wall_h
#define HelloOpenGL_Wall_h

#include "RenderableSprite.h"
#include <Box2D/Box2D.h>

class Wall : public RenderableSprite
{
public:
    static Wall* wallFactory(b2World* world, const Vector3& position, const Vector3& size,
                             TextureLoader* textureLoader, const std::string& textureName);
    
    static void wallDisposal(Wall* &wall);
    
    
    Wall(b2World* world, const Vector3& position, const Vector3& size);
    virtual ~Wall();

private:
    b2Body* _body;
    b2Fixture* _fixture;
    b2World* _world;
};

#endif
