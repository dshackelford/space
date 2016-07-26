//
//  Object.m
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyObject.h"

@implementation MyObject

-(id)init:(CGPoint)positionInit Velocity:(CGVector)velocityInit Acceleration:(CGVector)accelerationInit ImageName:(NSString*)imageFileNameInit Size:(CGSize)sizeInit View:(UIView*)viewInit
{
    self = [super init];
    
    position = positionInit;
    velocity = velocityInit;
    acceleration = accelerationInit;
    
    imageSize = sizeInit;
    imageFileName = imageFileNameInit;
    
    [self setImage];
    
    [viewInit addSubview:theImage];
    
    return self;
}

#pragma mark - Setters
-(void)setPosition:(CGPoint)positionInit
{
    position = positionInit;
}

-(void)setVelocity:(CGVector)velocityInit
{
    velocity = velocityInit;
}

-(void)setAcceleration:(CGVector)accelerationInit
{
    acceleration = accelerationInit;
}

-(void)setForce:(double)forceInit
{
    force = forceInit;
}

-(void)setForceVector:(CGVector)forceVectorInit
{
    forceVector = forceVectorInit;
}

-(void)setMass:(double)massInit
{
    mass = massInit;
}

-(void)setSize:(CGSize)sizeInit
{
    imageSize = sizeInit;
}


#pragma mark - Getters
-(CGPoint)getPosition
{
    return position;
}

-(CGVector)getVelocity
{
    return velocity;
}

-(CGVector)getAcceleration
{
    return acceleration;
}

-(UIImageView*)getImage
{
    return theImage;
}

-(double)getMass
{
    return mass;
}


-(double)getForce
{
    return force;
}


-(CGVector)getForceVector
{
    return forceVector;
}

-(CGSize)getSize
{
    return imageSize;
}


-(void)move
{
    //move the Ship
    position.x = position.x + velocity.dx*0.01;
    position.y = position.y + velocity.dy*0.01;
    
    //change the velocity vector
    velocity.dx = velocity.dx + acceleration.dx*0.01;
    velocity.dy = velocity.dy + acceleration.dy*0.01;
    
    theImage.center = position;
}


-(void)setImage
{
    CGRect aRect = CGRectMake(position.x, position.y, imageSize.width, imageSize.height);
    UIImageView* anImage = [[UIImageView alloc]initWithFrame:aRect];
    anImage.image = [UIImage imageNamed:[imageFileName stringByAppendingString:@".png"]];
    
    theImage = anImage;
    
    theImage.center = position;
}

@end