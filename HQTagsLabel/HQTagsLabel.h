//
//  HQTagsLabel.h
//  textMethod
//
//  Created by huqi on 2018/12/22.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - -----HQTagsLabel-----
@class HQTagLabelModel;

@interface HQTagsLabel : UIView

@property (nonatomic, assign) CGFloat labelSpace;
@property (nonatomic, assign) UIEdgeInsets labelInset;
@property (nonatomic, strong) NSArray<HQTagLabelModel *> *dataArray;

- (instancetype)initWithConfineFrame:(CGRect)frame;
- (void)refreshAllTagsLayout;

@end

#pragma mark - -----HQSingleTagLabel-----
@interface HQSingleTagLabel : UIView

@property (nonatomic, strong) HQTagLabelModel *dataModel;
@property (nonatomic, assign) CGFloat confineHeight;
@property (nonatomic, weak) HQTagsLabel* contentTagsLabel;


@end


#pragma mark - -----HQTagLabelModel-----
@interface HQTagLabelModel : NSObject

@property (nonatomic, strong) UIImage *tagImage;

@property (nonatomic, copy) NSString *tagImageUrl;

@property (nonatomic, copy) NSString *tagTitle;
@property (nonatomic, strong) UIFont *tagTitleFont;
@property (nonatomic, strong) UIColor *tagTitleColor;
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, assign) CGSize layoutSize;

@end
