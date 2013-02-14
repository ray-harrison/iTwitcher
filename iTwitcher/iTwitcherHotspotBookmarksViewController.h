//
//  iTwitcherHotspotBookmarksViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/1/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iTwitcherHotspotBookmarksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationBar *bookmarkNavigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkDoneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkEditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarSegmentedControlButton;
@property (weak, nonatomic) IBOutlet UIToolbar *bookmarkToolbar;
- (IBAction)doneAction:(id)sender;
- (IBAction)editAction:(id)sender;
- (IBAction)bookmarkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;

@end
