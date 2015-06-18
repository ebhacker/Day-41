//
//  ViewController.m
//  Day 41
//
//  Created by 123 on 17.06.15.
//  Copyright (c) 2015 123. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import <SimpleAuth/SimpleAuth.h>

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSString *accessTooken;
@property(nonatomic) NSMutableArray *photos;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessTooken = [userDefaults objectForKey:@"accessTooken"];
    if (self.accessTooken == nil) {
        
    [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
       
        self.accessTooken = responseObject[@"credentials"] [@"token"];
        
        NSLog(@"access token = %@", self.accessTooken); 
        [userDefaults setObject:self.accessTooken forKey:@"accessTooken"];
        [userDefaults synchronize];
        
        NSLog(@"saved credentials");
        [self downloadImages];
        
        
    }];
        
    } else {
        NSLog(@"using previous credentials");
        [self downloadImages];
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper methods

-(void) downloadImages {
    NSURLSession *sessions = [NSURLSession sharedSession];
    NSString  *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/cars/media/recent?access_token=%@",self.accessTooken];
    NSLog(@"%@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [sessions downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSLog(@"response is : %@",response);
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"response dictionary is : %@",responseDictionary);
        
        self.photos = responseDictionary[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.collectionView reloadData];
        });
        
       
        
    }];
    
     [task resume];
                                      
}

#pragma mark - UICollectionView methods 

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return newly  created Cell
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
 //  cell.imageView.image = [UIImage imageNamed:@"car_image.jpg"];
    
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.photo = photo;
    return cell;
    
    
}

@end
