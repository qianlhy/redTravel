<!-- 内容列表页 — 六个分类通用列表页 -->
<template>
  <view class="content-list-page">

    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-back" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">{{ currentCategory.name }}</text>
        <view style="width:40px"></view>
      </view>
    </view>

    <!-- 顶部红色背景 + 搜索栏 -->
    <view class="hero-area" :style="{ paddingTop: (statusBarHeight + 44) + 'px' }">
      <view class="search-bar">
        <input
          class="search-input"
          v-model="keyword"
          placeholder="搜索标题关键词"
          placeholder-class="search-placeholder"
          @confirm="loadData(1)"
        />
        <view class="search-btn" @click="loadData(1)">
          <text class="search-icon">🔍</text>
        </view>
      </view>
    </view>

    <!-- Tab 标签（固定） -->
    <view class="tab-bar">
      <view
        class="tab-item"
        :class="{ active: currentTab === tab.code }"
        v-for="tab in tabs"
        :key="tab.code"
        @click="switchTab(tab.code)"
      >
        <text class="tab-name">{{ tab.name }}</text>
      </view>
    </view>

    <!-- 内容列表 -->
    <view class="list-container">
      <view
        class="content-card"
        v-for="item in list"
        :key="item.id"
        @click="goDetail(item.id)"
      >
        <!-- 左侧图片 -->
        <image
          :src="item.coverImage || 'https://picsum.photos/300/200?random=default'"
          mode="aspectFill"
          class="card-cover"
        ></image>

        <!-- 右侧内容 -->
        <view class="card-body">
          <!-- 分类标签 + 日期 -->
          <view class="card-meta">
            <text class="meta-tag">{{ item.categoryName }}</text>
            <text class="meta-date" v-if="item.publishDate">{{ item.publishDate }}</text>
          </view>

          <!-- 标题 -->
          <text class="card-title">{{ item.title }}</text>

          <!-- 副标题 -->
          <text class="card-subtitle" v-if="item.subtitle">{{ item.subtitle }}</text>

          <!-- 底部信息 -->
          <view class="card-footer">
            <view class="footer-left">
              <text class="footer-author" v-if="item.author">{{ item.author }}</text>
              <text class="footer-views">👁 {{ item.viewCount || 0 }}</text>
            </view>
            <view class="detail-btn">查看详情 ›</view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view class="empty-state" v-if="list.length === 0 && !loading">
        <view class="empty-icon">📋</view>
        <text class="empty-text">暂无内容</text>
        <text class="empty-sub">该分类下暂无内容</text>
      </view>

      <!-- 加载更多 -->
      <view class="load-more" v-if="list.length > 0">
        <text v-if="loading">加载中...</text>
        <text v-else-if="noMore">— 没有更多了 —</text>
        <text v-else @click="loadMore">加载更多 ↓</text>
      </view>
    </view>

    <!-- 底部安全区 -->
    <view style="height: 120rpx"></view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const tabs = [
  { code: 'zkaju', name: '走看聚' },
  { code: 'qflz', name: '清风廉政' },
  { code: 'yffl', name: '与法同行' },
  { code: 'szxc', name: '数字乡村' },
  { code: 'yxyp', name: '一县一片' },
  { code: 'swxl', name: '室外线路' },
];
const currentTab = ref('zkaju');
const currentCategory = ref({ code: 'zkaju', name: '走看聚' });
const keyword = ref('');
const list = ref([]);
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);
const noMore = ref(false);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;

  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1];
  const options = currentPage.options || {};
  if (options.category) {
    currentTab.value = options.category;
    const found = tabs.find(t => t.code === options.category);
    if (found) currentCategory.value = found;
  }

  loadData(1);
});

const switchTab = (code) => {
  currentTab.value = code;
  const found = tabs.find(t => t.code === code);
  if (found) currentCategory.value = found;
  keyword.value = '';
  loadData(1);
};

const loadData = async (page = 1) => {
  pageNum.value = page;
  loading.value = true;
  noMore.value = false;
  try {
    const res = await h5Api.getContentPage({
      category: currentTab.value,
      keyword: keyword.value,
      pageNum: page,
      pageSize: pageSize.value,
    });
    list.value = page === 1 ? (res.data || []) : [...list.value, ...(res.data || [])];
    total.value = res.total || list.value.length;
    if (list.value.length >= total.value) noMore.value = true;
  } catch (e) {
    list.value = [];
  } finally {
    loading.value = false;
  }
};

const loadMore = () => {
  if (!noMore.value && !loading.value) {
    loadData(pageNum.value + 1);
  }
};

const goDetail = (id) => {
  uni.navigateTo({ url: `/pages/content/detail?id=${id}` });
};

const goBack = () => {
  const pages = getCurrentPages();
  if (pages.length > 1) {
    uni.navigateBack({ fail: () => {
      uni.switchTab({ url: '/pages/index/index' });
    }});
  } else {
    uni.switchTab({ url: '/pages/index/index' });
  }
};
</script>

<style scoped>
.content-list-page {
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
  background: linear-gradient(135deg, #B71C1C, #C62828);
}
.nav-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 44px;
  padding: 0 12rpx;
}
.nav-back {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.back-icon {
  font-size: 48rpx;
  color: #fff;
  font-weight: 300;
}
.nav-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #fff;
  flex: 1;
  text-align: center;
}

/* 顶部 Hero 区域 */
.hero-area {
  background: linear-gradient(135deg, #B71C1C, #C62828);
  padding: 0 24rpx 16rpx;
}
/* 搜索栏 */
.search-bar {
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 40rpx;
  padding: 0 8rpx 0 32rpx;
  height: 76rpx;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.15);
}
.search-input {
  flex: 1;
  font-size: 28rpx;
  color: #333;
  height: 76rpx;
}
.search-placeholder { color: #bbb; font-size: 28rpx; }
.search-btn {
  width: 68rpx;
  height: 68rpx;
  background: linear-gradient(135deg, #B71C1C, #C62828);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.search-icon { font-size: 26rpx; }

/* Tab 栏（固定在顶部下方） */
.tab-bar {
  display: flex;
  background: #fff;
  position: sticky;
  top: calc(env(safe-area-inset-top) + 44px);
  z-index: 100;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.06);
}
.tab-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 88rpx;
  border-bottom: 4rpx solid transparent;
  transition: all 0.2s;
}
.tab-item.active {
  border-bottom-color: #B71C1C;
}
.tab-name {
  font-size: 28rpx;
  font-weight: 500;
  color: #666;
  transition: color 0.2s;
}
.tab-item.active .tab-name {
  color: #B71C1C;
  font-weight: 700;
}

/* 内容列表 */
.list-container {
  padding: 16rpx 24rpx;
}
.content-card {
  display: flex;
  background: #fff;
  border-radius: 12rpx;
  margin-bottom: 16rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06);
}

/* 左侧图片 */
.card-cover {
  width: 240rpx;
  height: 180rpx;
  flex-shrink: 0;
  display: block;
}

/* 右侧内容 */
.card-body {
  flex: 1;
  padding: 16rpx 20rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 180rpx;
  overflow: hidden;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 12rpx;
  margin-bottom: 8rpx;
}
.meta-tag {
  font-size: 20rpx;
  background: #FFEBEE;
  color: #B71C1C;
  padding: 3rpx 12rpx;
  border-radius: 16rpx;
  font-weight: 600;
}
.meta-date {
  font-size: 20rpx;
  color: #999;
}

.card-title {
  display: block;
  font-size: 28rpx;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  margin-bottom: 6rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.card-subtitle {
  display: block;
  font-size: 22rpx;
  color: #888;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 8rpx;
}

/* 底部信息 */
.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.footer-left {
  display: flex;
  align-items: center;
  gap: 16rpx;
  flex: 1;
  overflow: hidden;
}
.footer-author {
  font-size: 20rpx;
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 120rpx;
}
.footer-views {
  font-size: 20rpx;
  color: #bbb;
}
.detail-btn {
  font-size: 22rpx;
  color: #B71C1C;
  font-weight: 600;
  flex-shrink: 0;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 100rpx 0;
}
.empty-icon { font-size: 96rpx; margin-bottom: 24rpx; }
.empty-text { font-size: 32rpx; color: #333; font-weight: 600; margin-bottom: 12rpx; }
.empty-sub { font-size: 26rpx; color: #999; }

/* 加载更多 */
.load-more {
  text-align: center;
  padding: 24rpx 0;
  font-size: 26rpx;
  color: #999;
}
</style>
