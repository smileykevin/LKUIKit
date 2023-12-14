//
//  LKUnreadCountLabel.m
//  CloudCC
//
//  Created by Smiley Kevin on 2021/3/29.
//  Copyright © 2023 Smiley Kevin. All rights reserved.
//

#import "LKUnreadCountLabel.h"

#import <Masonry/Masonry.h>

/// 默认的未读 Label 高度，该高度与系统 TabBar 上的未读高度一致
CGFloat const kLKUnreadCountLabelDefaultHeight = 18.0;
/// 默认未读数量字体大小
CGFloat const kLKUnreadCountLabelDefaultFontSize = 13.0;


@interface LKUnreadCountLabel ()

/// 未读 Label 在父视图上的位置
@property (nonatomic, assign) LKUnreadCountLabelPosition position;

/// 未读 Label 的高度
@property (nonatomic, assign) CGFloat unreadCountLabelHeight;
/// 未读 Label 的宽度
@property (nonatomic, assign) CGFloat unreadCountLabelWidth;
/// 未读 Label 的圆角大小
@property (nonatomic, assign) CGFloat unreadCountLabelCornerRadius;

@end

@implementation LKUnreadCountLabel

#pragma mark - init Methods
- (instancetype)initWithPosition:(LKUnreadCountLabelPosition)position {
    self = [super init];
    if (self) {
        self.position = position;
        self.textColor = UIColor.whiteColor;
        self.backgroundColor = UIColor.redColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:kLKUnreadCountLabelDefaultFontSize];
        self.layer.masksToBounds = YES;
        self.unreadCountLabelHeight = kLKUnreadCountLabelDefaultHeight;
        self.unreadCountLabelCornerRadius = kLKUnreadCountLabelDefaultHeight / 2;
    }
    return self;
}


#pragma mark - Private Custom Methods
- (void)configUnreadCountLabelWithSuperViewFrame:(CGRect)frame {
    
    // 圆形 icon 的半径
    CGFloat R = frame.size.height / 2;
    
    // 当前对象的 size
    CGSize unreadCountLabelSize = CGSizeMake(self.unreadCountLabelWidth, self.unreadCountLabelHeight);
    self.layer.cornerRadius = self.unreadCountLabelCornerRadius;

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        switch (self.position) {
            case LKUnreadCountLabelPositionTopRight: {
                // 群策消息列表，99+ 的情况会覆盖用户名，因此往左偏移 3 points
                CGFloat centerOffset = (self.unreadCountLabelWidth - self.unreadCountLabelHeight) / 2;
                if (centerOffset > 5) {
                    centerOffset -= 3;
                }
                //【右上角的位置】设置未读 Label 的圆心或左侧圆心(椭圆形的情况下)落在圆形 icon 的右上 45° 边上
                make.center.mas_equalTo(CGPointMake(R / sqrtf(2) + centerOffset, -(R / sqrtf(2))));
                break;
            }
            case LKUnreadCountLabelPositionRight:
                //【右侧位置】设置未读 Label 的右边缘距父视图的右边缘 15 point
                make.right.mas_equalTo(-15.0);
                make.top.mas_equalTo(15.0);
                break;
            default:
                break;
        }
        make.size.mas_equalTo(unreadCountLabelSize);
    }];
}


#pragma mark - Setter

/// 设置未读数量，其会控制当前对象的显示/隐藏
/// @param unreadCount 未读数量。unreadCount 为 0 则隐藏，unreadCount 大于 0 则显示。
- (void)setUnreadCount:(NSInteger)unreadCount {
    _unreadCount = unreadCount;
    if (unreadCount <= 0) {
        self.hidden = YES;
        self.text = nil;
    } else {
        self.hidden = NO;
        if (unreadCount < 10) {
            self.text = [NSString stringWithFormat:@"%@", @(unreadCount)];
            self.unreadCountLabelWidth = 18.0;
        } else if (unreadCount >= 10 && unreadCount < 100) {
            self.text = [NSString stringWithFormat:@"%@", @(unreadCount)];
            self.unreadCountLabelWidth = 24.0;
        } else {
            self.text = @"99+";
            self.unreadCountLabelWidth = 32.0;
        }
    }
    
    if (self.superview) {
        CGRect superviewFrame = self.superview.frame;
        if (CGRectEqualToRect(superviewFrame, CGRectZero) && self.superview.superview) {
            // 如果父视图是用 Masonry 设置，有可能会出现 frame 尚未计算完成的情况，导致 superviewFrame 是 CGRectZero
            // 因此此处需要给 superview 的 superview 发送 layoutIfNeeded 消息来获取 superviewFrame
            // https://www.jianshu.com/p/e71bcc7a569e
            [self.superview.superview layoutIfNeeded];
        }
        superviewFrame = self.superview.frame;
        if (!self.hidden) {
            [self configUnreadCountLabelWithSuperViewFrame:superviewFrame];
        }
    }
}


@end
