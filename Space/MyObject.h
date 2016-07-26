//
//  Object.h
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyObject : NSObject
{
    
    CGPoint position;
    CGVector velocity;
    CGVector acceleration;
    CGSize border;
    
    double mass;
    double force;
    CGVector forceVector;
    
    UIView* view;
    
    UIImageView* theImage;
    CGSize imageSize;
    
    NSString* imageFileName;
    
}


#pragma mark - Initializers
-(id)init:(CGPoint)positionInit Velocity:(CGVector)velocityInit Acceleration:(CGVector)accelerationInit ImageName:(NSString*)imageFileNameInit Size:(CGSize)size View:(UIView*)viewInit;


#pragma mark - Setters
-(void)setPosition:(CGPoint)positionInit;
-(void)setVelocity:(CGVector)velocityInit;
-(void)setAcceleration:(CGVector)accelerationInit;
-(void)setImage;
-(void)setForce:(double)forceInit;
-(void)setForceVector:(CGVector)forceVectorInit;
-(void)setMass:(double)massInit;
-(void)setSize:(CGSize)sizeInit;


#pragma mark - Getters
-(CGPoint)getPosition;
-(CGVector)getVelocity;
-(CGVector)getAcceleration;
-(UIImageView*)getImage;
-(double)getMass;
-(double)getForce;
-(CGVector)getForceVector;
-(CGSize)getSize;


-(void)move;

@end
