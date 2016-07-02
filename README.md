# LoadingAnimation

## Introduction
This aniamtion is loading success animation

## How to use

you just need set the corner, background color,then `layoutIfNeeded`

```objective-c
self.loadingView.layer.cornerRadius = CGRectGetWidth(self.loadingView.frame)/2;
self.loadingView.layer.masksToBounds = YES;
self.loadingView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor;
[self.loadingView layoutIfNeeded];
```

## Gif
![](https://github.com/Yuzeyang/LoadingAnimation/raw/master/LoadingAnimation.gif)