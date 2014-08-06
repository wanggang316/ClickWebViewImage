//
//  WebImageView.m
//  ClickImageInWebView
//
//  Created by 王刚 on 14/8/5.
//  Copyright (c) 2014年 lfy. All rights reserved.
//

#import "WebImageView.h"
#import "UIImageView+WebCache.h"

@interface WebImageView() <UIScrollViewDelegate>

@property (nonatomic, copy) NSString *photoURL;
@property (nonatomic, strong) UIView *dispalyView;
@property (nonatomic) CGRect fromFrame;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *downBtn;
@end

@implementation WebImageView


- (id)initWithFrame:(CGRect)frame PhotoURL:(NSString *)url fromRect:(CGRect)fromFrame dispalyView:(UIView *)displayView{
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 6.0;
//        self.contentSize = CGSizeMake(320, 568);
        self.delegate = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.fromFrame = fromFrame;
        
        
        [self.imageView setImageWithURL:[NSURL URLWithString:url]];
        [self addTapGestureForView:self];
        
        [self addSubview:self.imageView];
        
        [displayView addSubview:self];
        
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin.x = 0;
        imageFrame.origin.y = self.frame.size.height/4;
        imageFrame.size.width = self.frame.size.width;
        imageFrame.size.height = self.frame.size.height/2;
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.imageView.frame = imageFrame;
            self.backgroundColor = [[UIColor alloc]initWithWhite:0.0 alpha:0.9];
        }];
        

        [displayView addSubview:self.downBtn];
 
        
    }
    
    
    return self;
    
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.fromFrame];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _imageView;
}

//添加单击手势
- (void)addTapGestureForView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:tapGesture];
}

- (void)tapView:(UITapGestureRecognizer *)gesture {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.imageView.frame = self.fromFrame;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.downBtn removeFromSuperview];
    }];
   
}


- (UIButton *)downBtn {
    if (!_downBtn) {
        _downBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 40, 40)];
        [_downBtn setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        [_downBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}

- (void)saveImage:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];

}


#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


@end
