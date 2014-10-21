//
//  Renderable.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#ifndef __HelloOpenGL__Renderable__
#define __HelloOpenGL__Renderable__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <stddef.h>

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
} Vertex;

class Vector3;

class RenderableSprite {
public:
    RenderableSprite():
    _data(NULL) {}
    
    ~RenderableSprite();
    
    void setupVBO();
    void updateVBO();
    void cleanupVBO();
    
    void updatePosition(float x, float y, float z);
    void updatePosition(const Vector3& pos);
    
    GLuint getIndexBuffer();
    GLuint getVertexBuffer();    
    
    void allocBuffers();
private:
    unsigned char *_data = 0;
    unsigned char *_indices = 0;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;    
};

#endif /* defined(__HelloOpenGL__Renderable__) */
