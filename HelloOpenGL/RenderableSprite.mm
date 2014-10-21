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

static Vertex baseSpriteVertices[] = {
    {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
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

void RenderableSprite::updatePosition(float x, float y, float z)
{
    Vertex* vert = (Vertex*)_data;
    for (int i = 0; i < 4; ++i) {
        vert[i].Position[0] = x + baseSpriteVertices[i].Position[0];
        vert[i].Position[1] = y + baseSpriteVertices[i].Position[1];
        vert[i].Position[2] = z + baseSpriteVertices[i].Position[2];
    }
}

void RenderableSprite::updatePosition(const Vector3& pos)
{
    updatePosition(pos.x(), pos.y(), pos.z());
}

GLuint RenderableSprite::getIndexBuffer()
{
    return _indexBuffer;
}

GLuint RenderableSprite::getVertexBuffer()
{
    return _vertexBuffer;
}

