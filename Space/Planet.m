//
//  Planet.m
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Planet.h"

@implementation Planet


//INITIALIZER
-(id)init:(CGVector)velocityInit Acceleration:(CGVector)accelerationInit ImageName:(NSString*)imageFileNameInit Size:(CGSize)sizeInit View:(UIView*)viewInit ScreenSize:(CGSize)ScreenSizeInit
{
    self = [super init];
    
    velocity = velocityInit;
    acceleration = accelerationInit;

    imageSize = sizeInit;
    imageFileName = imageFileNameInit;
    
    mass = 5;
    
    border = ScreenSizeInit;
    

    int x = arc4random()%(int)(ScreenSizeInit.width - 2*imageSize.width/2) + imageSize.width/2;
    int y = arc4random()%(int)(ScreenSizeInit.height - 2*imageSize.height/2) + imageSize.height/2;
    
//    position = CGPointMake(x, -5);

//    position = CGPointMake(5,ScreenSizeInit.height/2);
    
    position = CGPointMake(x, y);
    
    [self setImage];
    
    [viewInit addSubview:theImage];

    return self;
}

-(void)chooseAPosition:(CGSize)ScreenSizeInit
{
    double x = arc4random()%3;
    
    //PLANET IS IN THE FIRST ROW
    if (x == 0)
    {
        x = arc4random()%(int)ScreenSizeInit.width - ScreenSizeInit.width;
    }
    //PLANET IS IN THE SECOND ROW
    else if (x == 1)
    {
        x = arc4random()%(int)ScreenSizeInit.width;
    }
    //PLANET IS IN THE THRID ROW
    else
    {
        x = arc4random()%(int)ScreenSizeInit.width + ScreenSizeInit.width;
    }

    double y;
    
    //PLANET IS ON THE FIRST OR THIRD COLUMNS OF UNIVSERSE
    if (x < ScreenSizeInit.width || x > ScreenSizeInit.width)
    {
        y = arc4random()%(int)(3*ScreenSizeInit.height) - ScreenSizeInit.height;
    }
    //PLANET IS IN THE SECOND COLUMN OF UNIVERSE
    else
    {
        y = arc4random()%2;
        
        //PLANET IS GONNA BE IN THE TOP MIDDLE OF UNIVERSE
        if (y == 0)
        {
            y = arc4random()%(int)ScreenSizeInit.height - ScreenSizeInit.height;
        }
        //PLANET IS GONNA BE IN THE BOTTOM MIDDLE OF UNIVERSE
        else
        {
            y = arc4random()%(int)ScreenSizeInit.height + ScreenSizeInit.height;
        }
    }
    
    position = CGPointMake(x, y);
}

-(void)reverseVelocity
{
    velocity.dx = -velocity.dx;
    velocity.dy = -velocity.dy;
}

-(void)move
{
    //move the Ship
    position.x = position.x + velocity.dx*0.01;
    position.y = position.y + velocity.dy*0.01;
    
    //change the velocity vector
    velocity.dx = velocity.dx + acceleration.dx;
    velocity.dy = velocity.dy + acceleration.dy;
    
    if ((position.x + imageSize.width/2) > border.width || position.x < imageSize.width/2)
    {
        velocity.dx = -velocity.dx;
    }
    
    if ((position.y + imageSize.height/2) > border.height || position.y < imageSize.height/2)
    {
        velocity.dy = -velocity.dy;
    }
    
    theImage.center = position;
    
    //remove object if it leaves the screen
}

-(void)updateAcceleration:(double)forceInit Direction:(CGVector)directionVectorInit
{
    double x = directionVectorInit.dx;
    double y = directionVectorInit.dy;
    
    double theta;
    
    //TOP LEFT QUADRANT
    if(x > 0 && y > 0)
    {
       theta = atan(directionVectorInit.dy/directionVectorInit.dx);
        
        acceleration.dx = cos(theta)*forceInit;
        acceleration.dy = sin(theta)*forceInit;
    }
    //BOTTOM LEFT QUADRANT
    else if( x > 0 && y < 0)
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
    
    if (thrustAcceleration.dx != 0)
    {
        if (thrustAcceleration.dx > 0)
        {
            acceleration.dx = acceleration.dx - thrustAcceleration.dx;
        }
        else
        {
            acceleration.dx = acceleration.dx + thrustAcceleration.dx;
        }
    }
    
    if (thrustAcceleration.dy != 0)
    {
        if (thrustAcceleration.dy > 0)
        {
            acceleration.dy = acceleration.dy - thrustAcceleration.dy;
        }
        else
        {
            acceleration.dy = acceleration.dy + thrustAcceleration.dy;
        }
    }
    
}

-(void)setThrustAcceleration:(CGVector)accelerationVectorInit
{
    thrustAcceleration = accelerationVectorInit;
}

@end