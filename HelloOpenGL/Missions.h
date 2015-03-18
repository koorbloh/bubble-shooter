//
//  Missions.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 3/3/15.
//
//

#ifndef __HelloOpenGL__Missions__
#define __HelloOpenGL__Missions__

#include <stdio.h>
#include <string>
#include <vector>

class Ball;

/*
 all of these are "of type" where type can be "any"
 
 pop X in 1 pop
 pop X total
 pop X without firing again -- chain reaction
 have bubble at height
 */

class BaseMission
{
public:
    virtual void parseParams(NSDictionary* params) = 0;
    virtual void onBallDeleted(const std::string& ballType) {}
    virtual void onBallsUpdated(const std::vector<Ball*> balls) {}
    virtual bool isSatisfied() = 0;
    virtual const std::string getType() const = 0;
};

class BucketAtLevelMission : public BaseMission
{
    virtual void parseParams(NSDictionary* params) override;
    virtual void onBallsUpdated(const std::vector<Ball*> balls) override;
    virtual bool isSatisfied() override;
    virtual const std::string getType() { return "BucketAtLevelMission"; }
};

class DestroyBallsOfTypeMission : public BaseMission
{
    virtual void parseParams(NSDictionary* params) override;
    virtual void onBallDeleted(const std::string& ballType) override;
    virtual bool isSatisfied() override;
    virtual const std::string getType() { return "DestroyBallsOfTypeMission"; }
};

#endif /* defined(__HelloOpenGL__Missions__) */
