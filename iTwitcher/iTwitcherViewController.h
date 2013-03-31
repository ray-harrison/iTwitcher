//
//  iTwitcherViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/21/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iTwitcherViewController : UICollectionViewController

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
- (NSURL *)applicationDocumentsDirectory;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addDocumentButton;
- (IBAction)addDocument:(id)sender;




@end
