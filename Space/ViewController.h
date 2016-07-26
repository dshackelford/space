//
//  ViewController.h
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ship.h"
#import "Planet.h"


@interface ViewController : UIViewController
{
    Ship* theShip;
    IBOutlet UIButton* placeHolderButton;
    double counter;
    double reverseCounter;
    CGSize screenSize;
    
//    IBOutlet UIButton* rightButton;
//    IBOutlet UIButton* leftButton;
//    IBOutlet UIButton* upButton;
//    IBOutlet UIButton* downButton;
    
    IBOutlet UIButton* mainMenuButton;
    IBOutlet UIButton* restartButton;
    
    NSMutableArray* planetArray;
    NSMutableArray* collisionArray;
    
    double GravitationalConstant;
    
    int numOfPlanets;
    
}

-(void)setNumOfPlanets:(int)numOfPlanetsInit;

-(void)updateMovement;

#pragma mark - Find Forces

-(void)findForceOfGravity:(NSMutableArray*)planetArrayInit;

-(CGVector)findAForceVectorInQuadrants:(CGVector)relativeLocationInit :(double)forceInit;

-(void)findNormalForce:(NSMutableArray*)planetArrayInit;


#pragma mark - Collisions
-(void)collision:(double)firstIndex :(double)secondIndex;

-(void)testForCollisions:(NSMutableArray*)planetArrayInit;

-(void)collidePlanets:(NSMutableArray*)collisionArrayInit;


#pragma mark - Set Accelerations

-(void)setPlanetAcceleration:(NSMutableArray*)planetArrayInit;


#pragma mark - Geometry

-(CGVector)findRelativeLocation:(Planet*)planet1Init :(Planet*)planet2Init;
-(double)findAbsoluteDistance:(CGVector)relativeLocationInit;

-(CGSize)findCoupledPlanetSize:(Planet*)planet1Init :(Planet*)planet2Init;


#pragma mark - Add Planet

-(void)addPlanet;

//
//-(IBAction)pressLeftButton:(id)sender;
//-(IBAction)pressRightButton:(id)sender;
-(IBAction)pressMainMenuButton:(id)sender;
-(IBAction)pressRestartButton:(id)sender;

@end

