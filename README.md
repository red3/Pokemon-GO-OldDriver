# Pokemon-GO-OldDriver

不越狱，足不出户玩 Pokemon GO.

## Preview

![IMG_1329.PNG](http://ww4.sinaimg.cn/large/72f96cbajw1f5y6dchotgj208w0ftgop.jpg)

看你老司机的方向盘了吗？哈哈

## 如何安装

**First of all** : 把 `pokemon-go-olddriver-unsigned.zip` 文件的后缀改成 `ipa`.

然后下载重签名工具，戳[这个链接](https://dantheman827.github.io/ios-app-signer/)下载。

重点来了：

![16:55:19.jpg](http://ww3.sinaimg.cn/large/72f96cbajw1f5y5wepzyhj210a0baacy.jpg)


### 如果你是开发者

打开重签名工具，替换自己的证书和描述文件，然后签名就好了。需要注意如果你的描述文件不是 `com.*`的话，你需要打开压缩包，修改里面的 Info.Plist 为你的描述文件对应的 Bundle ID.

### 如果你不是开发者

Xcode7 允许非开发者在自己的设备上开发软件。所以你需要下载 Xcode，然后注册自己的证书和描述文件。参考这个[教程](http://blog.csdn.net/imanapple/article/details/50133151)来一发。

这样你就相当于是个开发者了，参考上面的办法安装。

由于个人用户的证书并没有全部的开发权限（例如推送等），我稍后会自己试验下个人用户的证书是否可以成功安装。

### Windows 用户？

我也救不你了 :)

## Knowing issues

在试验的过程中，发现 CLLocationManager 的代理平均 5s 触发一次，导致方向盘点了几下后才会移动，正在想办法解决。

如果你是开发者，并且有更好的 ideas，欢迎 issue.

## 最后

本 Repo 以技术交流为目的，大家玩的开心就好。



## 参考链接
1. [https://github.com/rpplusplus/PokemonHook](https://github.com/rpplusplus/PokemonHook)













