<!-- 景点列表页 -->
<template>
  <view class="list-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">红色景点</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 搜索栏 -->
    <view class="search-bar">
      <input class="search-input" v-model="keyword" placeholder="搜索景点名称" placeholder-class="search-placeholder" @confirm="handleSearch" />
      <view class="search-btn" @click="handleSearch">
        <text>搜索</text>
      </view>
    </view>

    <!-- 景点列表 -->
    <view class="attraction-list">
      <view class="attraction-card" v-for="item in list" :key="item.id" @click="goDetail(item.id)">
        <image :src="item.cover || item.coverImage" mode="aspectFill" class="attraction-img"></image>
        <view class="attraction-body">
          <view class="attraction-name">{{ item.name }}</view>
          <view class="attraction-location">📍 {{ item.province }} {{ item.city }} {{ item.address }}</view>
          <view class="attraction-info-row">
            <text class="attraction-time" v-if="item.openTime">🕘 {{ item.openTime }}</text>
            <view class="attraction-price" v-if="item.ticketPrice > 0">
              <text class="price-symbol">¥</text>
              <text class="price-num">{{ item.ticketPrice }}</text>
              <text class="price-unit">/人</text>
            </view>
            <view class="attraction-price free" v-else>免费参观</view>
          </view>
          <view class="attraction-story" v-if="item.historyStory">
            {{ item.historyStory.substring(0, 60) }}...
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-if="!loading && list.length === 0">
        <view class="empty-icon">🏛</view>
        <view class="empty-text">暂无景点数据</view>
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
const pageNum = ref(1);
const pageSize = 10;

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  // 获取页面参数中的 keyword
  const pages = getCurrentPages();
  const current = pages[pages.length - 1];
  if (current.options?.keyword) {
    keyword.value = decodeURIComponent(current.options.keyword);
  }
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
    const res = await h5Api.getAttractionList({ keyword: keyword.value, pageNum: pageNum.value, pageSize });
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

const handleSearch = () => {
  loadList(true);
};

const goDetail = (id) => {
  uni.navigateTo({ url: `/pages/attraction/detail?id=${id}` });
};

const goBack = () => uni.navigateBack();

// 触底加载更多（通过 onReachBottom 在 pages.json 配置）
// eslint-disable-next-line no-unused-vars
uni.loadMore = () => {
  if (!noMore.value) {
    pageNum.value++;
    loadList();
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

.search-bar { display: flex; align-items: center; background: #fff; margin: 16rpx 24rpx; border-radius: 40rpx; padding: 0 8rpx 0 24rpx; height: 80rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.search-input { flex: 1; font-size: 28rpx; color: #333; height: 80rpx; }
.search-placeholder { color: #bbb; }
.search-btn { background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 40rpx; font-size: 26rpx; padding: 0 28rpx; height: 64rpx; line-height: 64rpx; border: none; }

.attraction-list { padding: 0 24rpx; }
.attraction-card { display: flex; background: #fff; border-radius: 16rpx; overflow: hidden; margin-bottom: 16rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.attraction-img { width: 200rpx; height: 180rpx; flex-shrink: 0; }
.attraction-body { flex: 1; padding: 20rpx; }
.attraction-name { font-size: 30rpx; font-weight: 600; color: #333; margin-bottom: 8rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.attraction-location { font-size: 22rpx; color: #999; margin-bottom: 8rpx; }
.attraction-info-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8rpx; }
.attraction-time { font-size: 22rpx; color: #999; }
.attraction-price { display: flex; align-items: baseline; }
.attraction-price.free { color: #67C23A; font-size: 22rpx; font-weight: 600; }
.price-symbol { font-size: 22rpx; color: #C41E3A; }
.price-num { font-size: 28rpx; font-weight: 700; color: #C41E3A; }
.price-unit { font-size: 20rpx; color: #999; }
.attraction-story { font-size: 22rpx; color: #666; line-height: 1.5; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 120rpx 0; }
.empty-icon { font-size: 96rpx; margin-bottom: 24rpx; }
.empty-text { font-size: 28rpx; color: #999; }
.loading-state { text-align: center; padding: 40rpx; color: #999; font-size: 28rpx; }
.no-more { text-align: center; padding: 32rpx; color: #ccc; font-size: 24rpx; }
</style>
