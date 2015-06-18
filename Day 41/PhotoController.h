//
//  PhotoController.h
//  Day 41
//
//  Created by 123 on 18.06.15.
//  Copyright (c) 2015 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+(void) imageForPhoto : (NSDictionary *) photo size: (NSString *) size completion:(void(^)(UIImage *image))completion;


@end
