//
//  ViewController.m
//  HQTagsLabel
//
//  Created by huqi on 2018/12/22.
//  Copyright © 2018年 huqi. All rights reserved.
//

#import "ViewController.h"
#import "HQTagsLabel.h"

@interface ViewController ()

@property (nonatomic, strong) HQTagsLabel *tagsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testLabel];
}

- (void)testLabel {
    self.tagsLabel = [[HQTagsLabel alloc] initWithConfineFrame:CGRectMake(100, 100, 200, 15)];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *titleArray = @[@"1234", @"一二三四", @"ont two three four"];
    for (int i = 0; i < 3; i++) {
        HQTagLabelModel *model = [[HQTagLabelModel alloc] init];
        if ([titleArray[i] isEqualToString:@"1234"]) {
            model.tagImageUrl = @"https://pic1.58cdn.com.cn/nowater/jltx/n_v2bfaa3298620c429eb7bf69a8995c8db4.png";
        }
        model.tagTitle = titleArray[i];
        [dataArray addObject:model];
    }
    
    self.tagsLabel.dataArray = dataArray;
    [self.view addSubview:self.tagsLabel];
    
    UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    [tempButton addTarget:self action:@selector(tempClick) forControlEvents:UIControlEventTouchUpInside];
    tempButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tempButton];
}

static int tempindex = 0;

- (void)tempClick {
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSArray *titleArray = @[@"1234", @"一二三四", @"ont two three four"];
    for (int i = 0; i < 3; i++) {
        int index = (i + tempindex) % 3;
        HQTagLabelModel *model = [[HQTagLabelModel alloc] init];
        if ([titleArray[index] isEqualToString:@"1234"]) {
            model.tagImageUrl = @"https://pic1.58cdn.com.cn/nowater/jltx/n_v2bfaa3298620c429eb7bf69a8995c8db4.png";
        }
        model.tagTitle = titleArray[index];
        [dataArray addObject:model];
    }
    self.tagsLabel.dataArray = dataArray;
    tempindex ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
