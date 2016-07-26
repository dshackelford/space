//
//  Ship.h
//  Space
//
//  Created by Dylan Shackelford on 3/18/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import "MyObject.h"

//double deltaTime = 0.01;

@interface Ship : MyObject
{
    

    
}


-(void)updateAcceleration:(double)forceInit Direction:(CGVector)directionVectorInit;

@end
