//
//  Planet.h
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//


#import "MyObject.h"

@interface Planet : MyObject
{
    CGVector thrustAcceleration;

}

-(id)init:(CGVector)velocityInit Acceleration:(CGVector)accelerationInit ImageName:(NSString*)imageFileNameInit Size:(CGSize)sizeInit View:(UIView*)viewInit ScreenSize:(CGSize)sizeInit;

-(void)updateAcceleration:(double)forceInit Direction:(CGVector)directionVectorInit;

-(void)setThrustAcceleration:(CGVector)accelerationVectorInit;

-(void)reverseVelocity;

@end