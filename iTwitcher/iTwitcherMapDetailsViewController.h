//
//  iTwitcherMapDetailsViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/1/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iTwitcherMapDetailsViewController;
@protocol iTwitcherMapDetailsDelegate <NSObject>
-(void) didChooseMapType: (iTwitcherMapDetailsViewController *)controller selectedSegmentedIndex: (NSInteger)index;

@end

@interface iTwitcherMapDetailsViewController : UIViewController
@property (nonatomic, weak) id <iTwitcherMapDetailsDelegate> mapDetailsDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapType;
@property (nonatomic) NSInteger currentMapType;


- (IBAction)selectMapType:(id)sender;

@end
