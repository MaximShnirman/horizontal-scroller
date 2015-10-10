//
//  HorizontalViewCell.h
//  CollectionView
//
//  Created by Maxim Shnirman on 7/20/15.
//  Copyright (c) 2015 Maxim Shnirman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;
-(void) selected;
-(void) deselected;
-(void) setImage:(UIImage*)image isGrayscale:(BOOL)isGrayscale;
@end
