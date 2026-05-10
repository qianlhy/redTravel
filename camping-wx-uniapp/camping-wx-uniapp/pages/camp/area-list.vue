<template>
  <view class="area-list-page">
    <!-- 导航栏标题 -->
    <view class="page-title">选择营地区域</view>

    <!-- 区域轮播图（A/B/C区） -->
    <swiper class="area-swiper" indicator-dots autoplay interval="5000" circular>
      <swiper-item v-for="(area, index) in mainAreaList" :key="index">
        <view class="area-item" @click="goToSiteList(area.id)">
          <image :src="area.coverImage" mode="widthFix" class="area-img"></image>
          <view class="area-info">
            <text class="area-name">{{ area.areaName }}</text>
            <text class="area-desc">{{ area.areaDesc }}</text>
            <button class="enter-btn">进入预订</button>
          </view>
        </view>
      </swiper-item>
    </swiper>

    <!-- 公园帐篷区入口（单独卡片） -->
    <view class="park-area-card" @click="goToParkSiteList">
      <image src="/static/images/park-area.png" mode="widthFix" class="park-area-img"></image>
      <view class="park-area-info">
        <text class="park-area-name">公园帐篷区</text>
        <text class="park-area-desc">开放公共露营区域，自带装备即可入驻</text>
        <button class="enter-btn">进入预订</button>
      </view>
    </view>
  </view>
</template>

<script setup>
import { onLoad } from '@dcloudio/uni-app';
import { ref } from 'vue';
// 后端接口地址
const baseUrl = 'http://kko.wfeezor.cn/api';
const mainAreaList = ref([]);

// 主区域列表（A/B/C区，从数据库camp_area表获取）
// let mainAreaList = [];

// 加载主区域列表（A/B/C区）
const loadMainAreas = () => {
  uni.request({
    url: `${baseUrl}/camp/area/list`,
    method: 'GET',
    data: {
      // 筛选A/B/C区（对应数据库中area_name包含A/B/C的区域）
      areaNameLike: ['A', 'B', 'C']
    },
    success: (res) => {
      if (res.data.code === 200) {
        mainAreaList = res.data.data;
      }
    }
  });
};

// 点击区域，跳转到对应营位列表页
const goToSiteList = (areaId) => {
  uni.navigateTo({
    url: `/pages/camp/site-list?areaId=${areaId}`
  });
};

// 点击公园帐篷区，跳转到其营位列表（假设areaId=4）
const goToParkSiteList = () => {
  uni.navigateTo({
    url: `/pages/camp/site-list?areaId=4`
  });
};

// 页面加载时加载区域数据
onLoad(() => {
  loadMainAreas();
});
</script>

<style scoped>
.area-list-page {
  background: #f5f7fa;
  min-height: 100vh;
  padding: 20rpx;
}

.page-title {
  font-size: 36rpx;
  font-weight: 600;
  color: #333;
  padding: 16rpx 0;
  text-align: center;
}

/* 区域轮播 */
.area-swiper {
  height: 400rpx;
  margin-bottom: 30rpx;
}

.area-item {
  position: relative;
  height: 100%;
}

.area-img {
  width: 100%;
  height: 100%;
  border-radius: 20rpx;
}

.area-info {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 24rpx;
  background: linear-gradient(transparent, rgba(0,0,0,0.7));
  border-radius: 0 0 20rpx 20rpx;
  color: #fff;
}

.area-name {
  font-size: 32rpx;
  font-weight: 600;
  margin-bottom: 8rpx;
}

.area-desc {
  font-size: 24rpx;
  opacity: 0.9;
  margin-bottom: 16rpx;
}

.enter-btn {
  background: #E53935;
  color: #fff;
  border-radius: 30rpx;
  padding: 8rpx 24rpx;
  font-size: 24rpx;
}

/* 公园帐篷区卡片 */
.park-area-card {
  background: #fff;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.05);
}

.park-area-img {
  width: 100%;
  height: 250rpx;
}

.park-area-info {
  padding: 24rpx;
}

.park-area-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 8rpx;
}

.park-area-desc {
  font-size: 24rpx;
  color: #666;
  margin-bottom: 16rpx;
}
</style>