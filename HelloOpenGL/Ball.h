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

class Ball : public RenderableSprite {
public:
    //Ball();
    
    void draw();
    void update(){
        updatePosition(position[0], position[1], position[2]);
        updateVBO();
    }
    
    void setVelocity(double x, double y, double z) {
        position[0] = x; position[1] = y; position[2] = z;
    }
    void setPosition(float x, float y, float z) {
        velocity[0] = x; velocity[1] = y; velocity[2] = z;
    }
    void setRadius(float r) {
        radius = r;
    }
        
    float position[3];
    double velocity[3];
    float radius;
private:
};

#endif /* defined(__HelloOpenGL__Ball__) */
