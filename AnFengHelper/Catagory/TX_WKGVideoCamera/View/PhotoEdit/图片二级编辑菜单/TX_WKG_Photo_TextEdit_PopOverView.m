//
//  TX_WKG_Photo_TextEdit_PopOverView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/6.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_TextEdit_PopOverView.h"
#import "TX_WKG_PhotoMenuOptionalView.h"
@interface TX_WKG_Photo_TextEdit_PopOverView()<UITextViewDelegate>
@property (strong,readwrite,nonatomic) UITextView  * textView;
@property (strong, nonatomic) TX_WKG_PhotoMenuOptionalView * optionalView;
@end

@implementation TX_WKG_Photo_TextEdit_PopOverView

#pragma mark -getter methods
-(TX_WKG_PhotoMenuOptionalView *)optionalView{
    _optionalView = ({
        if (!_optionalView) {
            _optionalView = [[TX_WKG_PhotoMenuOptionalView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, heightEx(45))];
            _optionalView.backgroundColor = [UIColor whiteColor];
        }
        [_optionalView setPhotoMenuType:TX_WKG_PhotoMenuEdit_Clips_Optional_Type];
        __weak typeof(self)weakSelf = self;
        _optionalView.callback = ^(NSString *title) {
            if (weakSelf.optionalCallback) {
                weakSelf.optionalCallback(title, weakSelf.textView.text);
            }
        };
        _optionalView;
    });
    return _optionalView;
}

- (NSMutableDictionary *)setRichText{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:8];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[Tools colorWithHexString:@"999999"] forKey:NSForegroundColorAttributeName];
    return attributes;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.attributedText = [[NSAttributedString alloc] initWithString:@"你若安好"  attributes:[self setRichText]];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.keyboardType  = UIKeyboardTypeDefault;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.scrollEnabled = YES;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.userInteractionEnabled = YES;
        _textView.font = [UIFont systemFontOfSize:widthEx(17.f)];
        _textView.textColor = [UIColor whiteColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.typingAttributes = [self setRichText];
    }
    return _textView;
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.textView.text = text;
    }
    return self;
}
-(void)setup{
    __weak typeof(self)weakSelf = self;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.985f];
    [self.textView setInputAccessoryView:self.optionalView];
    [self addSubview:self.textView];
    __block CGFloat padding = widthEx(12.f);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(widthEx(100.f));
        make.height.mas_equalTo(@(heightEx(65)));
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView{
 
}

/**
 将要结束编辑
 @param textView textView
 @return BOOL
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
        return;
    }
    //获取文本中字体的size
    CGSize size = [self getTheSizeOfTextView:textView.text width:KScreenWidth - 50];
    //获取一行的高度
    CGSize size1 = [self getTheSizeOfTextView:@"Hello" width:textView.width];
    NSInteger i = size.height/size1.height;
    if (i > 15) {
        return;
    }
    __block CGFloat padding = widthEx(12.f);
    __weak typeof(self)weakSelf = self;
    if (i<=2) {
        //设置全局的变量存储数字如果换行就改变这个全局变量
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(widthEx(100));
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(@(heightEx(65)));
        }];
        [self.textView layoutIfNeeded];
        [self.textView updateConstraintsIfNeeded];
    }else{
        CGFloat  renderHeigh = 10 * size1.height;
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(widthEx(100));
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.height.mas_equalTo(renderHeigh);
        }];
        [self.textView layoutIfNeeded];
        [self.textView updateConstraintsIfNeeded];
    }
}
/**
 *  自适应字体
 */
-(CGSize)getTheSizeOfTextView:(NSString*)string  width:(float)width {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 80000) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:[self setRichText] context:nil];
    return rect.size;
}
@end

