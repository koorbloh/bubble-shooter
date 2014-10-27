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
    Ball(b2World* world, float radius);
    
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
    
//    Vector3 getPosition() { return position; }
//    Vector3 getVelocity() { return velocity; }
//    float getRadius() { return radius; }
    
private:
    Vector3 _position;
    Vector3 _velocity;
    float _radius;
    b2Body* _body;
};

#endif /* defined(__HelloOpenGL__Ball__) */
