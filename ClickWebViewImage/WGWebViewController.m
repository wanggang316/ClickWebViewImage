//
//  WGWebViewController.m
//  ClickWebViewImage
//
//  Created by 王刚 on 14/8/6.
//  Copyright (c) 2014年 wwwlife. All rights reserved.
//

#import "WGWebViewController.h"
#import "WebImageView.h"


@interface WGWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WGWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initController{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.webView = [[UIWebView alloc] initWithFrame:screenBounds];
    NSURL *url = [NSURL URLWithString:@"http://lifox.net/mobcontent/1242.jspx?flag=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
    [self addPinGestureForView:self.webView];
    
    
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//为webview添加开合手势改变字体大小
- (void)addPinGestureForView:(UIWebView *)view {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchHandler:)];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:pinchGesture];
}

- (void)pinchHandler:(UIPinchGestureRecognizer *)gesture {
    
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            break;
        }
            
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeFontSize(%f)",1+(gesture.scale-1)*0.3]];
            break;
        }
        default:
            break;
    }
    
    
}




#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"lfyprotocol"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"http"] || [(NSString *)[components objectAtIndex:1] isEqualToString:@"https"]){
            //这个就是图片的路径
            NSString *path = [NSString stringWithFormat:@"%@:%@",[components objectAtIndex:1],[components objectAtIndex:2]];
            
            WebImageView *image = [[WebImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) PhotoURL:path fromRect:CGRectMake(((NSNumber *)components[3]).floatValue, ((NSNumber *)components[4]).floatValue, ((NSNumber *)components[5]).floatValue, ((NSNumber *)components[6]).floatValue) dispalyView:self.view];
            
            
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *str = @"var wrapDiv = document.getElementById('wrap');\
    wrapDiv.style.fontSize = 8 +'px';\
    wrapDiv.style.lineHeight = 8*1.5+'px';";
    
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"setImagesInfo()"];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
