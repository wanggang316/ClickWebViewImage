//
//  WebImageView.h
//  ClickImageInWebView
//
//  Created by 王刚 on 14/8/5.
//  Copyright (c) 2014年 lfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImageView : UIScrollView

- (id)initWithFrame:(CGRect)frame PhotoURL:(NSString *)url fromRect:(CGRect)fromFrame dispalyView:(UIView *)displayView;


@end
