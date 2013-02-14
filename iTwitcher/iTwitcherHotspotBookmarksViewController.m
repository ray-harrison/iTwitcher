//
//  iTwitcherHotspotBookmarksViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/1/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherHotspotBookmarksViewController.h"

@interface iTwitcherHotspotBookmarksViewController ()

@end

@implementation iTwitcherHotspotBookmarksViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editAction:(id)sender {
}

- (IBAction)bookmarkAction:(id)sender {
    
}


@end
