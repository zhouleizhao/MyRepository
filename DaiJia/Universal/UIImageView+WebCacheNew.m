//
//  UIImageView+WebCacheNew.m
//  DaiJia
//
//  Created by MyApple on 2018/8/3.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

#import "UIImageView+WebCacheNew.h"

@implementation UIImageView (WebCacheNew)
- (void)sd_setImageWithURLNew:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    NSString * str = [url absoluteString];
    if ([str containsString:@"http"]) {
        str = str;
    }else{
        str = [NSString stringWithFormat:@"%@%@",IMAGEURL,str];
    }
    url = [NSURL URLWithString:str];
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}
@end
