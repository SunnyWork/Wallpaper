//
//  PSY3D_CircleAnimationView.h
//  3D无限循环轮播图
//
//  Created by panshuyan on 16/9/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  点击图片的协议
 */
@protocol ClickImgDelegate <NSObject>
//** 点击图片的方法 **//
-(void)ClickImg:(NSInteger )index;

@end

typedef void(^userClickCallBackBlock)(NSInteger model);

@interface PSY3D_CircleAnimationView : UIView

// 动画类型
typedef NS_ENUM(NSInteger, PSY3DAnimationTpye)
{
    PSY3DAnimationTpyeCube,         //3D旋转式动画
    PSY3DAnimationTpyeMoveIn,       //向左切入动画
    PSY3DAnimationTpyeReveal,       //向左切出动画
    PSY3DAnimationTpyeFade,         //溶解淡出动画
    PSY3DAnimationTpyePageCurl,     //向左翻页动画
    PSY3DAnimationTpyePageUnCurl,   //向右翻页动画
    PSY3DAnimationTpyeSuckEffect,   //吸出消失动画
    PSY3DAnimationTpyeRippleEffect, //波纹式动画
    PSY3DAnimationTpyeOglFlip       //翻牌动画
};
// 动画方向
typedef NS_ENUM(NSInteger, PSY3DDirectionSubtype)
{
    PSY3DDirectionSubtypeFromLeft,      //从左边
    PSY3DDirectionSubtypeFromRight,     //从右边
    PSY3DDirectionSubtypeFromTop,       //从顶部
    PSY3DDirectionSubtypeFromBottom,    //从底部
};
//** 模型数据源(里面存储的是图片的URL) **//
@property (nonatomic , strong) NSArray *PSY3D_ImageDataSource;
/** 文字数据源 */
@property (strong, nonatomic) NSArray *PSY3D_TextDataSource;
//** 代理方法 **//
@property (weak, nonatomic) id <ClickImgDelegate> delegate;
/** 点击轮播图片的回调 */
@property (copy, nonatomic) userClickCallBackBlock userClickBlock;

/** 轮播时间 */
@property (assign, nonatomic) CGFloat animationDurtion;
/** 轮播时间间隔 */
@property (assign, nonatomic) CGFloat duration;
/** 轮播动画的样式 */
@property (assign, nonatomic) PSY3DAnimationTpye animationType;
/** 轮播动画向左方向 */
@property (assign, nonatomic) PSY3DDirectionSubtype toLeftSubtype;
/** 轮播动画向右方向 */
@property (assign, nonatomic) PSY3DDirectionSubtype toRightSubtype;

//** 暴露出来是为了让使用者自己手动销毁，不然会导致View销毁不掉
@property (nonatomic , strong) NSTimer *timer;// !< 时间

@end
