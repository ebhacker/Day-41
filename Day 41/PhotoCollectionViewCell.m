//
//  PhotoCollectionViewCell.m
//  Day 41
//
//  Created by 123 on 17.06.15.
//  Copyright (c) 2015 123. All rights reserved.
//

#import "PhotoCollectionViewCell.h"


@implementation PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView =  [UIImageView new];
        [self.contentView addSubview:self.imageView];
        
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    
}

-(void)setPhoto:(NSDictionary *)photo {
    
    _photo = photo;
    
    [self downloadImage];
    
}

-(void)downloadImage {
    
    NSLog(@"%@", self.photo);
    
  //     images -> thumbnail -> url
    
    NSURL *url = [[NSURL alloc] initWithString:self.photo[@"images"][@"thumbnail"][@"url"]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        self.imageView.image = image;
    }];
    
    [task resume];
    
            

}



@end
