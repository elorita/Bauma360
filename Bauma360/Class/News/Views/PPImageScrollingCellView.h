//
//  PPImageScrollingCellView.h
//  PPImageScrollingTableViewDemo
//
//  Created by popochess on 13/8/9.
//  Copyright (c) 2013年 popochess. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@class PPImageScrollingCellView;

@protocol PPImageScrollingViewDelegate <NSObject>

- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath onImages:(NSArray *)images;

@end


@interface PPImageScrollingCellView : UIView

@property (weak, nonatomic) id<PPImageScrollingViewDelegate> delegate;

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height;
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor;
- (void) setImageData:(NSArray*)collectionImageData;
- (void) setBackgroundColor:(UIColor*)color;

- (void) addThumbnail:(UIImage *) thumb withAVFile:(AVFile *)file;
- (void) clearImageList;
@end