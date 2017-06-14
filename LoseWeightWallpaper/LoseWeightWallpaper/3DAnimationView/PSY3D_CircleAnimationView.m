//
//  PSY3D_CircleAnimationView.m
//  3D无限循环轮播图
//
//  Created by panshuyan on 16/9/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PSY3D_CircleAnimationView.h"


@interface PSY3D_CircleAnimationView ()

//** 当前图片的下标 **//
@property (nonatomic, assign)int currentIndex;
//** 图片 **//
@property (nonatomic, strong)UIImageView *imageView;
//** 文字公告 **//
@property (nonatomic , strong) UILabel *lable;

//动画模式
@property(nonatomic,strong)NSArray * animationModeArr;

@end

@implementation PSY3D_CircleAnimationView


//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        NSLog(@"**********定时器创建好了***************");
        //动画模式
        _animationModeArr=@[@"cube", @"moveIn", @"reveal", @"fade",@"pageCurl", @"pageUnCurl", @"suckEffect", @"rippleEffect", @"oglFlip"];
        
    }
    
    return self;
}


-(void)layoutSubviews
{
  [super layoutSubviews];
  self.imageView.frame = self.bounds;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}


#pragma mark - 重写Setter方法
-(void)setPSY3D_ImageDataSource:(NSArray *)PSY3D_ImageDataSource
{
    _PSY3D_ImageDataSource = PSY3D_ImageDataSource;
    //调用显示3D广告
    [self show3DBannerView];
  
}

- (void)setPSY3D_TextDataSource:(NSArray *)PSY3D_TextDataSource
{
    _PSY3D_TextDataSource = PSY3D_TextDataSource;
    [self show3DLableView];
    // TodoSomethingElse:
    
}

/**
 * 设置两张轮播图之间的轮播间隔
 */
- (void)setAnimationDurtion:(CGFloat)animationDurtion
{
    _animationDurtion = animationDurtion;
    if (_animationDurtion > 0)
    {
        if (self.timer) {
            [self removeMyTimer:self.timer];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_animationDurtion target:self selector:@selector(changeImageAction:) userInfo:nil repeats:YES];
    }else
    {
        [self removeMyTimer:self.timer];
    }
}

- (void)removeMyTimer:(NSTimer *)timer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


//实现定时器的方法
-(void)changeImageAction:(NSTimer *)sender
{
    [self transitionAnimation:YES andAnimationMode:self.animationType];
}

- (void)show3DBannerView{
    @autoreleasepool {
        
        //创建视图并设置默认图片
        self.imageView.image=[UIImage imageNamed:self.PSY3D_ImageDataSource[0]];
        self.imageView.alpha = 1.0f;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
      
        //添加点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHandel:)];//默认点击第一张
        [self.imageView addGestureRecognizer:singleTap];
        
        //添加向左滑动手势
        UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
        leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;//左滑动方向
        [self addGestureRecognizer:leftSwipeGesture];
        
        //创建滑动的手势（向右滑动）
        UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
        rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;//右滑动
        [self addGestureRecognizer:rightSwipeGesture];
        
    }
}
- (void)clickHandel:(UITapGestureRecognizer *)tap
{
    //[self.delegate 调用控制器里的方法（自己处理）];
    // 将点击的model数据源传出去，让别人处理
    
    if (self.PSY3D_ImageDataSource.count)
    {
        NSLog(@"PSY3D类中_imageView:%ld",_imageView.tag);
        // 代理方法 点击哪张图片 在DetailHeadView实现
        if ([self.delegate respondsToSelector:@selector(ClickImg:)]) {
            [self.delegate ClickImg:_imageView.tag];
        }
        if (self.userClickBlock)
        {
            self.userClickBlock(_imageView.tag);
        }
    }
    if (self.PSY3D_TextDataSource.count)
    {
        NSLog(@"PSY3D类中_lable:%ld",_lable.tag);
        if (self.userClickBlock)
        {
            self.userClickBlock(_lable.tag);
        }
    }
    
}
#pragma mark 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:YES andAnimationMode:4];
}

#pragma mark 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:NO andAnimationMode:5];
}

- (void)show3DLableView
{
    @autoreleasepool {
        //创建视图并设置默认图片
        if (self.PSY3D_TextDataSource.count)
        {
            self.lable.text = self.PSY3D_TextDataSource[0];
        }
        

        //添加点击手势
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHandel:)];//默认点击第一张
        [self.lable addGestureRecognizer:doubleTap];
        
    }
}
#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext andAnimationMode:(int)mode
{
    @autoreleasepool {
        
        // 动画方向
        NSArray *directionSubtype = @[@"fromLeft",@"fromRight",@"fromTop",@"fromBottom"];
        //1.创建转场动画对象
        CATransition *transition=[[CATransition alloc]init];
        
        //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
        //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
        transition.type=_animationModeArr[mode];
        
        //设置子类型 （动画的方向）
        if (isNext) {
            transition.subtype=directionSubtype[self.toLeftSubtype];
        }else{
            transition.subtype=directionSubtype[self.toLeftSubtype];
        }
        //设置动画时间
        transition.duration=self.duration;
        
        
        if (self.PSY3D_ImageDataSource.count)
        {
            //3.设置转场后的新视图添加转场动画
            self.imageView.image= [UIImage imageNamed:[self getImageName:isNext]];
            //加载动画
            [self.imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
            
        }if (self.PSY3D_TextDataSource.count)
        {
            self.lable.text = [self getText:isNext];
            self.lable.textColor = [UIColor colorWithRed:(arc4random_uniform(255)/256.0) green:(arc4random_uniform(255)/256.0) blue:(arc4random_uniform(255)/256.0) alpha:1.0];
            //加载动画
            [self.lable.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
        }
    }
}

#pragma mark 取得当前图片
-(NSString *)getImageName:(BOOL)isNext
{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%self.PSY3D_ImageDataSource.count; //0，1，2，3，4，5，0，1
        
    }else{
        _currentIndex=(_currentIndex-1+self.PSY3D_ImageDataSource.count)%(int)self.PSY3D_ImageDataSource.count;//0,5,4,3,2,1,5
    }
    self.imageView.tag = _currentIndex; //标记当前的tag值
    //返回获取的图片
    return self.PSY3D_ImageDataSource[_currentIndex];
}
#pragma mark 取得当前文字
-(NSString *)getText:(BOOL)isNext
{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%self.PSY3D_TextDataSource.count; //0，1，2，3，4，5，0，1
    }else{
        _currentIndex=(_currentIndex-1+self.PSY3D_TextDataSource.count)%(int)self.PSY3D_TextDataSource.count;//0,5,4,3,2,1,5
    }
    self.lable.tag = _currentIndex; //标记当前的tag值
    //返回获取的图片
    return self.PSY3D_TextDataSource[_currentIndex];
}
#pragma mark - 懒加载
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];_imageView.tag = 0;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)lable
{
    if (!_lable)
    {
        _lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width, self.frame.size.height)];
        _lable.font = [UIFont systemFontOfSize:([UIScreen mainScreen].bounds.size.width/23)];
        _lable.tag = 0;
        _lable.userInteractionEnabled = YES;
        [self addSubview:_lable];
    }
    return _lable;
}
- (void)dealloc
{
    self.timer = nil;
    NSLog(@"动画视图PSY3D_CircleAnimationView被销毁了");
}

@end
