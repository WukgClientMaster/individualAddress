	//
	//  WKG_VideoPreViewController.m
	//  SmartCity
	//
	//  Created by 智享城市iOS开发 on 2018/7/11.
	//  Copyright © 2018年 NRH. All rights reserved.
	//

#import "WKG_VideoPreViewController.h"
#import "WKG_SmartCity_PlayerView.h"

@interface WKG_VideoPreViewController ()
@property (strong, nonatomic) UIButton * dismis_item_button;
@property (strong, nonatomic) UIButton * sure_item_button;
@property (strong, nonatomic) WKG_SmartCity_PlayerView * playerView;
@property (strong, nonatomic) UIImage * coverImage;
@property (copy, nonatomic) NSString * videoPath;
@property (strong, nonatomic) NSURL * videoUrl;


@end

NSString * kDazzle_Video_PreViewingContentKey__ = @"kDazzle_Video_PreViewingContentKey";
@implementation WKG_VideoPreViewController

#pragma mark - IBOutlet Events
-(void)accomplishDone:(UIButton*)args{
	[self.playerView pauseVideo];
	[[NSNotificationCenter defaultCenter]postNotificationName:kDazzle_Video_PreViewingContentKey__ object:self.videoPath];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissEvents:(UIButton*)args{
	[self.playerView pauseVideo];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getter methods
-(UIButton *)sure_item_button{
	_sure_item_button = ({
		if (!_sure_item_button) {
			_sure_item_button = [UIButton buttonWithType:UIButtonTypeCustom];
			_sure_item_button.titleLabel.font = [UIFont systemFontOfSize:16.f];
			[_sure_item_button setTitle:@"下一步" forState:UIControlStateNormal];
			[_sure_item_button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
			[_sure_item_button addTarget:self action:@selector(accomplishDone:) forControlEvents:UIControlEventTouchUpInside];
		}
		_sure_item_button;
	});
	return _sure_item_button;
}

-(WKG_SmartCity_PlayerView *)playerView{
	_playerView = ({
		if (!_playerView) {
			_playerView = [[WKG_SmartCity_PlayerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
		}
		_playerView;
	});
	return _playerView;
}

-(UIButton *)dismis_item_button{
	_dismis_item_button = ({
		if (!_dismis_item_button) {
			_dismis_item_button = [UIButton buttonWithType:UIButtonTypeCustom];
			UIImage * normalImage = [UIImage imageNamed:@"qmx_tuijian_arrow"];
			[_dismis_item_button setImage:normalImage forState:UIControlStateNormal];
			[_dismis_item_button addTarget:self action:@selector(dismissEvents:) forControlEvents:UIControlEventTouchUpInside];
		}
		_dismis_item_button;
	});
	return _dismis_item_button;
}

-(instancetype)initWithVideoPth:(NSString*)videoPath coverImage:(UIImage*)coverImage{
	self = [super init];
	if (self) {
		self.videoPath = videoPath;
		self.coverImage = coverImage;
	}
	return self;
}

- (instancetype)initWithVideoURl:(NSURL *)videoUrl coverImage:(UIImage *)coverImage{
	
	self = [super init];
	if (self) {
		self.videoUrl = videoUrl;
		self.coverImage = coverImage;
	}
	return self;
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:self.playerView];
	if (self.videoPath.length) {
		[self.playerView setVideoPlayerWithFileURL:self.videoPath cover:self.coverImage];
	}else {
		[self.playerView setVideoPlayerWithLocalURL:self.videoUrl  cover:self.coverImage];
	}
	[self.view addSubview:self.dismis_item_button];
	__weak typeof(self)weakSelf = self;
	__block CGFloat padding = (12.f);
	[self.dismis_item_button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(padding);
		make.size.mas_equalTo(CGSizeMake((35), (35)));
		if (SC_iPhoneX) {
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding + 22.f);
		}else{
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding);
		}
	}];
	if ([self.done_optional isEqualToString:@"done"]) {
		[self.view addSubview:self.sure_item_button];
		[self.sure_item_button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(weakSelf.view.mas_right).mas_offset(-padding);
			make.size.mas_equalTo(CGSizeMake((65), (35)));
			if (SC_iPhoneX) {
				make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding + 22.f);
			}else{
				make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding);
			}
		}];
	}
}

-(void)setDone_optional:(NSString *)done_optional{
	_done_optional = done_optional;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
