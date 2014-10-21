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
    
    void setVelocity(double x, double y, double z) {
        velocity[0] = x; velocity[1] = y; velocity[2] = z;
    }
    void setRadius(float r) {
        radius = r;
    }
    
    void setPosition(const Vector3& pos) {
        position = pos;
    }
    
    Vector3 getPosition() { return position; }
    double *getVelocity() { return velocity; }
    float getRadius() { return radius; }
        
private:
    Vector3 position;
    double velocity[3];
    float radius;
};

#endif /* defined(__HelloOpenGL__Ball__) */
