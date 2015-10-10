//
//  HorizontalViewCell.m
//  CollectionView
//
//  Created by Maxim Shnirman on 7/20/15.
//  Copyright (c) 2015 Maxim Shnirman. All rights reserved.
//

#import "HorizontalViewCell.h"

@interface HorizontalViewCell (){
}
@end

@implementation HorizontalViewCell

@synthesize img;

- (void)awakeFromNib {
    [self setup];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setup];
}

-(void) setup {
    self.img.clipsToBounds = YES;
    self.img.layer.cornerRadius = self.img.frame.size.height / 2.0f;
}

-(void) setImage:(UIImage*)image isGrayscale:(BOOL)isGrayscale {
    if(isGrayscale)
        [img setImage:[self convertImageToGrayScale:image]];
    else
        [img setImage:image];
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image    {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

-(void) selected {
    self.img.layer.borderWidth =  4.0;
    self.img.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void) deselected {
    self.img.layer.borderWidth =  0.0;
}

@end
