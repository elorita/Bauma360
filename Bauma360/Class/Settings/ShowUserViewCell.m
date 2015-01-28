//
//  SettingsTableViewShowUserCell.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/19.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ShowUserViewCell.h"
#import "LoginViewController.h"
#import "UIImage+ImageEffects.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ShareInstances.h"

static UIImage *headPortraitCache;
static NSInteger welcomeLabelHeight = 20;

@interface ShowUserViewCell() <UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation ShowUserViewCell {
    UILabel *welcomeLabel;
//    UILabel *welcomeLabel2;
    UIButton *signInButton;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    if ([self backgroundView] == nil) {
        UIImage *backgroudImage = [[UIImage imageNamed:@"signupBg.jpg"] applyLightEffect];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:backgroudImage];
        [self setBackgroundView:bgView];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self refreshSignStatu];
}

- (void)refreshSignStatu {
    AVUser *curUser = [AVUser currentUser];
    
    if (curUser != nil)
        [ShareInstances setCurrentUserHeadPortraitWithUserName:curUser.username];
        
    [self addSubview:self.portraitImageView];
    [self loadPortrait];
    
    if (welcomeLabel == nil) {
        welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 160) / 2, self.portraitImageView.frame.origin.y + self.portraitImageView.frame.size.height + 15, 160, welcomeLabelHeight)];
        [self addSubview:welcomeLabel];
    }
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont boldSystemFontOfSize:18];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = curUser == nil ? @"Hi 你好 点击登录" : [NSString stringWithFormat:@"Hi %@", [curUser objectForKey:@"nickname"]];
    
//    if (welcomeLabel2 == nil) {
//        welcomeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 260) / 2, welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height + 10, 260, welcomeLabelHeight)];
//    }
//    welcomeLabel2.textColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    welcomeLabel2.font = [UIFont boldSystemFontOfSize:15];
//    welcomeLabel2.textAlignment = NSTextAlignmentCenter;
//    welcomeLabel2.text = @"点击背景 登录建机圈 获取更多商机吧";
//    if (curUser == nil)
//        [self addSubview:welcomeLabel2];
//    else
//        [welcomeLabel2 removeFromSuperview];
}

- (void)loadPortrait {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        if (headPortraitCache == nil){
            AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
            if (imageFile != nil) {
                [imageFile getThumbnail:YES width:150 height:150 withBlock:^(UIImage * image, NSError *error) {
                    if (!error) {
                        headPortraitCache = image;
                    } else {
                        headPortraitCache = [UIImage imageNamed:@"150"];
                    }
                    self.portraitImageView.image = headPortraitCache;
                }];
            } else {
                headPortraitCache = [UIImage imageNamed:@"150"];
                _portraitImageView.image = headPortraitCache;
            }
        }
    } else {
        _portraitImageView.image = [UIImage imageNamed:@"150"];
    }
}

- (void)editPortrait {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", @"查看大图", nil];
        [choiceSheet showInView:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setPortaintImage: (UIImage *)image {
    headPortraitCache = image;
    self.portraitImageView.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    AVFile *imageFile = [AVFile fileWithName:@"headPortrait.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            AVUser *curUser = [AVUser currentUser];
            [curUser setObject:imageFile forKey:@"headPortrait"];
            [curUser save];
        } else {
            TTAlert(@"头像保存失败");
        }
    }];
}

-(void)loginStateChange:(NSNotification *)notification {
    [self refreshSignStatu];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([_delegate respondsToSelector:@selector(showCamera)])
            [_delegate showCamera];
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([_delegate respondsToSelector:@selector(showImagePicker)])
            [_delegate showImagePicker];
    } else if (buttonIndex == 2) {
        if ([_delegate respondsToSelector:@selector(showCurUserFullHeadPortrait)])
            [_delegate showCurUserFullHeadPortrait];
    }
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 75.0f; CGFloat h = w;
        CGFloat x = (self.frame.size.width - w) / 2;
        CGFloat y = 20;//(self.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _portraitImageView.layer.borderWidth = 0.5f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

@end

