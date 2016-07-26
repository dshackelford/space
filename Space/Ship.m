//
//  Ship.m
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@implementation Ship

////INITIALIZERS
-(id)init:(CGPoint)positionInit Velocity:(CGVector)velocityInit Acceleration:(CGVector)accelerationInit ImageName:(NSString*)imageFileNameInit Size:(CGSize)sizeInit View:(UIView*)viewInit;
{
    self = [super init];
    
    position = positionInit;
    velocity = velocityInit;
    acceleration = accelerationInit;
    
    imageSize = sizeInit;
    imageFileName = imageFileNameInit;
    
    mass = 10;
    
    [self setImage];
    
    [viewInit addSubview:theImage];
    
    return self;
}

-(void)move
{
    //move the Ship
//    position.x = position.x + velocity.dx*0.01;
//    position.y = position.y + velocity.dy*0.01;
    
    //change the velocity vector
    velocity.dx = velocity.dx + acceleration.dx;
    velocity.dy = velocity.dy + acceleration.dy;
    
//    theImage.center = position;
}

-(void)updateAcceleration:(double)forceInit Direction:(CGVector)directionVectorInit
{
    double x = directionVectorInit.dx;
    double y = directionVectorInit.dy;
    
    double theta;
    
    //TOP RIGHT QUADRANT
    if(x > 0 && y > 0)
    {
        theta = atan(directionVectorInit.dy/directionVectorInit.dx);
        acceleration.dx = cos(theta)*forceInit;
        acceleration.dy = sin(theta)*forceInit;
    }
    //BOTTOM LEFT QUADRANT
    else if( x> 0 && y < 0)
    {
        theta = atan(fabs(directionVectorInit.dy)/directionVectorInit.dx);
        acceleration.dx = cos(theta)*forceInit;
        acceleration.dy = -sin(theta)*forceInit;
    }
    //TOP RIGHT QUADRANT
    else if( x < 0 && y > 0)
    {
        theta = atan(directionVectorInit.dy/fabs(directionVectorInit.dx));
        acceleration.dx = -cos(theta)*forceInit;
        acceleration.dy = sin(theta)*forceInit;
    }
    //BOTTOM RIGHT QUADRANT
    else
    {
        theta = atan(directionVectorInit.dy/directionVectorInit.dx);
        acceleration.dx = -cos(theta)*forceInit;
        acceleration.dy = -sin(theta)*forceInit;
    }
    
}

@end