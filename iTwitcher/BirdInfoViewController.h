//
//  BirdInfoViewController.h
//  iTwitcher
//
//  Created by Ray Harrison on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BirdInfoViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *birdInfoView;
}

@property (nonatomic, retain) IBOutlet UIWebView *birdInfoView;
@property (nonatomic, weak) NSString *speciesName;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
//- (IBAction)done:(id)sender;

@end
