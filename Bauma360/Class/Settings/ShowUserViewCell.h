//
//  SettingsTableViewShowUserCell.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/19.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowUserCellDelegate <NSObject>

@required
- (void)showImagePicker;
- (void)showCamera;
- (void)showCurUserFullHeadPortrait;
@end

@interface ShowUserViewCell : UITableViewCell

@property (nonatomic, retain) id<ShowUserCellDelegate> delegate;

- (void)setPortaintImage: (UIImage *)image;
//- (void)refreshSignStatu:(BOOL) isSigned;
- (void)initialize;

@end

