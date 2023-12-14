//
//  LKUnreadCountLabel.h
//  CloudCC
//
//  Created by Smiley Kevin on 2021/3/29.
//  Copyright © 2023 Smiley Kevin. All rights reserved.
//
//  该控件设计初衷是将分散代码集中起来，并且方便使用
//
//  使用方式：
//  Step 1. 使用 - initWithPosition: 构造方法初始化
//  Step 2. 将实例添加到父视图
//  Step 3. 在需要设置未读数量的业务逻辑处设置 unreadCount
//
//  注意事项：
//  1. ⚠️请务必先将实例添加到父视图，再设置 unreadCount！⚠️
//     ⚠️请务必先将实例添加到父视图，再设置 unreadCount！⚠️
//     ⚠️请务必先将实例添加到父视图，再设置 unreadCount！⚠️
//  2. 如果目标父视图设置了 clipsToBounds = YES 或者 layer.masksToBounds = YES，
//     请勿直接将 LKUnreadCountLabel 实例添加到目标父视图，
//     此时可以在目标父视图相同位置添加一个坐标与其完全一致的 containerView 作为父视图，
//     并将 LKUnreadCountLabel 实例作为子视图添加到此 containerView 上
//  3. LKUnreadCountLabel 实例的显示/隐藏，仅由 unreadCount 即可控制，
//     如果需要除 unreadCount 外的其他业务条件判断隐藏，
//     请在业务逻辑代码处设置 hidden = YES，并且一定不要设置 unreadCount，
//     或者直接设置 unreadCount = 0 即可，
//     如果同一逻辑处又需要将其显示，只需要设置 unreadCount 即可，无需设置 hidden = NO
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKUnreadCountLabelPosition) {
    LKUnreadCountLabelPositionTopRight = 0,        // 位于父视图的右上角，通常用于圆形 Icon 右上角展示，目前默认其宽高相等
    LKUnreadCountLabelPositionRight    = 1         // 位于父视图的最右侧，通常用于 Cell 最右侧展示
};

NS_ASSUME_NONNULL_BEGIN

@interface LKUnreadCountLabel : UILabel


/// 自定义构造方法
/// @warning 为防止 position 的缺失，请务必使用该构造方法进行控件的初始化
/// @param position 当前 Label 在父视图上的位置，目前有 TopRight（右上角） 和 Right（最右侧） 两个位置
- (instancetype)initWithPosition:(LKUnreadCountLabelPosition)position;

/// 未读消息数量
@property (nonatomic, assign) NSInteger unreadCount;

@end

NS_ASSUME_NONNULL_END
