//
//  OpenGLView.m
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"
#import "CC3GLMatrix.h"
#include <vector>
#include "Ball.h"
#include "BallCollisionDetection.h"

#include <Box2D/Box2D.h>

// Construct a world object, which will hold and simulate the rigid bodies.
b2World world(b2Vec2(0.0f, -10.0f));


@implementation OpenGLView

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


#define MAX_BALLS 20
std::vector<Ball*> balls;

#define BOTTOM_OF_SCREEN -5.0f
#define SCREEN_WIDTH 0.5f
#define SECONDS_BETWEEN_BALLS 0.5f
#define BALL_RADIUS 0.5f
float secondsSinceEmit = SECONDS_BETWEEN_BALLS;

void emitBalls(float dt)
{
    if (balls.size() < MAX_BALLS && secondsSinceEmit >= SECONDS_BETWEEN_BALLS)
    {
        secondsSinceEmit = 0.0f;
        Ball* ball = new Ball(&world);
        ball->allocBuffers();
        ball->setupVBO();
        ball->setRadius(BALL_RADIUS);
        ball->setPosition(Vector3(RandomDoubleBetween(0.0f, SCREEN_WIDTH)-(SCREEN_WIDTH/2.0f), 5.0f, 0.0f));
        balls.push_back(ball);
    }
    secondsSinceEmit += dt;
}

#define GRAVITY -4.9f
#define BOUNCE_DAMPING 0.25f
#define REALLY_HEAVY 2.0f
#define BOTTOM_TOLERANCE 0.01f

void updateBalls(float dt)
{
#if 0
    for (int i = 0; i < balls.size(); i++)
    {
        Vector3 pos = balls[i]->getPosition();
        //check for collision
        for (int j = i + 1; j < balls.size(); j++)
        {
            float dist = distance(balls[i]->getPosition(), balls[j]->getPosition());
            if (dist < balls[i]->getRadius() + balls[j]->getRadius())
            {
                float iMass = 1.0f;
                float jMass = 1.0f;
                Vector3 iVel = balls[i]->getVelocity();
                Vector3 jVel = balls[j]->getVelocity();
                collision2Ds(iMass, jMass, 1.0f,
                             balls[i]->getPosition(), balls[j]->getPosition(),
                             iVel, jVel);
                /*if (fabs(pos.y() - BOTTOM_OF_SCREEN) < BOTTOM_TOLERANCE)
                {
                    iMass = REALLY_HEAVY;
                }
                if (fabs(balls[j]->getPosition().y() - BOTTOM_OF_SCREEN) < BOTTOM_TOLERANCE)
                {
                    jMass = REALLY_HEAVY;
                }*/
                
                if ((fabs(pos.y() - BOTTOM_OF_SCREEN) < BOTTOM_TOLERANCE) !=
                    (fabs(balls[j]->getPosition().y() - BOTTOM_OF_SCREEN) < BOTTOM_TOLERANCE))
                {
                    collision2Ds(iMass, jMass, 1.0f,
                                 balls[i]->getPosition(), balls[j]->getPosition(),
                                 iVel, jVel);                    
                }
                
                balls[i]->setVelocity(iVel);
                balls[j]->setVelocity(jVel);
            }
        }

        Vector3 vel = balls[i]->getVelocity();
        
        //gravity
        vel.setY(vel.y() + GRAVITY*dt);
        
        //ok, clamp that bitch to the screen
        if (pos.y() < BOTTOM_OF_SCREEN && vel.y() < 0.0f)
        {
            vel.setY(-vel.y() * BOUNCE_DAMPING);
        }
        //if we are outside the bounds, SEND IT BACK!.
        if (pos.x() > SCREEN_WIDTH && vel.x() > 0.0f)
        {
            vel.setX(vel.x() * -BOUNCE_DAMPING);
//            pos.setX(SCREEN_WIDTH);
        }
        else if (pos.x() < -SCREEN_WIDTH && vel.x() < 0.0f)
        {
            vel.setX(vel.x() * -BOUNCE_DAMPING);
//            pos.setX(-SCREEN_WIDTH);
        }
        
        //update position
        pos.setX(pos.x() + vel.x()*dt);
        pos.setY(pos.y() + vel.y()*dt);
        pos.setZ(pos.z() + vel.z()*dt);
        
        balls[i]->setVelocity(vel);
        balls[i]->setPosition(pos);
    }
#endif
}

void updateBallDrawData()
{
    for (int i = 0; i < balls.size(); i++)
    {
        balls[i]->onUpdated();
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
    [modelView populateFromTranslation:CC3VectorMake(0, 0, -7)];
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    emitBalls(displayLink.duration);
    updateBalls(displayLink.duration);
    
    int32 velocityIterations = 6;
    int32 positionIterations = 2;
    
    world.Step(displayLink.duration, velocityIterations, positionIterations);

    
    updateBallDrawData();
    
    for (int i = 0; i < balls.size(); i ++)
    {
        glBindBuffer(GL_ARRAY_BUFFER, balls[i]->getVertexBuffer());
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, balls[i]->getIndexBuffer());
        
        glActiveTexture(GL_TEXTURE0); // unneccc in practice
        glBindTexture(GL_TEXTURE_2D, _fishTexture);
        glUniform1i(_textureUniform, 0); // unnecc in practice
        
        glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
        
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
        glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
        
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(balls[i]->getIndexBuffer())/sizeof(GLubyte), GL_UNSIGNED_BYTE, 0);
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
        [self setupDisplayLink];
        _floorTexture = [self setupTexture:@"tile_floor.png"];
        _fishTexture = [self setupTexture:@"item_powerup_fish.png"];
        
        
        // Define the ground body.
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0.0f, -10.0f);
        
        // Call the body factory which allocates memory for the ground body
        // from a pool and creates the ground box shape (also from a pool).
        // The body is also added to the world.
        b2Body* groundBody = world.CreateBody(&groundBodyDef);
        
        // Define the ground box shape.
        b2PolygonShape groundBox;
        
        // The extents are the half-widths of the box.
        groundBox.SetAsBox(50.0f, 10.0f);
        
        // Add the ground fixture to the ground body.
        groundBody->CreateFixture(&groundBox, 0.0f);
        
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
