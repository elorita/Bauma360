//
//  ResellViewCell.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/1.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ResellViewCell.h"
#import "PPImageScrollingCellView.h"

#define kScrollingViewHieght 72
#define kStartPointY 0

@implementation ResellViewCell
{
    Resell *_myResell;
    PPImageScrollingCellView *_imageScrollingView;
}

@synthesize titleLabel, summaryLabel, priceLabel, effectiveLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize{
    _imageScrollingView = [[PPImageScrollingCellView alloc] initWithFrame:CGRectMake(0, kStartPointY, 320, kScrollingViewHieght)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setResell:(Resell *) value showGalleryDelegate:(id)delegate {
    _myResell = value;
    titleLabel.text = value.title;
    summaryLabel.text = value.summary;
    priceLabel.text = [NSString stringWithFormat:@"¥%d", value.price];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    effectiveLabel.text = [dateFormatter stringFromDate: value.effectiveDate];
    
    AVQuery *query = [value.images query];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            if ([objects count] > 0){
                [self->_imageScrollingView clearImageList];
                self->_imageScrollingView.delegate = delegate;
                self->_imageScrollingView.backgroundColor = [UIColor clearColor];
                [self.imageScrollContentView addSubview:self->_imageScrollingView];
            }
            
            NSMutableArray *images = [[NSMutableArray alloc] init];
            for (ResellImage *imageFile in objects) {
                //todo:最初根据images的count先创建滚动视图，随后每返回一个thumb，则向滚动视图刷新一个图片
                [imageFile.image getThumbnail:YES width:144 height:144 withBlock:^(UIImage *image, NSError *error) {
                    if (!error){
                        [self->_imageScrollingView addThumbnail:image withAVFile:imageFile.image];
                    }
                }];
            }
        }
    }];
}

-(IBAction)simuCertifiedClick:(id)sender{
    if ([_delegate respondsToSelector:@selector(showSimuCertificate:)]) {
        [_delegate showSimuCertificate: _myResell];
    }
}

@end
