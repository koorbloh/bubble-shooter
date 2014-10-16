//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#import "CC3GLMatrix.h"

#include "BallCollisionDetection.h"

@implementation OpenGLView

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2]; // New
} Vertex;

#define TEX_COORD_MAX   4

const Vertex Vertices[] = {
    // Front
    {{1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, -1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, -1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Left
    {{-1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}}, 
    {{-1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Right
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Top
    {{1, 1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, -1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}}, 
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    6, 7, 4,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

const Vertex Vertices2[] = {
    {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
};

Vertex VertexBuffers[][NUMBERER] = {
    {
        {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
        {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
        {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
        {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
    },{
        {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
        {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
        {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
        {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
    },{
        {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
        {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
        {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
        {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
    },{
        {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
        {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
        {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
        {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
    },{
        {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
        {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
        {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
        {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
    }
};

const GLubyte Indices2[] = {
    1, 0, 2, 3
};

const GLubyte IndexBuffers[][NUMBERER] = {
    {
        1, 0, 2, 3
    },{
        1, 0, 2, 3
    },{
        1, 0, 2, 3
    },{
        1, 0, 2, 3
    },{
        1, 0, 2, 3
    }
};

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext {   
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];    
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

- (void)setupFrameBuffer {    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);   
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);    
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];    
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
    
}

- (void)setupVBOs {
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
    
    for (int i = 0; i < NUMBERER; i ++)
    {
        glGenBuffers(1, &(_vertexBuffers[i]));
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[i]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), VertexBuffers[i], GL_DYNAMIC_DRAW);
        
        glGenBuffers(1, &_indexBuffers[i]);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffers[i]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), IndexBuffers[i], GL_DYNAMIC_DRAW);
    }
    
    
}

-(void)updateVBOs {
    for (int i = 0; i < NUMBERER; i ++)
    {
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[i]);
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertices2), VertexBuffers[i]);
    }
}

void updateSprite(Vertex* vertex, float *position)
{
    float vertCorners[][4] = {{0.5, -0.5, 0.01},{0.5, 0.5, 0.01},{-0.5, 0.5, 0.01},{-0.5, -0.5, 0.01}};
    
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            vertex[i].Position[j] = position[j] + vertCorners[i][j];
        }
    }

}

typedef struct {
    float position[3];
    double velocity[3];
    float radius;
} Ball;

#define MAX_BALLS 5
Ball balls[MAX_BALLS];


#define BOTTOM_OF_SCREEN -5.0f
#define SCREEN_WIDTH 0.5f
#define SECONDS_BETWEEN_BALLS 0.33f
#define BALL_RADIUS 0.5f
int numBalls = 0;
float secondsSinceEmit = SECONDS_BETWEEN_BALLS;

void emitBalls(float dt)
{
    if (numBalls < MAX_BALLS && secondsSinceEmit >= SECONDS_BETWEEN_BALLS)
    {
        secondsSinceEmit = 0.0f;
        balls[numBalls].position[0] = RandomDoubleBetween(0.0f, SCREEN_WIDTH)-(SCREEN_WIDTH/2.0f);
        balls[numBalls].radius = BALL_RADIUS;
        numBalls++;
    }
    secondsSinceEmit += dt;
}


#define GRAVITY -4.9f
#define BOUNCE_DAMPING 0.25f

float distance(float* pos1, float* pos2)
{
    return sqrt(pow(pos2[0] - pos1[0],2) + pow(pos2[1] - pos1[1],2) + pow(pos2[2] - pos1[2],2));
}

void sub(float* vec1, float* vec2, float *result)
{
    result[0] = vec1[0] - vec2[0];
    result[1] = vec1[1] - vec2[1];
    result[2] = vec1[2] - vec2[2];
}

void subd(double* vec1, double* vec2, double *result)
{
    result[0] = vec1[0] - vec2[0];
    result[1] = vec1[1] - vec2[1];
    result[2] = vec1[2] - vec2[2];
}

double lengthSqd(double* vec)
{
    return pow(vec[0], 2) + pow(vec[1], 2) + pow(vec[2], 2);
}

double lengthd(double* vec)
{
    return sqrt(lengthSqd(vec));
}

float lengthSq(float* vec)
{
    return pow(vec[0], 2) + pow(vec[1], 2) + pow(vec[2], 2);
}

float length(float* vec)
{
    return sqrt(lengthSq(vec));
}

void updateBalls(float dt)
{
    for (int i = 0; i < numBalls; i++)
    {
        //check for collision
        for (int j = i + 1; j < numBalls; j++)
        {
            float dist = distance(balls[i].position, balls[j].position);
//            NSLog(@"%f",dist);
            if (dist < balls[i].radius + balls[j].radius)
            {
                collision2Ds(1.0f, 1.0f, 1.0f, balls[i].position[0], balls[i].position[1], balls[j].position[0], balls[j].position[1],
                             balls[i].velocity[0], balls[i].velocity[1], balls[j].velocity[0], balls[j].velocity[1]);
            }
        }

        //gravity
        balls[i].velocity[1] = balls[i].velocity[1] + GRAVITY*dt;
        
        //update position
        for (int k = 0; k < 3; k++)
        {
            balls[i].position[k] = balls[i].position[k] + balls[i].velocity[k]*dt;
        }
        
        
        //ok, clamp that bitch to the screen
        if (balls[i].position[1] < BOTTOM_OF_SCREEN)
        {
            balls[i].position[1] = BOTTOM_OF_SCREEN;
            balls[i].velocity[1] = -balls[i].velocity[1] * BOUNCE_DAMPING;
        }
        //if we are outside the bounds, SEND IT BACK!.
        if (balls[i].position[0] > SCREEN_WIDTH)
        {
            balls[i].velocity[0] *= -BOUNCE_DAMPING;
            balls[i].position[0] = SCREEN_WIDTH;
        }
        else if (balls[i].position[0] < -SCREEN_WIDTH)
        {
            balls[i].velocity[0] *= -BOUNCE_DAMPING;
            balls[i].position[0] = -SCREEN_WIDTH;
        }
    }
}


- (void)render:(CADisplayLink*)displayLink {
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);        
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(0, 0, -7)]; //[modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
    //_currentRotation += displayLink.duration * 90;
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
        
    /*glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    
    
    
    
    // 2
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));    
    
    glActiveTexture(GL_TEXTURE0); 
    glBindTexture(GL_TEXTURE_2D, _floorTexture);
    glUniform1i(_textureUniform, 0); 
    
    // 3
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glActiveTexture(GL_TEXTURE0); // unneccc in practice
    glBindTexture(GL_TEXTURE_2D, _fishTexture);
    glUniform1i(_textureUniform, 0); // unnecc in practice
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);*/
    /*
    for (int i = 0; i < NUMBERER; i ++)
    {
        for (int j = 0; j < 4; j++)
        {
            VertexBuffers[i][j].Position[0] += sin(1.0f - ((float)i/5.0f))/100;
        }
    }*/
    
    /*for (int j = 0; j < 4; j++)
    {
        VertexBuffers[0][j].Position[1] -= sin(1.0f - ((float)1/5.0f))/100;
    }*/
    
//    balls[0].position[1] -= .1;
    emitBalls(displayLink.duration);
    updateBalls(displayLink.duration);
    
    for (int i = 0; i < numBalls; i++)
    {
        updateSprite(VertexBuffers[i], balls[i].position);
    }
    
    [self updateVBOs];

    int i = 0;
    for (i = 0; i < numBalls; i ++)
    {
        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffers[i]);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffers[i]);
        
        glActiveTexture(GL_TEXTURE0); // unneccc in practice
        glBindTexture(GL_TEXTURE_2D, _fishTexture);
        glUniform1i(_textureUniform, 0); // unnecc in practice
        
        glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
        
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
        glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
        
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(_indexBuffers[i])/sizeof(GLubyte), GL_UNSIGNED_BYTE, 0);
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];    
}

- (GLuint)setupTexture:(NSString *)fileName {
    
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);    
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST); 
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self setupLayer];        
        [self setupContext];    
        [self setupDepthBuffer];
        [self setupRenderBuffer];        
        [self setupFrameBuffer];     
        [self compileShaders];
        [self setupVBOs];
        [self setupDisplayLink];
        _floorTexture = [self setupTexture:@"tile_floor.png"];
        _fishTexture = [self setupTexture:@"item_powerup_fish.png"];
    }
    return self;
}

- (void)dealloc
{
    [_context release];
    _context = nil;
    [super dealloc];
}

@end
