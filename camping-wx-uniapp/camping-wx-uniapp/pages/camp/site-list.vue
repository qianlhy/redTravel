<template>
  <view class="site-list-page">
    <!-- 区域标题+日期选择 -->
    <view class="top-bar">
      <text class="area-title">{{ currentArea.areaName }}营位预定</text>
      <view class="date-picker" @click="showDatePicker = true">
        <text>{{ startDate }} - {{ endDate }}</text>
        <uni-icons type="calendar" size="20" color="#999"></uni-icons>
      </view>
    </view>

    <!-- 区域地图（原型中的区域布局图） -->
    <image :src="currentArea.coverImage" mode="widthFix" class="area-map"></image>

    <!-- 营位列表 -->
    <view class="site-container">
      <view class="site-item" v-for="site in siteList" :key="site.id">
        <!-- 营位信息 -->
        <image :src="site.coverImage" mode="widthFix" class="site-img"></image>
        <view class="site-info">
          <text class="site-code">{{ site.siteCode }}</text>
          <text class="site-spec">{{ site.areaSize }}㎡ · {{ site.maxPeople }}人</text>
          <view class="tag-group">
            <text class="tag" v-for="tag in site.tags" :key="tag">{{ tag }}</text>
          </view>
          <text class="site-price">¥{{ site.price }}/晚</text>
          <button class="book-btn" @click="goToBook(site.id)">预订</button>
        </view>
      </view>
    </view>

    <!-- 日期选择弹窗 -->
    <uni-popup v-model="showDatePicker" type="bottom">
      <view class="date-popup">
        <uni-date-picker 
          type="range" 
          :start-date="new Date()" 
          @change="onDateChange"
        ></uni-date-picker>
        <button class="confirm-date-btn" @click="showDatePicker = false">确认日期</button>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { onLoad } from '@dcloudio/uni-app';
import { ref } from 'vue';

// 后端接口地址
const baseUrl = 'http://kko.wfeezor.cn/api';

// 响应式数据
const areaId = ref(''); // 当前区域ID（从路由参数获取）
const currentArea = ref({ areaName: '', coverImage: '' }); // 当前区域信息
const siteList = ref([]); // 当前区域的营位列表
const showDatePicker = ref(false);
// 默认日期（今天+明天）
const startDate = ref(new Date().toLocaleDateString());
const endDate = ref(new Date(Date.now() + 86400000).toLocaleDateString());

// 加载当前区域信息
const loadAreaInfo = () => {
  uni.request({
    url: `${baseUrl}/camp/area/detail/${areaId.value}`,
    method: 'GET',
    success: (res) => {
      if (res.data.code === 200) {
        currentArea.value = res.data.data;
      }
    }
  });
};

// 加载当前区域的营位列表
const loadSiteList = () => {
  uni.request({
    url: `${baseUrl}/camp/site-by-area`,
    method: 'GET',
    data: { areaId: areaId.value },
    success: (res) => {
      if (res.data.code === 200) {
        siteList.value = res.data.data;
      }
    }
  });
};

// 日期选择变更
const onDateChange = (e) => {
  startDate.value = e.detail.value[0].split(' ')[0];
  endDate.value = e.detail.value[1].split(' ')[0];
};

// 点击预订，跳转到预订页
const goToBook = (siteId) => {
  uni.navigateTo({
    url: `/pages/camp/book?siteId=${siteId}&startDate=${startDate.value}&endDate=${endDate.value}`
  });
};

// 页面加载时，获取路由参数中的areaId
onLoad((options) => {
  areaId.value = options.areaId;
  loadAreaInfo();
  loadSiteList();
});
</script>

<style scoped>
.site-list-page {
  background: #f5f7fa;
  min-height: 100vh;
  padding: 20rpx;
}

/* 顶部栏（区域标题+日期） */
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.area-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.date-picker {
  display: flex;
  align-items: center;
  gap: 8rpx;
  font-size: 24rpx;
  color: #666;
}

/* 区域地图 */
.area-map {
  width: 100%;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
}

/* 营位列表 */
.site-container {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  justify-content: space-between;
}

.site-item {
  width: 48%;
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.05);
}

.site-img {
  width: 100%;
  height: 200rpx;
}

.site-info {
  padding: 16rpx;
}

.site-code {
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 8rpx;
}

.site-spec {
  font-size: 22rpx;
  color: #999;
  margin-bottom: 8rpx;
}

.tag-group {
  display: flex;
  flex-wrap: wrap;
  gap: 8rpx;
  margin-bottom: 12rpx;
}

.tag {
  font-size: 20rpx;
  padding: 4rpx 12rpx;
  background: #f5fafe;
  color: #2F80ED;
  border-radius: 16rpx;
}

.site-price {
  font-size: 28rpx;
  font-weight: 600;
  color: #E53935;
  margin-bottom: 12rpx;
}

.book-btn {
  width: 100%;
  background: #2F80ED;
  color: #fff;
  border-radius: 8rpx;
  padding: 12rpx 0;
  font-size: 24rpx;
}

/* 日期选择弹窗 */
.date-popup {
  background: #fff;
  border-radius: 20rpx 20rpx 0 0;
  padding: 20rpx;
}

.confirm-date-btn {
  width: 100%;
  background: #2F80ED;
  color: #fff;
  border-radius: 8rpx;
  padding: 16rpx 0;
  font-size: 28rpx;
  margin-top: 20rpx;
}
</style>