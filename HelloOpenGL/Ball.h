//
//  Ball.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#ifndef __HelloOpenGL__Ball__
#define __HelloOpenGL__Ball__

#include "RenderableSprite.h"
#include "Vector.h"

#include <Box2D/Box2D.h>

class Ball : public RenderableSprite {
public:
    static Ball* ballFactory(b2World* world, const Vector3& position, float radius, const std::string& type,
                             TextureLoader* textureLoader, const std::string& textureName);
    
    static void ballDisposal(Ball* &ball);
    
    Ball(b2World* world, float radius);
    virtual ~Ball();
    
    void draw();
    void onUpdated(){
        b2Vec2 pos = _body->GetPosition();
        setPosition(Vector3(pos.x, pos.y, 0.0f));
        updatePosition(_position, _radius);
        updateVBO();
    }
    
    void setVelocity(const Vector3 vel) {
        _velocity = vel;
        _body->SetLinearVelocity(b2Vec2(vel.x(), vel.y()));
        //@TODO: is this a thing I can remove after physics are physically able to do this?
    }
    
    void setPosition(const Vector3& pos) {
        _position = pos;
        _body->SetTransform(b2Vec2(pos.x(), pos.y()), 0.0f);
    }
    
    const Vector3& getPosition() { return _position; }
    float getRadius() { return _radius; }
    
    const std::string& getType() { return _type; }
    void setType(const std::string newType) { _type = newType; }
    
//    Vector3 getPosition() { return position; }
//    Vector3 getVelocity() { return velocity; }
//    float getRadius() { return radius; }
    
private:
    Vector3 _position;
    Vector3 _velocity;
    float _radius;
    b2Body* _body;
    b2Fixture* _fixture;
    b2World* _world;
    std::string _type = "unset";
};

#endif /* defined(__HelloOpenGL__Ball__) */
