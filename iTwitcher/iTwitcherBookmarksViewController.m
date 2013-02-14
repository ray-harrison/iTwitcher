//
//  iTwitcherBookmarksViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/30/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherBookmarksViewController.h"

@interface iTwitcherBookmarksViewController ()

@end

@implementation iTwitcherBookmarksViewController

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
