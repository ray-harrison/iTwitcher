//
//  iTwitcherSpeciesObservationDescriptionViewController.m
//  iTwitcher
//
//  Created by Raymond Harrison on 2/21/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherSpeciesObservationDescriptionViewController.h"

@interface iTwitcherSpeciesObservationDescriptionViewController ()

@end

@implementation iTwitcherSpeciesObservationDescriptionViewController

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
    self.observationNameTextField.delegate = self;
    
    _observationNameTextField.text = _observationCollection.name;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    self.observationCollection.name = _observationNameTextField.text;
    [self.observationDescriptionDelegate didChooseSave:self observationLocation:self.observationCollection];
    
}

- (IBAction)cancel:(id)sender {
    [self.observationDescriptionDelegate didCancel:self];
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.observationNameTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

@end
