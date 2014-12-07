//
//  ResellViewCell.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/1.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Resell.h"

@protocol ResellViewCellDelegate <NSObject>
@required;
-(void)showSimuCertificate:(Resell *) resell;

@end

@interface ResellViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *summaryLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *effectiveLabel;

@property (retain, nonatomic) IBOutlet UIView *imageScrollContentView;

@property (nonatomic, assign) id<ResellViewCellDelegate> delegate;

-(IBAction)simuCertifiedClick:(id)sender;

- (void) setResell:(Resell *) value showGalleryDelegate:(id)delegate;
@end
