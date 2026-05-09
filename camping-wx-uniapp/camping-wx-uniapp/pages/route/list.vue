<!-- 路线列表页 -->
<template>
  <view class="list-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">精品路线</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 主题筛选 -->
    <view class="filter-bar">
      <view
        class="filter-item"
        :class="{ active: currentTheme === '' }"
        @click="switchTheme('')"
      >全部</view>
      <view
        class="filter-item"
        :class="{ active: currentTheme === '红色教育' }"
        @click="switchTheme('红色教育')"
      >红色教育</view>
      <view
        class="filter-item"
        :class="{ active: currentTheme === '历史追溯' }"
        @click="switchTheme('历史追溯')"
      >历史追溯</view>
      <view
        class="filter-item"
        :class="{ active: currentTheme === '研学旅行' }"
        @click="switchTheme('研学旅行')"
      >研学旅行</view>
    </view>

    <!-- 搜索栏 -->
    <view class="search-bar">
      <input class="search-input" v-model="keyword" placeholder="搜索路线名称" placeholder-class="search-placeholder" @confirm="handleSearch" />
      <view class="search-btn" @click="handleSearch">
        <text>搜索</text>
      </view>
    </view>

    <!-- 路线列表 -->
    <view class="route-list">
      <view class="route-card" v-for="item in list" :key="item.id" @click="goDetail(item.id)">
        <image :src="item.cover || item.coverImage" mode="aspectFill" class="route-img"></image>
        <view class="route-body">
          <view class="route-top">
            <text class="route-theme" v-if="item.theme">{{ item.theme }}</text>
            <text class="route-name">{{ item.name }}</text>
          </view>
          <view class="route-meta">
            <text class="meta-item">🗓 {{ item.durationDays }}天行程</text>
            <text class="meta-item">👥 {{ item.groupSize }}人团</text>
          </view>
          <view class="route-summary" v-if="item.summary">{{ item.summary }}</view>
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

      <!-- 空状态 -->
      <view class="empty-state" v-if="!loading && list.length === 0">
        <view class="empty-icon">🗺</view>
        <view class="empty-text">暂无路线数据</view>
      </view>

      <!-- 加载状态 -->
      <view class="loading-state" v-if="loading">
        <text>加载中...</text>
      </view>

      <!-- 没有更多 -->
      <view class="no-more" v-if="!loading && list.length > 0 && noMore">
        — 没有更多了 —
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const list = ref([]);
const loading = ref(false);
const noMore = ref(false);
const keyword = ref('');
const currentTheme = ref('');
const pageNum = ref(1);
const pageSize = 10;

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadList(true);
});

const loadList = async (reset = false) => {
  if (loading.value) return;
  if (reset) {
    pageNum.value = 1;
    noMore.value = false;
    list.value = [];
  }
  loading.value = true;
  try {
    const res = await h5Api.getRouteList({ keyword: keyword.value, theme: currentTheme.value, pageNum: pageNum.value, pageSize });
    const data = res.data || [];
    if (reset) {
      list.value = data;
    } else {
      list.value.push(...data);
    }
    if (data.length < pageSize) noMore.value = true;
  } catch (e) {
    /* ignore */
  } finally {
    loading.value = false;
  }
};

const switchTheme = (theme) => {
  currentTheme.value = theme;
  loadList(true);
};

const handleSearch = () => {
  loadList(true);
};

const goDetail = (id) => {
  uni.navigateTo({ url: `/pages/route/detail?id=${id}` });
};

const goBack = () => {
  const pages = getCurrentPages();
  if (pages.length > 1) {
    uni.navigateBack({ fail: () => {
      uni.reLaunch({ url: '/pages/index/index' });
    }});
  } else {
    uni.reLaunch({ url: '/pages/index/index' });
  }
};
</script>

<style scoped>
.list-page { background: #f5f5f5; min-height: 100vh; padding-bottom: 40rpx; }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

.filter-bar { display: flex; gap: 16rpx; padding: 16rpx 24rpx; overflow-x: auto; white-space: nowrap; background: #fff; margin-bottom: 1px; }
.filter-item { padding: 10rpx 28rpx; border-radius: 30rpx; font-size: 26rpx; color: #666; background: #f5f5f5; flex-shrink: 0; }
.filter-item.active { background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; }

.search-bar { display: flex; align-items: center; background: #fff; margin: 16rpx 24rpx; border-radius: 40rpx; padding: 0 8rpx 0 24rpx; height: 80rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.search-input { flex: 1; font-size: 28rpx; color: #333; height: 80rpx; }
.search-placeholder { color: #bbb; }
.search-btn { background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 40rpx; font-size: 26rpx; padding: 0 28rpx; height: 64rpx; line-height: 64rpx; border: none; }

.route-list { padding: 0 24rpx; }
.route-card { display: flex; background: #fff; border-radius: 16rpx; overflow: hidden; margin-bottom: 16rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.route-img { width: 220rpx; height: 180rpx; flex-shrink: 0; }
.route-body { flex: 1; padding: 20rpx; display: flex; flex-direction: column; justify-content: space-between; }
.route-top {}
.route-theme { display: inline-block; font-size: 20rpx; background: #FFF0F0; color: #C41E3A; padding: 2rpx 12rpx; border-radius: 20rpx; margin-bottom: 8rpx; }
.route-name { display: block; font-size: 28rpx; font-weight: 600; color: #333; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.route-meta { display: flex; gap: 16rpx; margin: 8rpx 0; }
.meta-item { font-size: 22rpx; color: #999; }
.route-summary { font-size: 22rpx; color: #666; line-height: 1.5; margin-bottom: 8rpx; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
.route-footer { display: flex; justify-content: space-between; align-items: center; }
.route-price { display: flex; align-items: baseline; }
.price-symbol { font-size: 22rpx; color: #C41E3A; }
.price-num { font-size: 32rpx; font-weight: 700; color: #C41E3A; }
.price-unit { font-size: 22rpx; color: #999; }
.route-book-btn { font-size: 24rpx; background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; padding: 8rpx 24rpx; border-radius: 24rpx; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 120rpx 0; }
.empty-icon { font-size: 96rpx; margin-bottom: 24rpx; }
.empty-text { font-size: 28rpx; color: #999; }
.loading-state { text-align: center; padding: 40rpx; color: #999; font-size: 28rpx; }
.no-more { text-align: center; padding: 32rpx; color: #ccc; font-size: 24rpx; }
</style>
