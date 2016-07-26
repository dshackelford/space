//
//  HomeViewController.m
//  Space
//
//  Created by Dylan Shackelford on 3/28/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "ViewController.h"


@implementation HomeViewController : UIViewController

-(void)viewDidLoad
{
    //adding tap gesture so that i can dismiss the keyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

}


-(IBAction)pressTestButton:(id)sender
{
    numOfPlanets = [howManyTextField.text intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HowManyPlanetsNotification" object:[NSNumber numberWithInt:numOfPlanets]];
}


//Dismiss the keyboard
-(void)resignOnTap:(id)iSender
{
    [howManyTextField resignFirstResponder];
}


- (void)passDataForward
{
    ViewController* secondViewController = [[ViewController alloc] init];
    [secondViewController setNumOfPlanets:numOfPlanets]; // Set the exposed property
    [self.navigationController pushViewController:secondViewController animated:YES];
}



@end