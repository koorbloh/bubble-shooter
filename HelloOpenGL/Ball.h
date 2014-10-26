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
    Ball(b2World* world);
    
    void draw();
    void onUpdated(){
        b2Vec2 pos = body->GetPosition();
        setPosition(Vector3(pos.x, pos.y, 0.0f));
        updatePosition(position);
        updateVBO();
    }
    
    void setVelocity(const Vector3 vel) {
        velocity = vel;
        body->SetLinearVelocity(b2Vec2(vel.x(), vel.y()));
        //@TODO: is this a thing I can remove after physics are physically able to do this?
    }
    void setRadius(float r) {
        radius = r;
        //@TODO: remove, add to factory method
    }
    
    void setPosition(const Vector3& pos) {
        position = pos;
        body->SetTransform(b2Vec2(pos.x(), pos.y()), 0.0f);
    }
    
//    Vector3 getPosition() { return position; }
//    Vector3 getVelocity() { return velocity; }
//    float getRadius() { return radius; }
    
private:
    Vector3 position;
    Vector3 velocity;
    float radius;
    b2Body* body;
};

#endif /* defined(__HelloOpenGL__Ball__) */
