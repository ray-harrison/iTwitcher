//
//  iTwitcherPhotoCollectionViewCell.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/12/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"

@interface iTwitcherPhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *birdPhotoImageView;
@property (strong, nonatomic) FlickrPhoto *photo;

@end
