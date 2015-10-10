//
//  HorizontalScrollView.h
//  CollectionView
//
//  Created by Maxim Shnirman on 7/20/15.
//  Copyright (c) 2015 Maxim Shnirman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    single_selection = 0,
    multiple_selection,
    undefined
}
SelectionType;


@protocol HorizontalScrollViewDelegate <NSObject>
-(void) setSelectedItems:(NSArray*)selectedObjects;
@end


@interface HorizontalScrollView : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) id<HorizontalScrollViewDelegate> delegate;

-(void) setImageSize:(float)imgSize spaceBetween:(float)spaceBetween spaceTopButtom:(float)spaceTopButtom;
/**
default SelectionType is multiple_selection
 */
-(void) setSelectionType:(SelectionType)type;
/**
 setData: should be called only after setImageSize:spaceBetween:spaceTopButtom and setSelectionType: 
 */
-(void) setData:(NSArray*)dataArray;

@end

