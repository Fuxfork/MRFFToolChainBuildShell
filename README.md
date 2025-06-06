## MRFFToolChain Build Shell

**What's MRFFToolChain?**

MRFFToolChain products was built for [fsplayer](https://github.com/debugly/fsplayer) 、 [ijkplayer](https://github.com/debugly/ijkplayer) 、[FFmpegTutorial](https://github.com/debugly/FFmpegTutorial).

At present MRFFToolChain contained `ass、bluray、dav1d、dvdread、ffmpeg、freetype、fribidi、harfbuzz、openssl、opus、unibreak、uavs3d、smb2、yuv、soundtouch、xml2`.

## Supported Plat

| platform  | architectures          |   minimum deployment target |
| ----- | -------------------------------------- |----- |
| iOS   | arm64、arm64_simulator、x86_64_simulator |  11.0   |
| tvOS  | arm64、arm64_simulator、x86_64_simulator |  12.0   |
| macOS | arm64、x86_64                            |  10.11   |
| Android | arm64、armv7a、x86_64、x86              |  21   |

## News

- upgrade all libs to lastest,Improved optimizations
- using macOS 14, remove bitcode support

[https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes#Deprecations](https://developer.apple.com/documentation/xcode-release-notes/xcode-14-release-notes#Deprecations)

## Denpendency

- Fontconfig: xml2,freetype
- Bluray: xml2
- Harfbuzz: freetype
- Ass for Appple: harfbuzz,fribidi,unibreak
- Ass for Android: harfbuzz,fribidi,unibreak,fontconfig
- FFmpeg for Appple: openssl,opus,dav1d,dvdread,uavs3d,smb2
- FFmpeg for Android: openssl,opus,dav1d,dvdread,uavs3d,smb2,soundtouch

Tips: 

```
1、FFmpeg is not denpendent on Ass.
2、ijkplayer is denpendent on FFmpeg and Ass.
3、when install pre-compiled lib, will containes it's denpendencies.
```

## Folder structure

```
├── README.md
├── build       #编译目录
│   ├── extra   #源码仓库
│   ├── pre     #下载的预编译库
│   ├── product #编译产物
│   └── src     #构建时源码仓库
├── configs     #三方库配置信息
│   ├── default.sh
│   ├── ffconfig #FFmpeg功能裁剪选项
│   ├── libs     #三方库具体配置，包括库名，git仓库地址等信息
│   └── meson-crossfiles
├── do-compile   #三方库编译过程
│   ├── android  #安卓平台
│   └── apple    #苹果平台
├── do-init      #初始化三方库仓库
│   ├── copy-local-repo.sh
│   ├── init-repo.sh
│   └── main.sh
├── do-install    #下载安装预编译的三方库
│   ├── download-uncompress.sh
│   ├── install-pre-lib.sh
│   ├── install-pre-xcf.sh
│   └── main.sh
├── main.sh      #脚本入口
├── patches      #给三方库打的补丁
│   ├── bluray
│   ├── ffmpeg -> ffmpeg-n6.1
│   ├── ffmpeg-n4.0
│   ├── ffmpeg-n5.1
│   ├── ffmpeg-n6.1
│   ├── ffmpeg-release-5.1
│   ├── smb2
│   ├── smb2-4.0.0
│   ├── uavs3d
│   └── yuv
└── tools         #通用工具方法
    ├── export-android-build-env.sh
    ├── export-android-host-env.sh
    ├── export-android-pkg-config-dir.sh
    ├── export-apple-build-env.sh
    ├── export-apple-host-env.sh
    ├── export-apple-pkg-config-dir.sh
    ├── gas-preprocessor.pl
    ├── ios.toolchain.cmake
    ├── parse-arguments.sh
    └── prepare-build-workspace.sh
```

## Download/Install Pre-compiled libs

直接从 github 下载我预编译好的库，这种方式可节省大量时间。

预编译库已经将 patches 目录下的补丁全部打上了。

安装方法：

```bash
#查看帮助是个好习惯
./main.sh install --help
# 使用方式随便举例：
./main.sh install -p macos -l ffmpeg
./main.sh install -p ios -l 'ass ffmpeg'
./main.sh install -p tvos -l all
./main.sh install -p android -l all
```

## Compile by yourself

### Init lib repos

不要浪费自己的时间去编译这些库，除非你修改了源码！
直接下载我白嫖 github 预先编译好的库不好么！

脚本参数比较灵活，可根据需要搭配使用，常用方式举例：

```
#查看帮助是个好习惯
./main.sh init --help
#准备 iOS 平台源码所有库的源码
./main.sh init -p ios -l all
#准备 iOS 平台x86架构下所有库的源码
./main.sh init -p ios -l all -a x86_64_simulator
#准备 macOS 平台源码所有库的源码
./main.sh init -p macos -l all
#准备 iOS 平台的某些库的源码
./main.sh init -p ios -l "openssl ffmpeg"
#准备 Android 平台的某些库的源码
./main.sh init -p anroid -l "openssl ffmpeg"
```

### Compile

查看帮助是个好习惯

```
./main.sh compile --help
# 根据帮助可知 -p 参数指定平台；-c 参数指定行为，比如：build是编译，rebuild是重编等; -l 指定要编译的库；-a 指定 cpu 架构。
```
使用方式随便举例：

```
#比如编译 ios 平台所有依赖库
./main.sh compile -c build -p ios -l all
#比如编译 ios 平台 arm64 架构下的 libass 库
./main.sh compile -c build -p ios -a arm64 -l ass
```

脚本对于这些参数的顺序没有要求，可以随意摆放。

### Support Mirror

如果 github 上的仓库克隆较慢，或者需要使用内网私有仓库，可在执行编译脚本前声明对应的环境变量！

| 名称         | 当前版本|                仓库地址                                  | 使用镜像                                                     |
| ----------- | -------| ------------------------------------------------------- | -------------------------------------------------------- |
| FFmpeg      | 6.1.2  | https://github.com/FFmpeg/FFmpeg.git                    | export GIT_FFMPEG_UPSTREAM = git@xx:yy/FFmpeg.git        |
| ass         | 0.17.3 | https://github.com/libass/libass.git                    | export GIT_ASS_UPSTREAM = git@xx:yy/libass.git           |
| bluray      | 1.3.4  | https://code.videolan.org/videolan/libbluray.git        | export GIT_BLURAY_UPSTREAM = git@xx:yy/libbluray.git     |
| dav1d       | 1.5.1  | https://code.videolan.org/videolan/dav1d.git            | export GIT_DAV1D_UPSTREAM = git@xx:yy/dav1d.git          |
| dvdread     | 6.1.3  | https://code.videolan.org/videolan/libdvdread.git       | export GIT_DVDREAD_UPSTREAM = git@xx:yy/libdvdread.git   |
| fontconfig  | 2.16.0 | https://gitlab.freedesktop.org/fontconfig/fontconfig.git| export GIT_FONTCONFIG_UPSTREAM=git@xx:yy/fontconfig.git  |
| freetype    | 2.13.3 | https://gitlab.freedesktop.org/freetype/freetype.git    | export GIT_FREETYPE_UPSTREAM = git@xx:yy/freetype.git    |
| fribidi     | 1.0.16 | https://github.com/fribidi/fribidi.git                  | export GIT_FRIBIDI_UPSTREAM = git@xx:yy/fribidi.git      |
| harfbuzz    | 10.2.0 | https://github.com/harfbuzz/harfbuzz.git                | export GIT_HARFBUZZ_UPSTREAM = git@xx:yy/harfbuzz.git    |
| openssl     | 1.1.1w | https://github.com/openssl/openssl.git                  | export GIT_OPENSSL_UPSTREAM = git@xx:yy/openssl.git      |
| opus        | 1.5.2  | https://gitlab.xiph.org/xiph/opus.git                   | export GIT_OPUS_UPSTREAM = git@xx:yy/opus.git            |
| smb2        | 6.2    | https://github.com/sahlberg/libsmb2.git                 | export GIT_SMB2_UPSTREAM=git@xx:yy/libsmb2.git           |
| soundtouch  | 2.3.3  | https://codeberg.org/soundtouch/soundtouch.git          | export GIT_SOUNDTOUCH_UPSTREAM=git@xx:yy/soundtouch.git  |
| unibreak    | 6.1    | https://github.com/adah1972/libunibreak.git             | export GIT_UNIBREAK_UPSTREAM = git@xx:yy/libunibreak.git |
| uavs3d      | 1.2.1  | https://github.com/uavs3/uavs3d.git                     | export GIT_UAVS3D_UPSTREAM=git@xx:yy/UAVS3D.git          |
| xml2        | 2.13.6 | https://github.com/GNOME/libxml2.git                    | export GIT_FONTCONFIG_UPSTREAM=git@xx:yy/fontconfig.git  |
| yuv         | stable-eb6e7bb | https://github.com/debugly/libyuv.git           | export GIT_YUV_UPSTREAM=git@xx:yy/yuv.git                |

## Tips

- 可下载预编译的 xcframework 库，只需要在 install 时加上 --fmwk 参数
- 初始化仓库时，可跳过拉取远端到本地，只需要在 init 时加上 --skip-pull-base 参数
- 初始化仓库时，可跳过应用 FFmpeg 的补丁，只需要在 init 时加上 --skip-patches 参数
- 目前 FFmpeg 使用的是 module-full.sh 配置选项，所以包体积略大
- 可以自己把 Github 预编译的库全部下载放到自己的服务器上，在 install 前使用 MR_DOWNLOAD_BASEURL 指定自己的服务器地址

## Donate

编译三方库很费时间，本人想为开源社区贡献一份微薄的力量，因此将 debugly/ijkplayer 依赖的三方库，全部预编成静态库和 xcframework 供大家使用。

如果您想要为开源社区贡献一份力量，请买杯咖啡给我提提神儿。

![donate.jpg](https://i.postimg.cc/xdVqnBLp/IMG-7481.jpg)

感谢以下朋友对 debugly/MRFFToolChainBuildShell 的支持：

- 海阔天也空
- 小猪猪
- 1996GJ
