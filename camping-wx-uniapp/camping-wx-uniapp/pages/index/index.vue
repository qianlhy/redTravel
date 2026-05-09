<!-- 红色旅游首页 -->
<template>
  <view class="index-page">

    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view style="width:40px"></view>
        <text class="nav-title">红色旅游</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 顶部背景装饰 -->
    <view class="hero-bg"></view>

    <!-- 轮播图 -->
    <swiper class="banner-swiper" indicator-dots autoplay interval="4000" circular indicator-active-color="#C41E3A">
      <swiper-item v-for="(banner, index) in bannerList" :key="index" @click="onBannerClick(banner)">
        <image :src="banner.image" mode="aspectFill" class="banner-img"></image>
        <view class="banner-overlay">
          <text class="banner-title">{{ banner.title }}</text>
        </view>
      </swiper-item>
    </swiper>

    <!-- 搜索栏 -->
    <view class="search-bar">
      <input class="search-input" v-model="keyword" placeholder="搜索景点或路线名称" placeholder-class="search-placeholder" @confirm="handleSearch" />
      <view class="search-btn" @click="handleSearch">
        <text class="search-icon">🔍</text>
      </view>
    </view>

    <!-- 快速入口 -->
    <view class="quick-entry">
      <view class="entry-item" @click="goToAttractionList">
        <view class="entry-icon">🏛</view>
        <view class="entry-text">红色景点</view>
        <view class="entry-desc">铭记历史</view>
      </view>
      <view class="entry-item" @click="goToRouteList">
        <view class="entry-icon">🗺</view>
        <view class="entry-text">精品路线</view>
        <view class="entry-desc">传承精神</view>
      </view>
      <view class="entry-item" @click="goToBookingForm(null)">
        <view class="entry-icon">📋</view>
        <view class="entry-text">团队预约</view>
        <view class="entry-desc">便捷出行</view>
      </view>
      <view class="entry-item" @click="goToMyOrders">
        <view class="entry-icon">📜</view>
        <view class="entry-text">我的预约</view>
        <view class="entry-desc">订单管理</view>
      </view>
    </view>

    <!-- 红色景点推荐 -->
    <view class="module-wrap" v-if="attractionList.length > 0">
      <view class="module-header">
        <view class="module-title-row">
          <view class="title-icon">🏛</view>
          <text class="module-title">红色景点</text>
          <view class="title-tag">推荐</view>
        </view>
        <view class="more-btn" @click="goToAttractionList">更多 ›</view>
      </view>
      <scroll-view class="attraction-scroll" scroll-x enable-flex>
        <view class="attraction-card" v-for="item in attractionList" :key="item.id" @click="goToAttractionDetail(item.id)">
          <image :src="item.cover || item.coverImage" mode="aspectFill" class="attraction-img"></image>
          <view class="attraction-info">
            <text class="attraction-name">{{ item.name }}</text>
            <text class="attraction-location">{{ item.province }} · {{ item.city }}</text>
            <view class="attraction-price" v-if="item.ticketPrice > 0">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ item.ticketPrice }}</text>
              <text class="price-unit">/人</text>
            </view>
            <view class="attraction-price free" v-else>
              <text>免费参观</text>
            </view>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 精品路线推荐 -->
    <view class="module-wrap" v-if="routeList.length > 0">
      <view class="module-header">
        <view class="module-title-row">
          <view class="title-icon">🗺</view>
          <text class="module-title">精品路线</text>
          <view class="title-tag red">热门</view>
        </view>
        <view class="more-btn" @click="goToRouteList">更多 ›</view>
      </view>
      <view class="route-list">
        <view class="route-card" v-for="item in routeList" :key="item.id" @click="goToRouteDetail(item.id)">
          <image :src="item.cover || item.coverImage" mode="aspectFill" class="route-img"></image>
          <view class="route-body">
            <view class="route-top">
              <text class="route-theme" v-if="item.theme">{{ item.theme }}</text>
              <text class="route-name">{{ item.name }}</text>
            </view>
            <view class="route-meta">
              <text class="meta-item">🗓 {{ item.durationDays }}天</text>
              <text class="meta-item">👥 {{ item.groupSize }}人团</text>
            </view>
            <view class="route-footer">
              <view class="route-price">
                <text class="price-symbol">¥</text>
                <text class="price-num">{{ item.price }}</text>
                <text class="price-unit">/人</text>
              </view>
              <view class="route-book-btn">立即预约</view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 空状态 -->
    <view class="empty-state" v-if="attractionList.length === 0 && routeList.length === 0 && !loading">
      <view class="empty-icon">🏛</view>
      <view class="empty-text">暂无数据</view>
      <view class="empty-sub">请检查后端服务是否启动</view>
    </view>

    <!-- 底部安全区 -->
    <view style="height: 120rpx"></view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const bannerList = ref([]);
const attractionList = ref([]);
const routeList = ref([]);
const keyword = ref('');
const loading = ref(false);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadData();
});

// 加载所有数据
const loadData = async () => {
  loading.value = true;
  await Promise.allSettled([
    loadBanners(),
    loadAttractions(),
    loadRoutes(),
  ]);
  loading.value = false;
};

// 加载轮播图
const loadBanners = async () => {
  try {
    const res = await h5Api.getBannerList();
    bannerList.value = res.data || [];
  } catch (e) {
    // 降级：使用默认轮播图
    bannerList.value = [
      { id: 1, title: '传承红色基因', image: 'https://picsum.photos/750/400?random=1' },
      { id: 2, title: '庆祝建党百年', image: 'https://picsum.photos/750/400?random=2' },
      { id: 3, title: '红色旅游精品路线', image: 'https://picsum.photos/750/400?random=3' },
    ];
  }
};

// 加载景点列表
const loadAttractions = async () => {
  try {
    const res = await h5Api.getRecommendAttractions();
    attractionList.value = (res.data || []).slice(0, 6);
  } catch (e) {
    attractionList.value = [];
  }
};

// 加载路线列表
const loadRoutes = async () => {
  try {
    const res = await h5Api.getRecommendRoutes();
    routeList.value = (res.data || []).slice(0, 5);
  } catch (e) {
    routeList.value = [];
  }
};

// 搜索
const handleSearch = () => {
  if (!keyword.value.trim()) {
    uni.showToast({ title: '请输入关键词', icon: 'none' });
    return;
  }
  uni.navigateTo({ url: `/pages/attraction/list?keyword=${encodeURIComponent(keyword.value)}` });
};

// 轮播图点击
const onBannerClick = (banner) => {
  if (banner.linkType === 'attraction' && banner.linkValue) {
    uni.navigateTo({ url: `/pages/attraction/detail?id=${banner.linkValue}` });
  } else if (banner.linkType === 'route' && banner.linkValue) {
    uni.navigateTo({ url: `/pages/route/detail?id=${banner.linkValue}` });
  }
};

// 跳转景点列表
const goToAttractionList = () => {
  uni.navigateTo({ url: '/pages/attraction/list' });
};

// 跳转景点详情
const goToAttractionDetail = (id) => {
  uni.navigateTo({ url: `/pages/attraction/detail?id=${id}` });
};

// 跳转路线列表
const goToRouteList = () => {
  uni.navigateTo({ url: '/pages/route/list' });
};

// 跳转路线详情
const goToRouteDetail = (id) => {
  uni.navigateTo({ url: `/pages/route/detail?id=${id}` });
};

// 跳转预约表单
const goToBookingForm = (routeId) => {
  uni.navigateTo({ url: `/pages/booking/form${routeId ? '?routeId=' + routeId : ''}` });
};

// 跳转我的预约
const goToMyOrders = () => {
  uni.switchTab({ url: '/pages/booking/order' });
};
</script>

<style scoped>
.index-page {
  background: #f5f5f5;
  min-height: 100vh;
}

/* 顶部导航 */
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 999;
  background: linear-gradient(135deg, #C41E3A, #8B0000);
}
.nav-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 44px;
  padding: 0 24rpx;
}
.nav-title {
  font-size: 34rpx;
  font-weight: 700;
  color: #fff;
  letter-spacing: 2rpx;
}

/* 顶部背景 */
.hero-bg {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 400rpx;
  background: linear-gradient(135deg, #C41E3A, #8B0000);
  z-index: -1;
}

/* 轮播图 */
.banner-swiper {
  width: 100%;
  height: 360rpx;
  border-radius: 16rpx;
  overflow: hidden;
  margin: 16rpx 24rpx;
  width: calc(100% - 48rpx);
  position: relative;
}
.banner-img {
  width: 100%;
  height: 100%;
}
.banner-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0,0,0,0.6));
  padding: 40rpx 24rpx 20rpx;
}
.banner-title {
  font-size: 30rpx;
  font-weight: 600;
  color: #fff;
}

/* 搜索栏 */
.search-bar {
  display: flex;
  align-items: center;
  background: #fff;
  margin: 0 24rpx 16rpx;
  border-radius: 40rpx;
  padding: 0 8rpx 0 32rpx;
  height: 80rpx;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.08);
}
.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  height: 80rpx;
}
.search-placeholder {
  color: #bbb;
  font-size: 28rpx;
}
.search-btn {
  width: 72rpx;
  height: 72rpx;
  background: linear-gradient(135deg, #C41E3A, #8B0000);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.search-icon {
  font-size: 28rpx;
}

/* 快速入口 */
.quick-entry {
  display: flex;
  justify-content: space-around;
  background: #fff;
  margin: 0 24rpx 16rpx;
  border-radius: 16rpx;
  padding: 24rpx 0;
  box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.06);
}
.entry-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}
.entry-icon {
  width: 88rpx;
  height: 88rpx;
  background: linear-gradient(135deg, #FFF5F5, #FFE8E8);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  margin-bottom: 12rpx;
}
.entry-text {
  font-size: 26rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 4rpx;
}
.entry-desc {
  font-size: 20rpx;
  color: #bbb;
}

/* 模块通用样式 */
.module-wrap {
  margin: 0 24rpx 24rpx;
}
.module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}
.module-title-row {
  display: flex;
  align-items: center;
  gap: 10rpx;
}
.title-icon {
  font-size: 32rpx;
}
.module-title {
  font-size: 34rpx;
  font-weight: 700;
  color: #1a1a1a;
}
.title-tag {
  font-size: 20rpx;
  background: #FFF0F0;
  color: #C41E3A;
  padding: 4rpx 12rpx;
  border-radius: 20rpx;
  font-weight: 500;
}
.title-tag.red {
  background: #C41E3A;
  color: #fff;
}
.more-btn {
  font-size: 26rpx;
  color: #999;
}

/* 景点横向滚动 */
.attraction-scroll {
  white-space: nowrap;
  width: 100%;
}
.attraction-card {
  display: inline-block;
  width: 260rpx;
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;
  margin-right: 16rpx;
  vertical-align: top;
  box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.08);
}
.attraction-img {
  width: 100%;
  height: 180rpx;
}
.attraction-info {
  padding: 16rpx;
}
.attraction-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  margin-bottom: 6rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.attraction-location {
  display: block;
  font-size: 22rpx;
  color: #999;
  margin-bottom: 8rpx;
}
.attraction-price {
  display: flex;
  align-items: baseline;
}
.attraction-price.free {
  color: #67C23A;
  font-size: 22rpx;
  font-weight: 600;
}
.price-symbol {
  font-size: 22rpx;
  color: #C41E3A;
}
.price-num {
  font-size: 30rpx;
  font-weight: 700;
  color: #C41E3A;
}
.price-unit {
  font-size: 22rpx;
  color: #999;
}

/* 路线卡片 */
.route-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}
.route-card {
  display: flex;
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0,0,0,0.08);
}
.route-img {
  width: 220rpx;
  height: 180rpx;
  flex-shrink: 0;
}
.route-body {
  flex: 1;
  padding: 16rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.route-top {}
.route-theme {
  display: inline-block;
  font-size: 20rpx;
  background: #FFF0F0;
  color: #C41E3A;
  padding: 2rpx 12rpx;
  border-radius: 20rpx;
  margin-bottom: 8rpx;
}
.route-name {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.route-meta {
  display: flex;
  gap: 16rpx;
  margin: 8rpx 0;
}
.meta-item {
  font-size: 22rpx;
  color: #999;
}
.route-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.route-price {
  display: flex;
  align-items: baseline;
}
.route-book-btn {
  font-size: 24rpx;
  background: linear-gradient(135deg, #C41E3A, #8B0000);
  color: #fff;
  padding: 8rpx 24rpx;
  border-radius: 24rpx;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 0;
}
.empty-icon {
  font-size: 96rpx;
  margin-bottom: 24rpx;
}
.empty-text {
  font-size: 32rpx;
  color: #333;
  font-weight: 600;
  margin-bottom: 12rpx;
}
.empty-sub {
  font-size: 26rpx;
  color: #999;
}
</style>
