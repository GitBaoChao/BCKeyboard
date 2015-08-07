# BCKeyboard
这是一个聊天键盘，使用方法


BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46, [UIScreen mainScreen].bounds.size.width,46)];  

bc.delegate = self;  

bc.imageArray = @[];图片数组  

bc.placeholder = @"";占位文字  

bc.placeholderColor = ;占位文字颜色  

bc.backgroundColor = [UIColor clearColor];  

bc.currentCtr = self;当前控制器

[self.view addSubview:bc];

###GitHub仓库中的图片
![](keyboard.gif)
