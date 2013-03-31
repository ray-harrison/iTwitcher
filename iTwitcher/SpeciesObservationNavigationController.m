//
//  SpeciesObservationNavigationController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/11/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "SpeciesObservationNavigationController.h"
#import "SpeciesObservationViewController.h"

@interface SpeciesObservationNavigationController ()

@end

@implementation SpeciesObservationNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    if ([self.visibleViewController isKindOfClass:[SpeciesObservationViewController class]]){
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
