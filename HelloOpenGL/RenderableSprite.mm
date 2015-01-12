//
//  Renderable.cpp
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/16/14.
//
//

#include <cstring>
#include "RenderableSprite.h"
#include "Vector.h"
#include "TextureLoader.h"

static Vertex baseSpriteVertices[] = {
    {{1.0f, -1.0f, 0.01}, {1, 1, 1, 1}, {1, 1}},
    {{1.0f, 1.0f, 0.01}, {1, 1, 1, 1}, {1, 0}},
    {{-1.0f, 1.0f, 0.01}, {1, 1, 1, 1}, {0, 0}},
    {{-1.0f, -1.0f, 0.01}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte baseSpriteIndexBuffer[] = {
    1, 0, 2, 3
};

RenderableSprite::~RenderableSprite()
{
    cleanupVBO();
}

void RenderableSprite::allocBuffers()
{
    if (_data != NULL)
    {
        cleanupVBO();
    }
    _data = new unsigned char[sizeof(baseSpriteVertices)];
    memcpy(_data, baseSpriteVertices, sizeof(baseSpriteVertices));
    _indices = new unsigned char[sizeof(baseSpriteIndexBuffer)];
    memcpy(_indices, baseSpriteIndexBuffer, sizeof(baseSpriteIndexBuffer));
}

void RenderableSprite::setupVBO()
{
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(baseSpriteVertices), _data, GL_DYNAMIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(baseSpriteIndexBuffer), _indices, GL_DYNAMIC_DRAW);
}

void RenderableSprite::updateVBO()
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(baseSpriteVertices), _data);
}

void RenderableSprite::cleanupVBO()
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    delete [] _data;
    delete [] _indices;
    _data = NULL;
    _indices = NULL;
}

void RenderableSprite::updatePosition(float x, float y, float z, float radius)
{
    Vertex* vert = (Vertex*)_data;
    for (int i = 0; i < 4; ++i) {
        vert[i].Position[0] = x + (radius*baseSpriteVertices[i].Position[0]);
        vert[i].Position[1] = y + (radius*baseSpriteVertices[i].Position[1]);
        vert[i].Position[2] = z + (radius*baseSpriteVertices[i].Position[2]);
    }
}

void RenderableSprite::updatePosition(const Vector3& pos, const Vector3& size)
{
    Vertex* vert = (Vertex*)_data;
    Vector3 halfSize = 0.5f * size;

    for (int i = 0; i < 4; ++i) {
        vert[i].Position[0] = pos.x() + (halfSize.x()*baseSpriteVertices[i].Position[0]);
        vert[i].Position[1] = pos.y() + (halfSize.y()*baseSpriteVertices[i].Position[1]);
        vert[i].Position[2] = pos.z() + (halfSize.z()*baseSpriteVertices[i].Position[2]);
    }
}

void RenderableSprite::updatePosition(const Vector3& pos, float radius)
{
    updatePosition(pos.x(), pos.y(), pos.z(), radius);
}

GLuint RenderableSprite::getIndexBuffer()
{
    return _indexBuffer;
}

GLuint RenderableSprite::getVertexBuffer()
{
    return _vertexBuffer;
}

void RenderableSprite::loadTexture(const std::string& textureName, TextureLoader* textureLoader)
{
    _textureHandle = textureLoader->loadTexture(textureName);
}
