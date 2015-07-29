# BCKeyboard
这是一个聊天键盘，使用方法
NSArray *array = @[];更多View的图片数组  

BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46, [UIScreen mainScreen].bounds.size.width,46)];  

bc.delegate = self;  

bc.imageArray = array;  

bc.placeholder = @"";占位文字  

bc.placeholderColor = ;占位文字颜色  

bc.backgroundColor = [UIColor clearColor];  

[self.view addSubview:bc];

## 密码键盘效果图


![](https://github.com/baochao/BCKeyBoard/raw/master/readmeImage/keyboard.gif)

