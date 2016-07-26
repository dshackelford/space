//
//  ViewController.m
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(declareHowManyPlanets:) name:@"HowManyPlanetsNotification" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    GravitationalConstant = 100;
    screenSize = [UIScreen mainScreen].bounds.size;
    counter = 0;
    reverseCounter = 0;
    
    planetArray = [[NSMutableArray alloc] init];

    collisionArray = [[NSMutableArray alloc] init];

    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateMovement) userInfo:nil repeats:YES];
}



#pragma mark - Update Movement

-(void)updateMovement
{
    counter = counter + 1;
    
    if ([planetArray count] > 0)
    {
        //FINDS THE FORCE VECTOR ON EACH PLANET BASED SOLEY ON GRAVITY
        [self findForceOfGravity:planetArray];
        
        //CREATES AN ARRAY THAT CONTAINS WHICH PLANETS ARE HITTING EACH OTHER
        [self testForCollisions:planetArray];
        
        //APPLIES THE CONSERVATION OF LINEAR MOMENTUM TO THE COLLIDING PLANETS
        [self collidePlanets:collisionArray];
        
        //FIND THE NORMAL FORCES THAT MAY OR MAY NOT BE PRESENT
        [self findNormalForce:planetArray];
        
        //SETS THE ACCELERATIONS AFTER ALL THE MATH DONE
        [self setPlanetAcceleration:planetArray];
    }
    
    //MOVE THE PLANETS! ALL THE ACCELERATIONS SHOULD BE DEFINED, SO THEIR VELOCITIES SHOULD BE DEFINED AS WELL
    for(Planet* aPlanet in planetArray)
    {
        [aPlanet move];
    }
    
}

#pragma mark - Find Forces
-(void)findForceOfGravity:(NSMutableArray*)planetArrayInit
{
    for (int i = 0; i < [planetArrayInit count]; i = i + 1)
    {
        Planet* planetI = [planetArrayInit objectAtIndex:i];
        
        double xSumForce = 0;
        double ySumForce = 0;
        
        for (int j = 0; j < [planetArrayInit count]; j = j + 1)
        {
            if (j != i)
            {
                Planet* planetJ = [planetArrayInit objectAtIndex:j];
                
                CGVector relativeLocation = [self findRelativeLocation:planetI :planetJ];
                
                double actualDistance = [self findAbsoluteDistance:relativeLocation];
                
                double aForceOfGravity;

                aForceOfGravity = GravitationalConstant*[planetI getMass]*[planetJ getMass]/(actualDistance*actualDistance);
                
                CGVector aForceVector = [self findAForceVectorInQuadrants:relativeLocation: aForceOfGravity];
                
                xSumForce = xSumForce + aForceVector.dx;
                ySumForce = ySumForce + aForceVector.dy;
            }
        }
        
        [planetI setForceVector:CGVectorMake(xSumForce, ySumForce)];
    }
}

-(CGVector)findAForceVectorInQuadrants:(CGVector)relativeLocationInit :(double)forceInit
{
    double x = relativeLocationInit.dx;
    double y = relativeLocationInit.dy;
    
    double theta = 0;
    
    CGVector forceVector = CGVectorMake(0, 0);
    
    //TOP LEFT QUADRANT
    if(x > 0 && y > 0)
    {
        theta = atan(relativeLocationInit.dy/relativeLocationInit.dx);
        
        forceVector.dx = -cos(theta)*forceInit;
        forceVector.dy = -sin(theta)*forceInit;
    }
    //BOTTOM LEFT QUADRANT
    else if( x > 0 && y < 0)
    {
        theta = atan(fabs(relativeLocationInit.dy)/relativeLocationInit.dx);
        forceVector.dx = -cos(theta)*forceInit;
        forceVector.dy = sin(theta)*forceInit;
    }
    //TOP RIGHT QUADRANT
    else if( x < 0 && y > 0)
    {
        theta = atan(relativeLocationInit.dy/fabs(relativeLocationInit.dx));
        forceVector.dx = cos(theta)*forceInit;
        forceVector.dy = -sin(theta)*forceInit;
    }
    //BOTTOM RIGHT QUADRANT
    else
    {
        theta = atan(relativeLocationInit.dy/relativeLocationInit.dx);
        forceVector.dx = cos(theta)*forceInit;
        forceVector.dy = sin(theta)*forceInit;
    }
    
  return forceVector;
}



-(void)findNormalForce:(NSMutableArray*)planetArrayInit
{
    //I'm looking at planetI
    for (int i = 0; i < [planetArrayInit count]; i = i + 1)
    {
        Planet* planetI = [planetArrayInit objectAtIndex:i];
        
        //im looking at the universe, grabbing other planets to test
        for (int j = 0; j < [planetArrayInit count]; j = j + 1)
        {
            Planet* planetJ = [planetArrayInit objectAtIndex:j];
            
            if (j != i)
            {
                 CGVector relativeLocationVector = [self findRelativeLocation:planetI :planetJ];
                CGSize coupledPlanetSize = [self findCoupledPlanetSize:planetI :planetJ];
            
                //test if my PlanetI touches another planetJ
                if (fabs(relativeLocationVector.dx) < coupledPlanetSize.width && fabs(relativeLocationVector.dy) < coupledPlanetSize.height)
                {
                    CGVector summedForceVector = [planetI getForceVector];
                
                    //the angle that the summed force makes on planet I, will probably be different then the radial angle if there are more then two planets in the universe
                    double forceVectorTheta = atan(summedForceVector.dy/summedForceVector.dx);
                
                    //the angle that the radius makes relative to the cartesian coordinates
                    double radialTheta = atan(relativeLocationVector.dx/relativeLocationVector.dy);
                
                    //the angle that is between the raidal vector and the summed force vector
                    double alpha = forceVectorTheta + radialTheta - M_PI/2;
                    
                    //there is a negative on this force because i drew my normal vector as my radiallly inward radius vector, which is in the opposite direction
                    double normalForce = -cos(alpha)*[planetI getForce];
                
                    CGVector normalForceVector;
                
                    normalForceVector.dx = cos(radialTheta)*normalForce;
                    normalForceVector.dy = sin(radialTheta)*normalForce;
                
                    [planetI setForceVector:CGVectorMake([planetI getForceVector].dx + normalForceVector.dx, [planetI getForceVector].dy + normalForceVector.dy)];
                }
            }
        }
    }
}

#pragma mark - Set Planet Acceleration
-(void)setPlanetAcceleration:(NSMutableArray*)planetArrayInit
{
    for (Planet* aPlanet in planetArrayInit)
    {
        double xForce = [aPlanet getForceVector].dx;
        double yForce = [aPlanet getForceVector].dy;
        
        [aPlanet setAcceleration:CGVectorMake(xForce/[aPlanet getMass], yForce/[aPlanet getMass])];
    }
}

#pragma mark - Collisions

-(void)testForCollisions:(NSMutableArray*)planetArrayInit
{
    //TEST FOR COLLISIONS AND CHNAGE THEIR RESPECTIVE VELOCITES
    for (int i = 0; i < [planetArrayInit count]; i = i + 1)
    {
        Planet* planetI = [planetArrayInit objectAtIndex:i];
        
        NSMutableArray* localCollisionArray = [[NSMutableArray alloc] initWithCapacity:[planetArrayInit count]];
        
        for (int j = 0; j < [planetArrayInit count]; j = j + 1)
        {
            if (j != i)
            {
                Planet* planetJ = [planetArrayInit objectAtIndex:j];
                
                if (fabs([planetI getPosition].x - [planetJ getPosition].x) < ([planetI getSize].width/2 + [planetJ getSize].width/2) && fabs([planetI getPosition].y - [planetJ getPosition].y) < ([planetI getSize].height/2 + [planetJ getSize].height/2))
                {
                    [localCollisionArray addObject:[NSNumber numberWithInt:j]];
                }
            }
        }
        
        [collisionArray insertObject:localCollisionArray atIndex:i];
        
        if (reverseCounter == 1)
        {
            reverseCounter = 0;
            break;
        }
    }
}


-(void)collidePlanets:(NSMutableArray *)collisionArrayInit
{
    for (int i = 0; i < [collisionArrayInit count]; i = i + 1)
    {
        //GRAB A PLANET AND ITS SPECIFIC LIST OF PLANETS THAT IT TOUCHES
        NSMutableArray* insideArray = [collisionArrayInit objectAtIndex:i];
        
        //ITERATE THROUGH THAT ARRAY OF TOUCHING PLANETS
        for (int j = 0; j <  [insideArray count]; j = j + 1)
        {
            //GRAB ONE PLANET AND FINDS ITS INDEX IN THE PLANET ARRAY
            int indexOfPlanet = [[insideArray objectAtIndex:j] intValue];
            
            //CHANGE THE VELOCITIES OF BOTH PLANETS
            [self collision:indexOfPlanet :i];
            
            //GO TO THAT SPECIFIC TOUCHING PLANET AND REMOVE THE PLANET THAT IT IS TOUCHING FROM ITS LIST OF TOUCHING PLANENTS
            for (int k = 0; k < [planetArray count]; k = k + 1)
            {
                NSMutableArray* anotherInsideArray = [collisionArrayInit objectAtIndex:indexOfPlanet];
                
                //IF THE INDEXES ARE MATCHES, THEN REMOVE IT FROM ITS ARRAY SO THAT I DON'T CHANGE THEIR VELOCITES TWICE
                if ([[anotherInsideArray objectAtIndex:k] isEqualToNumber:[NSNumber numberWithInt:i]])
                {
                    [anotherInsideArray removeObjectAtIndex:k];
                    break;
                }
            }
        }
    }
    
    //DELETE ARRAYS FOR NEXT ROUND OF STEPS
    double countVect = [collisionArrayInit count];
    for(int i = countVect - 1; i > -1; i = i - 1)
    {
        NSMutableArray* arrayOfColliders = [collisionArrayInit objectAtIndex:i];
        double colliderCount = [arrayOfColliders count];
        
        for (int j = colliderCount - 1; j > -1; j = j - 1)
        {
            [arrayOfColliders removeObjectAtIndex:j];
        }
        
        [collisionArrayInit removeObjectAtIndex:i];
    }
}

-(void)collision:(double)firstIndex :(double)secondIndex
{
    double damping = 1.3;
    
    Planet* planet1 = [planetArray objectAtIndex:firstIndex];
    Planet* planet2 = [planetArray objectAtIndex:secondIndex];
    
    CGVector velocity1 = CGVectorMake([planet2 getMass]*[planet2 getVelocity].dx/(damping*[planet1 getMass]), [planet2 getMass]*[planet2 getVelocity].dy/(damping*[planet1 getMass]));
    
    CGVector velocity2 = CGVectorMake([planet1 getMass]*[planet1 getVelocity].dx/(damping*[planet2 getMass]), [planet1 getMass]*[planet1 getVelocity].dy/(damping*[planet2 getMass]));
    
    
    [planet1 setVelocity:velocity1];
    [planet2 setVelocity:velocity2];
    
}

#pragma mark - Geometry
-(CGVector)findRelativeLocation:(Planet*)planet1Init :(Planet*)planet2Init
{
    //PLANET ONE RELATIVE TO PLANET 2, SO PLANET 2 IS THE ORIGIN OF THIS COORDINATE PLANE...
    double x = [planet1Init getPosition].x - [planet2Init getPosition].x;
    double y = [planet1Init getPosition].y - [planet2Init getPosition].y;
    
    return CGVectorMake(x, y);
}

-(double)findAbsoluteDistance:(CGVector)relativeLocationInit
{
    double x = relativeLocationInit.dx;
    double y = relativeLocationInit.dy;
    
    double dist = sqrt(x*x + y*y);
    
    return dist;
}

-(CGSize)findCoupledPlanetSize:(Planet*)planet1Init :(Planet*)planet2Init
{
    
    CGSize coupledSize;
    
    coupledSize.width = [planet1Init getSize].width/2 + [planet2Init getSize].width/2;
    coupledSize.height = [planet1Init getSize].height/2 + [planet2Init getSize].height/2;
    
    return coupledSize;
}

#pragma mark - Add Planets
-(void)addPlanet
{
    double randMass = arc4random()%100 + 10;
    
    Planet* aPlanet = [[Planet alloc] init:CGVectorMake(0, 0) Acceleration:CGVectorMake(0, 0) ImageName:@"Loading" Size:CGSizeMake(randMass/2, randMass/2) View:self.view ScreenSize:screenSize];
    
    [aPlanet setMass:randMass];
    
    [planetArray addObject:aPlanet];
}

-(void)setNumOfPlanets:(int)numOfPlanetsInit
{
    numOfPlanets = numOfPlanetsInit;
}

#pragma mark - Button Actions
-(IBAction)pressMainMenuButton:(id)sender
{
    
}
-(IBAction)pressRestartButton:(id)sender
{
    for(int i = 0; i < [planetArray count]; i = i + 1)
    {
        [self addPlanet];
    }
}

#pragma mark - Notifications
- (void)declareHowManyPlanets:(NSNotification *) notification
{
    numOfPlanets = [notification.object intValue];
    
    for(int i = 0; i < numOfPlanets; i = i + 1)
    {
        [self addPlanet];
    }
    
}

@end
