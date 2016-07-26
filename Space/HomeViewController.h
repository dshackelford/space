//
//  HomeViewController.h
//  Space
//
//  Created by Dylan Shackelford on 3/28/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel* titleLable;
    IBOutlet UIButton* testButton;
    IBOutlet UILabel* howManyLabel;
    IBOutlet UITextField* howManyTextField;
    
    int numOfPlanets;
}

-(IBAction)pressTestButton:(id)sender;

@end
