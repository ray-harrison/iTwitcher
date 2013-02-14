//
//  iTwitcherMapDetailsViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/1/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherMapDetailsViewController.h"

@interface iTwitcherMapDetailsViewController ()

@end

@implementation iTwitcherMapDetailsViewController

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
    [self.mapType addTarget:self action:@selector(selectMapType:) forControlEvents:UIControlEventValueChanged];
    self.mapType.selectedSegmentIndex=self.currentMapType;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectMapType:(id)sender {
    NSLog(@"Select Map Type");
    [self.mapDetailsDelegate didChooseMapType:self selectedSegmentedIndex:self.mapType.selectedSegmentIndex ];
}

@end
