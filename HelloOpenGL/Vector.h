//
//  Vector.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/18/14.
//
//

#ifndef __HelloOpenGL__Vector__
#define __HelloOpenGL__Vector__

#include <stdio.h>
#include <math.h>
class Vector3
{
public:
    Vector3() {data[0] = 0.0f; data[1] = 0.0f; data[2] = 0.0f;}
    Vector3(float x, float y, float z) { data[0] = x; data[1] = y; data[2] = z; }
    Vector3(const Vector3& a) {data[0] = a.data[0]; data[1] = a.data[1]; data[2] = a.data[2];}
    Vector3 operator=(const Vector3& a) {data[0] = a.data[0]; data[1] = a.data[1]; data[2] = a.data[2]; return *this;}
    
    float x() const {return data[0];}
    float y() const {return data[1];}
    float z() const {return data[2];}
    
    void setX(float val) { data[0] = val; }
    void setY(float val) { data[1] = val; }
    void setZ(float val) { data[2] = val; }
    
    float lengthSq() { return pow(x(),2) + pow(y(),2) + pow(z(),2); }
    float length() { return sqrtf(lengthSq()); }
    
    float* getData() {return data;}
private:
    
    float data[3];
};

inline float distanceSq(const Vector3& a, const Vector3& b)
{
    return pow(b.x() - a.x(),2) +
            pow(b.y() - a.y(),2) +
            pow(b.z() - a.z(),2);
}

inline float distance(const Vector3& a, const Vector3& b)
{
    return sqrtf(distanceSq(a, b));
}

inline Vector3 operator-(const Vector3& a, const Vector3& b)
{
    return Vector3(a.x() - b.x(), a.y() - b.y(), a.z() - b.z());
}

#endif /* defined(__HelloOpenGL__Vector__) */
