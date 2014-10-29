//
//  TextureLoader.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/28/14.
//
//

#ifndef __HelloOpenGL__TextureLoader__
#define __HelloOpenGL__TextureLoader__

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include <stdio.h>
#include <vector>
#include <string>

class TextureLoader
{
public:
    ~TextureLoader();
    GLuint loadTexture(const std::string& textureName);
private:
    typedef struct {
        std::string textureName;
        GLuint textureHandle;
    } TextureTracker;
    
    std::vector<TextureTracker> textures;
};

#endif /* defined(__HelloOpenGL__TextureLoader__) */
