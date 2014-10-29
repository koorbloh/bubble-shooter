//
//  TextureLoader.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/28/14.
//
//

#include "TextureLoader.h"

TextureLoader::~TextureLoader()
{
    for (TextureTracker tracker : textures)
    {
        glDeleteTextures(1, &tracker.textureHandle);
    }
    textures.clear();
}

GLuint TextureLoader::loadTexture(const std::string& fileName)
{
    for (TextureTracker tracker : textures)
    {
        if (tracker.textureName == fileName)
        {
            return tracker.textureHandle;
        }
    }
    
    CGImageRef spriteImage = [UIImage imageNamed:@(fileName.c_str())].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", @(fileName.c_str()));
        exit(1);
    }

    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    GLuint handle;
    glGenTextures(1, &handle);
    glBindTexture(GL_TEXTURE_2D, handle);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
    
    TextureTracker tracker;
    tracker.textureHandle = handle;
    tracker.textureName = fileName;
    textures.push_back(tracker);
    
    return handle;
}
