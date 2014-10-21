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

class Ball : public RenderableSprite {
public:
    //Ball();
    
    void draw();
    void onUpdated(){
        updatePosition(position);
        updateVBO();
    }
    
    void setVelocity(const Vector3 vel) {
        velocity = vel;
    }
    void setRadius(float r) {
        radius = r;
    }
    
    void setPosition(const Vector3& pos) {
        position = pos;
    }
    
    Vector3 getPosition() { return position; }
    Vector3 getVelocity() { return velocity; }
    float getRadius() { return radius; }
        
private:
    Vector3 position;
    Vector3 velocity;
    float radius;
};

#endif /* defined(__HelloOpenGL__Ball__) */
