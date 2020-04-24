//
//  MXTabBarItem.m
//  StoryBoardStudy
//
//  Created by 马霄 on 2020/4/24.
//  Copyright © 2020 马霄. All rights reserved.
//

#import "MXTabBarItem.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MXTabBarItem
- (void)setTitleAttribute:(NSDictionary *)attribute forState:(UIControlState)state {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self titleTextAttributesForState:state]];
    for (NSString *key in attribute) {
        
        [attributes setObject:[attribute objectForKey:key] forKey:key];
    }
    [self setTitleTextAttributes:attributes forState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    
    [self setTitleAttribute:@{NSForegroundColorAttributeName:color} forState:state];
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state {
    
    [self setTitleAttribute:@{NSFontAttributeName:font} forState:state];
}

- (void)setImageUrl:(NSString *)url forState:(UIControlState)state {
    
    if (url.length == 0) {
        return;
    }
    
    [self setImage:self.image forState:state];
    
    __weak __typeof__(self) weakSelf = self;

    SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        image = [weakSelf imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
        if (!image || error) {
            image = weakSelf.image;
        }
        [weakSelf setImage:image forState:state];
    }];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (state == UIControlStateNormal) {
        
        [self setImage:image];
    }else if (state == UIControlStateHighlighted) {
        
        [self setSelectedImage:image];
    }
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
@end
