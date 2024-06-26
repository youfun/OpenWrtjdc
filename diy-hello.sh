#!/bin/bash

# 修改默认IP
# sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}


#删掉垃圾源
sed -i "/kenzok8/d" "feeds.conf.default"
rm -rf package/feeds/small
rm -rf package/feeds/kenzo

rm -rf package/luci-app-mwan3helper


# 添加额外插件
#git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

git clone  https://github.com/xiaozhuai/luci-app-filebrowser package/luci-app-filebrowser

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages  package/Hysteria

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages  package/simple-obfs



git clone https://github.com/gngpp/luci-theme-design.git  package/luci-theme-design

#分流
git clone  https://github.com/padavanonly/luci-app-mwan3helper-chinaroute


# 科学上网插件
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld

#rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

git clone https://github.com/muink/luci-app-homeproxy

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2


# 更改 Argon 主题背景
#cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg


#DDNS-go
git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go

#luci-app-zerotier
#git clone https://github.com/rufengsuixing/luci-app-zerotier.git package/luci-app-zerotier


# iStore
#git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
#git_sparse_clone main https://github.com/linkease/istore luci

# 在线用户
#git_sparse_clone main https://github.com/haiibo/packages luci-app-onliner
#sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
#sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
#chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh





provided_config_lines=(
"CONFIG_PACKAGE_luci-app-passwall2=y"
"CONFIG_PACKAGE_luci-app-filebrowser=y"
"CONFIG_PACKAGE_luci-app-mwan3helper=y"
"CONFIG_PACKAGE_luci-app-homeproxy=y"
"CONFIG_PACKAGE_Hysteria=y"
"CONFIG_PACKAGE_simple-obfs=y"
)

# Path to the .config file
config_file_path=".config" 

# Append lines to the .config file
for line in "${provided_config_lines[@]}"; do
    echo "$line" >> "$config_file_path"
done


./scripts/feeds update -a
./scripts/feeds install -a
