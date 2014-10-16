//
//  BallCollisionDetection.h
//  HelloOpenGL
//
//  Created by Jeff Holbrook on 10/11/14.
//
//

#ifndef __HelloOpenGL__BallCollisionDetection__
#define __HelloOpenGL__BallCollisionDetection__

/*
 SHAMELESSLY STOLEN FROM: http://www.plasmaphysics.org.uk/programs/coll2d_cpp.htm
 */

//******************************************************************************
//   This program is a 'remote' 2D-collision detector for two balls on linear
//   trajectories and returns, if applicable, the location of the collision for
//   both balls as well as the new velocity vectors (assuming a partially elastic
//   collision as defined by the restitution coefficient).
//
//   In  'f' (free) mode no positions but only the initial velocities
//   and an impact angle are required.
//   All variables apart from 'mode' and 'error' are of Double Precision
//   Floating Point type.
//
//   The Parameters are:
//
//    mode  (char) (if='f' alpha must be supplied; otherwise arbitrary)
//    alpha (impact angle) only required in mode='f';
//                     should be between -PI/2 and PI/2 (0 = head-on collision))
//    R    (restitution coefficient)  between 0 and 1 (1=perfectly elastic collision)
//    m1   (mass of ball 1)
//    m2   (mass of ball 2)
//    r1   (radius of ball 1)        not needed for 'f' mode
//    r2   (radius of ball 2)                "
//  & x1   (x-coordinate of ball 1)          "
//  & y1   (y-coordinate of ball 1)          "
//  & x2   (x-coordinate of ball 2)          "
//  & y2   (y-coordinate of ball 2)          "
//  & vx1  (velocity x-component of ball 1)
//  & vy1  (velocity y-component of ball 1)
//  & vx2  (velocity x-component of ball 2)
//  & vy2  (velocity y-component of ball 2)
//  & error (int)  (0: no error
//                  1: balls do not collide
//                  2: initial positions impossible (balls overlap))
//
//   Note that the parameters with an ampersand (&) are passed by reference,
//   i.e. the corresponding arguments in the calling program will be updated;
//   however, the coordinates and velocities will only be updated if 'error'=0.
//
//   All variables should have the same data types in the calling program
//   and all should be initialized before calling the function even if
//   not required in the particular mode.
//
//   This program is free to use for everybody. However, you use it at your own
//   risk and I do not accept any liability resulting from incorrect behaviour.
//   I have tested the program for numerous cases and I could not see anything
//   wrong with it but I can not guarantee that it is bug-free under any
//   circumstances.
//
//   I would appreciate if you could report any problems to me
//   (for contact details see  http://www.plasmaphysics.org.uk/feedback.htm ).
//
//   Thomas Smid, January  2004
//                December 2005 (corrected faulty collision detection;
//                               a few minor changes to improve speed;
//                               added simplified code without collision detection)
//                December 2009 (generalization to partially inelastic collisions)
//*********************************************************************************

void collision2D(char mode,double alpha, double R,
                 double m1, double m2, double r1, double r2,
                 double& x1, double& y1, double& x2, double& y2,
                 double& vx1, double& vy1, double& vx2, double& vy2,
                 int& error );




//******************************************************************************
//  Simplified Version
//  The advantage of the 'remote' collision detection in the program above is
//  that one does not have to continuously track the balls to detect a collision.
//  The program needs only to be called once for any two balls unless their
//  velocity changes. However, if somebody wants to use a separate collision
//  detection routine for whatever reason, below is a simplified version of the
//  code which just calculates the new velocities, assuming the balls are already
//  touching (this condition is important as otherwise the results will be incorrect)
//****************************************************************************


void collision2Ds(double m1, double m2, double R,
                  double x1, double y1, double x2, double y2,
                  double& vx1, double& vy1, double& vx2, double& vy2);

#endif /* defined(__HelloOpenGL__BallCollisionDetection__) */
