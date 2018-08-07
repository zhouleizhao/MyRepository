//
//  UIImageView+WebCacheNew.h
//  DaiJia
//
//  Created by MyApple on 2018/8/3.
//  Copyright © 2018 GaoBingnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebCacheNew)
- (void)sd_setImageWithURLNew:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;
@end
