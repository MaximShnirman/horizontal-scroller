//
//  HorizontalScrollView.m
//  CollectionView
//
//  Created by Maxim Shnirman on 7/20/15.
//  Copyright (c) 2015 Maxim Shnirman. All rights reserved.
//

#import "HorizontalScrollView.h"
#import "HorizontalViewCell.h"
#import "DataType.h"

#define demo_items_amount       7
#define demo_items_bw           3

#define default_cell_size       100.0f
#define image_size              85.0f
#define image_space_between     5.0f
#define image_space_topbutton   5.0f

@interface HorizontalScrollView () {
    NSMutableArray *selectedCells;
    SelectionType selectionType;
    float imageSize;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HorizontalScrollView

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"HorizontalViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"NibCell"];
    imageSize = 0.0f;
    
    //@TBD: remove those two calls. should be called from owning controller
    [self setImageSize:image_size spaceBetween:image_space_between spaceTopButtom:image_space_topbutton];
    [self setImages];
    [self setData:nil];
    
    [self.collectionView setBackgroundColor:[UIColor magentaColor]];
    selectedCells = [[NSMutableArray alloc] init];
    selectionType = multiple_selection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public methods
-(void) setData:(NSArray*)dataArray {
    //@TBD: open this when connected
    //self.dataArray = dataArray;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void) setImageSize:(float)imgSize spaceBetween:(float)spaceBetween spaceTopButtom:(float)spaceTopButtom{
    imageSize = imgSize;
    
    CGRect rect = self.collectionView.frame;
    rect.size.height = imageSize + 2.0f * spaceTopButtom;
    [self.collectionView setFrame:rect];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(imageSize, imageSize)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:500.0f];
    [flowLayout setMinimumLineSpacing:spaceBetween];
   
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(void) setSelectionType:(SelectionType)type {
    selectionType = type;
}

#pragma mark - Private methods
//@TBD: method to be removed when connected
-(void)setImages {
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [arr addObject:[UIImage imageNamed:@"rose-beautiful-beauty-bloom.jpg"]];
    [arr addObject:[UIImage imageNamed:@"pexels-photo-2892244.jpeg"]];
    [arr addObject:[UIImage imageNamed:@"pexels-photo-1083822.jpeg"]];
    [arr addObject:[UIImage imageNamed:@"dahlia-red-blossom-bloom-60597.jpeg"]];
    [arr addObject:[UIImage imageNamed:@"marguerite-daisy-beautiful-beauty.jpg"]];
    [arr addObject:[UIImage imageNamed:@"pexels-photo-1820567.jpeg"]];
    [arr addObject:[UIImage imageNamed:@"rose-blue-flower-rose-blooms-67636.jpeg"]];
    
    for (int i=0; i<demo_items_amount; i++) {
        DataType * data = [[DataType alloc]init];
//        data.image = [arr objectAtIndex:(rand() % 7)];
        data.image = [arr objectAtIndex:i];
        data.isGrayscaled = !(demo_items_amount - i > demo_items_bw);
        [self.dataArray addObject:data];
    }
}

-(NSArray*) getSelectedItemsArray:(NSArray*)indexArray {
    NSMutableArray * selectedItems = [[NSMutableArray alloc] initWithCapacity:indexArray.count];
    
    //@TBD:change this method to return selected objects id's
    for(int i=0; i<indexArray.count; ++i) {
        [selectedItems addObject:[self.dataArray objectAtIndex:[[indexArray objectAtIndex:i] intValue]]];
    }
    
    return (NSArray*)selectedItems;
}

#pragma mark - UICollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DataType *cellData = [self.dataArray objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"NibCell";
    HorizontalViewCell *cell = (HorizontalViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(nil != cell) {
        [cell setImage:cellData.image isGrayscale:cellData.isGrayscaled];
        
        if([selectedCells containsObject:@(indexPath.row)])
            [cell selected];
        else
            [cell deselected];
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(((DataType*)[self.dataArray objectAtIndex:indexPath.row]).isGrayscaled)
        return;
    
    switch (selectionType) {
        case single_selection:
            [selectedCells removeAllObjects];
            [selectedCells addObject:@(indexPath.row)];
            break;
            
        case multiple_selection:
            if([selectedCells containsObject:@(indexPath.row)])
                [selectedCells removeObject:@(indexPath.row)];
            else
                [selectedCells addObject:@(indexPath.row)];
            break;
            
        default:
            NSLog(@"selection type is undefined");
            return;
    }
    
    if(nil != self.delegate && [self.delegate respondsToSelector:@selector(setSelectedItems:)])
        [self.delegate setSelectedItems:[self getSelectedItemsArray:selectedCells]];
    
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    
    if(0.0f == imageSize) {
        size = CGSizeMake(default_cell_size, default_cell_size);
    }
    else {
        size = CGSizeMake(imageSize, imageSize);
    }
    
    return size;
}

//@TBD:remove this when connected
- (IBAction)selectionModeClick:(id)sender {
    switch (selectionType) {
        case single_selection:
            selectionType = multiple_selection;
            break;
            
        case multiple_selection:
            selectionType = single_selection;
            break;
            
        default:
            NSLog(@"selection type is undefined");
            return;
    }
}

@end
