//
//  HQTagsLabel.m
//  textMethod
//
//  Created by huqi on 2018/12/22.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "HQTagsLabel.h"
#import "SDWebImageManager.h"


#define RGBColor(RED, GREEN, BLUE)  [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1]
#define MAXTagLabelNum  8

#pragma mark - -----HQTagsLabel-----
@class HQSingleTagLabel;
@interface HQTagsLabel ()

@property (nonatomic, strong) NSMutableArray <HQSingleTagLabel *>*tagLabelArray;

@end

@implementation HQTagsLabel

- (instancetype)initWithConfineFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMethod];
        [self reFreshUI];
    }
    return self;
}

- (void)initMethod {
    self.tagLabelArray = [[NSMutableArray alloc] initWithCapacity:MAXTagLabelNum];
    self.labelSpace = 4;
    self.labelInset = UIEdgeInsetsMake(0, 0, 0, 0);
    for (int i = 0; i < MAXTagLabelNum; i++) {
        HQSingleTagLabel *tagLabel = [[HQSingleTagLabel alloc] init];
        tagLabel.contentTagsLabel = self;
        [self addSubview:tagLabel];
        [self.tagLabelArray addObject:tagLabel];
    }
}

- (void)setDataArray:(NSArray<HQTagLabelModel *> *)dataArray {
    if (_dataArray == dataArray) {
        return;
    }
    _dataArray = dataArray;
    [self reFreshUI];
}

- (void)reFreshUI {
    for (int i = 0; i < MAXTagLabelNum; i++) {
        HQSingleTagLabel *singleTagLabel = self.tagLabelArray[i];
        singleTagLabel.confineHeight = CGRectGetHeight(self.frame) - self.labelInset.top - self.labelInset.bottom;
        if (i < self.dataArray.count) {
            singleTagLabel.hidden = NO;
            HQTagLabelModel * model = self.dataArray[i];
            singleTagLabel.dataModel = model;
        } else {
            singleTagLabel.hidden = YES;
            continue;
        }
    }
}

- (void)refreshAllTagsLayout {
    CGFloat standardY = self.labelInset.left;
    int i = 0;
    for (i = 0; i < MAXTagLabelNum; i++) {
        HQSingleTagLabel *singleTagLabel = self.tagLabelArray[i];
        if (singleTagLabel.dataModel) {
            if ((singleTagLabel.dataModel.layoutSize.width + standardY) <= (CGRectGetWidth(self.bounds) + self.labelInset.right)) {
                singleTagLabel.frame = CGRectMake(standardY, self.labelInset.top, singleTagLabel.dataModel.layoutSize.width, singleTagLabel.dataModel.layoutSize.height);
                singleTagLabel.hidden = NO;
                if (singleTagLabel.bounds.size.width != 0) {
                    standardY += CGRectGetWidth(singleTagLabel.bounds) + self.labelSpace;
                }
                continue;
            }
        }
        singleTagLabel.hidden = YES;
        break;
    }
    for (; i < MAXTagLabelNum; i ++) {
        HQSingleTagLabel *singleTagLabel = self.tagLabelArray[i];
        singleTagLabel.hidden = YES;
    }
}

@end

#pragma mark - -----HQSingleTagLabel-----

@interface HQSingleTagLabel ()

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *tagImageView;

@end

@implementation HQSingleTagLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.tagImageView) {
        self.tagImageView.frame = self.bounds;
    }
    if (self.tagLabel) {
        self.tagLabel.frame = self.bounds;
    }
}

- (void)setDataModel:(HQTagLabelModel *)dataModel {
    if (_dataModel == dataModel) {
        return;
    }
    _dataModel = dataModel;
    [self setImageOrTitle];
}

- (void)initMethod {
    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.layer.borderWidth = (1 / [UIScreen mainScreen].scale);
    self.tagLabel.layer.cornerRadius = 1.5;
    [self addSubview:self.tagLabel];
    
    self.tagImageView = [[UIImageView alloc] init];
    [self addSubview:self.tagImageView];
}

- (void)setImageOrTitle {
    if (self.dataModel) {
        //优先级最高
        if (self.dataModel.tagImage || self.dataModel.tagImageUrl) {
            self.tagImageView.hidden = NO;
            self.tagLabel.hidden = YES;
            if (self.dataModel.tagImage) {
                self.tagImageView.image = self.dataModel.tagImage;
            } else if (self.dataModel.tagImageUrl) {
                __weak typeof(self) weakSelf = self;
                __weak typeof(self.dataModel) weakModel = self.dataModel;
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.dataModel.tagImageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (weakSelf && weakModel) {
                        if (finished && image) {
                            weakModel.tagImage = image;
                            if ([imageURL.absoluteString isEqualToString:weakModel.tagImageUrl]) {
                                weakSelf.tagImageView.image = image;
                                [weakSelf needSetLayoutSize];
                            }
                        } else {
                            [weakSelf reFreshSelfWithTitleLabel];
                        }
                    }
                }];
            }
        } else if (self.dataModel.tagTitle) {
            [self reFreshSelfWithTitleLabel];
        }
    } else {
        self.frame = CGRectZero;
        self.hidden = YES;
    }
}

- (void)reFreshSelfWithTitleLabel {
    if (self.dataModel.tagTitle) {
        self.tagLabel.hidden = NO;
        self.tagImageView.hidden = YES;
        self.tagLabel.textAlignment = NSTextAlignmentCenter;
        self.tagLabel.text = self.dataModel.tagTitle;
        self.tagLabel.textColor = self.dataModel.tagTitleColor;
        self.tagLabel.layer.borderColor = self.dataModel.tagBorderColor.CGColor;
        self.tagLabel.font = self.dataModel.tagTitleFont;
        [self needSetLayoutSize];
    }
}

- (void)needSetLayoutSize {
    if (self.dataModel) {
        if (CGSizeEqualToSize(self.dataModel.layoutSize, CGSizeZero)) {
            if (self.dataModel.tagImage.size.height != 0) {
                CGFloat tempWeight = self.dataModel.tagImage.size.width / self.dataModel.tagImage.size.height * self.confineHeight;
                self.dataModel.layoutSize = CGSizeMake(tempWeight, self.confineHeight);
                if (self.contentTagsLabel) {
                    [self.contentTagsLabel refreshAllTagsLayout];
                }
            } else if (self.dataModel.tagTitle) {
                CGSize tempSize = [self.dataModel.tagTitle sizeWithAttributes:@{NSFontAttributeName : self.dataModel.tagTitleFont}];
                if (tempSize.height > self.confineHeight) {
                    self.dataModel.layoutSize = CGSizeZero;
                } else {
                    CGFloat tempInset = (self.confineHeight - tempSize.height) / 2.0;
                    self.dataModel.layoutSize = CGSizeMake(tempSize.width + tempInset + tempInset, self.confineHeight);
                    if (self.contentTagsLabel) {
                        [self.contentTagsLabel refreshAllTagsLayout];
                    }
                }
            }
        }
    }
}

@end

#pragma mark - -----HQTagLabelModel-----
@implementation HQTagLabelModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initMethod];
    }
    return self;
}

- (void)initMethod {
    self.tagTitleFont = [UIFont systemFontOfSize:10];
    self.tagTitleColor = RGBColor(73, 172, 242);
    self.tagBorderColor = RGBColor(73, 172, 242);
    self.tagBackgroundColor = UIColor.clearColor;
    self.layoutSize = CGSizeZero;
}
@end
