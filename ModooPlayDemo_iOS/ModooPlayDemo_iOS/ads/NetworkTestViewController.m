//
//  NetworkTestViewController.m
//  TaurusAds_iOS_TestApp
//
//  Created by tang on 2019/7/10.
//  Copyright © 2019 TGCenter. All rights reserved.
//

#import "NetworkTestViewController.h"
#import "Masonry.h"
#import "AdTypeViewController.h"
#import "macro.h"

@interface NetworkTestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *netWorksDic;
@property (nonatomic, strong) NSArray *sortedArray;
@property (nonatomic, strong) NSMutableArray *adsArr;
@end

@implementation NetworkTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    _netWorksDic = @{
        @"穿山甲": @[@{@"Banner": @[@{@"Express 320*50": @"2dbe0d9b-c462-4f2f-979f-9f21725d38f1"},
                                    @{@"Express 320*100": @"13bbeb2a-d5d8-4cbd-badd-3b03e602b407"},
                                    @{@"Express 300*250": @"573379bf-7442-47f6-9fc9-3463be7c4c2a"},
                                    @{@"Express 468*60": @"28f657a1-2903-4941-bc65-a7c608ab14c8"},
                                    @{@"Express 728*90": @"63daee07-9a92-4883-a5d3-ad65ad42bb8b"}]},
                     @{@"Interstitial": @[@{@"Normal": @"f2079959-2b7d-4177-ad75-7a46f35311d8"},
                                          @{@"Express Interstitial 2:3": @"92456d12-b5ee-42e4-9a51-530e8486624f"},
                                          @{@"Express Interstitial 3:2": @"6e7dfa58-8646-4982-813e-b05ad57a671f"},
                                          @{@"Express Interstitial 1:1": @"71035fbb-1222-44db-bfbe-02088940ff9c"},
                                          @{@"FullScreenVideo": @"760f7930-2800-4a96-81f7-63b8b5d12ea4"},
                                          @{@"Express FullScreenVideo": @"6882e2d0-0dae-468a-b477-d9b1d821758b"}]},
                     @{@"FeedList":@[@{@"Custom": @"5a62d07f-ead0-4c0d-b503-aca2b87f99a6"},
                                     @{@"Express": @"1aeed505-355f-43fd-b77f-b09e4825ac59"},
                                     @{@"Draw": @"03a12353-c9a5-464b-baf7-6d2928a1838d"},
                                     @{@"Express Draw": @"10b04504-6d2a-402b-a584-1d4a9c0d875a"},
                                     @{@"Custom Banner": @"e5addad7-3512-4cd0-a57a-b4bd7969350a"},
                                     @{@"Custom Interstitial": @"ef76874e-358d-4523-b30a-d80a2dfa2e99"}]},
                     @{@"RewardedVideo":@[@{@"Normal": @"c6907083-d63a-46a7-a5b8-3ebd46a6fc72"},
                                          @{@"Express": @"6795d15d-ada9-4426-b22d-0121ec7ae395"}]},
                     @{@"Splash":@[@{@"Normal": @"2d5538a5-d686-4567-af9f-464dd3f2b956"},
                                   @{@"Express": @"9f6623b0-4485-4485-aa53-090279ec92f2"}]}],

        @"Mobrain": @[@{@"Banner": @[@{@"Express 320*50": @"a2171380-d970-4e3f-a068-34d8f7c9732a"}]},
                    @{@"Interstitial": @[@{@"Express Interstitial 2:3": @"aacb6875-2d5f-40df-a34c-bd8f78600888"},
                                         @{@"FullScreenVideo": @""},
                                         @{@"Express FullScreenVideo": @"fbd37a66-2671-4c33-9e60-ba3ea0a31217"}]},
                    @{@"FeedList":@[@{@"Custom": @"4b181d37-e059-40df-a111-10ed946422b2"},
                                    @{@"Express": @"e5176bfa-9793-4616-b5df-bf8b43364723"}]},
                    @{@"RewardedVideo":@[@{@"Normal": @""},
                                         @{@"Express": @"95f86d3e-4979-4a7d-9726-299686951c8b"}]},
                    @{@"Splash":@[@{@"Normal": @"fe578f57-7445-4ece-90ee-03aee6d55f0e"},
                                  @{@"Express": @""}]}],
        
        @"优量汇": @[@{@"Banner": @[@{@"Banner 2.0": @"522767ca-3d4f-4399-b654-ada7c06ed904"}]},
                  @{@"Interstitial": @[@{@"Interstitial 2.0 Normal": @"d978890e-23f4-4fe6-b415-f11f66270025"},
                                       @{@"Interstitial 2.0 FullScreenVideo": @"0dde0129-055e-44c7-9d0f-cb474e048707"}]},
                  @{@"FeedList":@[@{@"Custom 2.0": @"803fea96-4403-44f7-9ec9-7e96a1a91a29"},
                                  @{@"Express": @"505daf24-b197-48c7-b383-905a2d68e47c"},
                                  @{@"Express 2.0": @"e538c7a1-1c09-440c-990f-a69b87173c0e"}]},
                  @{@"RewardedVideo":@[@{@"RewardedVideo": @"b156abf1-2767-4073-a7a5-bdaf6026f032"},
                                       @{@"Express RewardedVideo": @"0086ebae-e709-4181-a1ed-cb86d36dd368"}]},
                  @{@"Splash":@[@{@"Splash": @"cfc8a9ef-0dcd-490c-b093-b1bd9ffb800c"}]}],
               
        @"快手": @[@{@"Interstitial": @[@{@"Interstitial": @"b6cd35cb-1e86-48cd-a94c-6fc325d04807"}]},
                       @{@"FeedList": @[@{@"Custom": @"5b7254a0-75cb-4164-ae68-61af6e951c66"},
                                        @{@"Express": @"86aa7899-ae1d-4b5d-9428-77b6457e9619"},
                                        @{@"Draw": @"aa705fc6-b25a-47e7-8811-98281a4eeeaf"}]},
                       @{@"RewardedVideo": @[@{@"RewardedVideo": @"6e9a103c-eca1-4ce5-bf2e-9e72191762f9"}]},
                       @{@"Splash": @[@{@"Splash": @"d2267b66-bc9f-4fbd-9b95-30fa66bd48e5"}]}]
    };
    //get all key in dic
     NSArray *keyArray = [_netWorksDic allKeys];
    
     //order key
    _sortedArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
             return[obj1 compare:obj2 options:NSNumericSearch];
     }];
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"广告测试";
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header);
        make.width.equalTo(@(250));
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [header addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.centerY.equalTo(header);
        make.width.equalTo(@(50));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    
    UITableView *networksTab = [[UITableView alloc] init];
    networksTab.delegate = self;
    networksTab.dataSource = self;
    networksTab.userInteractionEnabled = YES;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [networksTab setTableFooterView:view];

    
    [self.view addSubview:networksTab];
    
    [networksTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(2);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void) gotoBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _netWorksDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"networkCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = _sortedArray[indexPath.row];
    [cell.textLabel setTextColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AdTypeViewController *adsTestVc = [[AdTypeViewController alloc] init];
    adsTestVc.modalPresentationStyle = UIModalPresentationFullScreen;
    NSString *key = _sortedArray[indexPath.row];
    adsTestVc.titleStr =  key;

    adsTestVc.adsDic = _netWorksDic[key];

    [self presentViewController:adsTestVc animated:YES completion:nil];
}

@end
