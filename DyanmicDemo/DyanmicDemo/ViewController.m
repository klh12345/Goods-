//
//  ViewController.m
//  DyanmicDemo
//
//  Created by 中国孔 on 2019/3/12.
//  Copyright © 2019 孔令辉. All rights reserved.
//

#import "ViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

typedef void (^blocker)(NSString *str);

typedef void (^blank)(void);
@interface ViewController ()<UIScrollViewDelegate>

@property (copy, nonatomic) void (^blocker)(NSString *str);
@property (copy, nonatomic) void (^blank)(void);

@property (strong , nonatomic) UIView *line;
@property (strong , nonatomic) UIButton *currentbutton;

@property (strong , nonatomic) UIScrollView *scrollView;
@property (strong , nonatomic) NSArray*imageArray;
@property (strong , nonatomic) UIImageView *imageView;
// 把所有初始化的button 装起来
@property (strong , nonatomic)NSMutableArray *totalButton;


@end
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
   
    __block int m = 100;
    self.blocker = ^(NSString *str) {
        m = 10;
        NSLog(@"------%d",m);
        
    };
    
    self.blank = ^{
        NSLog(@"blanker的输出....");
    };
    
    
    
    
    self.blocker(@"10");
    self.blank();
//    BOOL isyes = [self judgeIsNumberByRegularExpressionWith:@"123"];
    
//    NSLog(@"%d",isyes);
    
    
    self.imageArray = @[@"dt_di_slices",@"gt_di_slices",@"pt_di_slices",@"dt_di_slices"];
    
    [self headerButton];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadimageView];
    
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    // 获取当前视图上的任意点击点
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//
//
//    NSMutableArray *mutable = [NSMutableArray array];
//
//    [mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//
//    }];
//
//
//
//}



//- (BOOL)judgeIsNumberByRegularExpressionWith:(NSString *)str
//{
//    if (str.length == 0) {
//        return NO;
//    }
//    NSString *regex = @"[0-9]*";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex]; if ([pred evaluateWithObject:str]) {
//
//        return YES;
//        }
//    return NO;
//}


// button
- (void)headerButton{
    
  
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/2 - 200/2, 30, 200, 50)];
    view.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = view;
    
    NSArray *array = @[@"热点",@"推荐",@"关注",@"话题"];
    CGFloat spaceX = 0;
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonselecter:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnX = i ? 15 + spaceX : 8;
        button.frame = CGRectMake(btnX, 5,button.frame.size.width, button.frame.size.height);
        button.tag = i + 100;
        [button sizeToFit];
        spaceX = CGRectGetMaxX(button.frame);
        
        [view addSubview:button];
        [view addSubview:self.line];
        
        [self.totalButton addObject:button];
        
        // 默认第一个选中
        if (i == 0) {
            
            button.selected = YES;
            _line.frame = CGRectMake(button.frame.origin.x, button.frame.size.height + 3, button.frame.size.width, 1);
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            self.currentbutton = button;
            
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenW *array.count, ScreenH);
    
}


- (void)buttonselecter:(UIButton *)sender{
    
    // 首先取消之前选中按钮的高亮状态
    self.currentbutton.selected = NO;
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    self.currentbutton = sender;
    self.currentbutton.selected = YES;
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    self.line.frame = CGRectMake(sender.frame.origin.x, sender.frame.size.height + 3, sender.frame.size.width, 1);
    if ([sender.currentTitle isEqualToString:@"热点"]) {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenW, ScreenH) animated:NO];
    }else if ([sender.currentTitle isEqualToString:@"推荐"]){
         [_scrollView scrollRectToVisible:CGRectMake(ScreenW, 0, ScreenW, ScreenH) animated:NO];
    }else if ([sender.currentTitle isEqualToString:@"关注"]){
        [_scrollView scrollRectToVisible:CGRectMake(ScreenW * 2, 0, ScreenW, ScreenH) animated:NO];
    }else if ([sender.currentTitle isEqualToString:@"话题"]){
        [_scrollView scrollRectToVisible:CGRectMake(ScreenW * 3, 0, ScreenW, ScreenH) animated:NO];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat pointX = scrollView.contentOffset.x;
    
    NSInteger  buttonX = pointX/ScreenW;
    UIButton *preButton = self.totalButton[buttonX];
    
    
    [self setButtonActionpoints:preButton];
    
}


- (void)setButtonActionpoints:(UIButton *)sender{
    
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.currentbutton.selected = NO;
    
    self.currentbutton= sender;
    self.currentbutton.selected = YES;
    self.currentbutton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    self.line.frame = CGRectMake(self.currentbutton.frame.origin.x, self.currentbutton.frame.size.height + 3, self.currentbutton.frame.size.width, 1);
    
    
    
    
    
}



- (void)loadimageView{
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW * i, 0, ScreenW, ScreenH)];
        _imageView.image = [UIImage imageNamed:self.imageArray[i]];
        
        [self.scrollView addSubview:self.imageView];
    }
    
}




- (UIView *)line{
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor redColor];
        
    }
    return _line;
}



- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
     
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _scrollView.delegate = self;

        _scrollView.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
    
}

- (NSMutableArray *)totalButton{
    
    if (!_totalButton) {
        
        _totalButton = [NSMutableArray array];
    }
    return _totalButton;
}


@end
