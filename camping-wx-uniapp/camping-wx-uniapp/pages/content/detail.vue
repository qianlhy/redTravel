<!-- 内容详情页 — 六个分类通用详情页 -->
<template>
  <view class="detail-page">

    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-back" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">详情</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 封面图 -->
    <view class="cover-wrap" v-if="detail.coverImage">
      <image :src="detail.coverImage" mode="aspectFill" class="cover-img"></image>
      <view class="cover-overlay"></view>
    </view>

    <!-- 文章主体 -->
    <view class="article-body" v-if="detail.id">

      <!-- 分类标签 -->
      <view class="category-tag-row">
        <text class="category-tag">{{ detail.categoryName }}</text>
        <text class="publish-date" v-if="detail.publishDate">{{ detail.publishDate }}</text>
      </view>

      <!-- 标题 -->
      <text class="article-title">{{ detail.title }}</text>

      <!-- 副标题 -->
      <text class="article-subtitle" v-if="detail.subtitle">{{ detail.subtitle }}</text>

      <!-- 作者来源 -->
      <view class="author-row" v-if="detail.author || detail.source">
        <text class="author-name" v-if="detail.author">{{ detail.author }}</text>
        <text class="source-name" v-if="detail.source">来源：{{ detail.source }}</text>
      </view>

      <!-- 分隔线 -->
      <view class="divider"></view>

      <!-- 内容正文（富文本渲染） -->
      <view class="rich-content">
        <rich-text :nodes="renderedContent"></rich-text>
      </view>

      <!-- 浏览量 -->
      <view class="view-count-row">
        <text class="view-count-text">阅读 {{ detail.viewCount || 0 }}</text>
      </view>
    </view>

    <!-- 骨架屏加载 -->
    <view class="skeleton" v-else-if="loading">
      <view class="skeleton-cover"></view>
      <view class="skeleton-body">
        <view class="skeleton-tag"></view>
        <view class="skeleton-title"></view>
        <view class="skeleton-title short"></view>
        <view class="skeleton-text" v-for="i in 6" :key="i"></view>
      </view>
    </view>

    <!-- 底部安全区 -->
    <view style="height: 120rpx"></view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const detail = ref({});
const loading = ref(true);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;

  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1];
  const options = currentPage.options || {};
  if (options.id) {
    loadDetail(options.id);
  }
});

const loadDetail = async (id) => {
  loading.value = true;
  try {
    const res = await h5Api.getContentDetail(id);
    detail.value = res.data || {};
  } catch (e) {
    uni.showToast({ title: '加载失败', icon: 'none' });
  } finally {
    loading.value = false;
  }
};

// 将富文本内容渲染（支持 img 和 p 标签）
const renderedContent = computed(() => {
  if (!detail.value.content) return '';
  let html = detail.value.content;
  // 替换图片链接为 uni-app 图片标签（rich-text 不支持 img 标签直接显示网络图片，需要处理）
  // 这里保持原样输出，rich-text 会自动渲染 img 标签
  // 添加响应式图片样式
  html = `<div style="word-break:break-all;line-height:1.8;font-size:30rpx;color:#333;">${html}</div>`;
  return html;
});

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
.detail-page {
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
  width: 40px;
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

/* 封面图 */
.cover-wrap {
  position: relative;
  width: 100%;
  height: 480rpx;
  overflow: hidden;
}
.cover-img {
  width: 100%;
  height: 100%;
}
.cover-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 200rpx;
  background: linear-gradient(transparent, rgba(0,0,0,0.4));
}

/* 文章主体 */
.article-body {
  background: #fff;
  margin: -40rpx 24rpx 0;
  border-radius: 20rpx 20rpx 0 0;
  padding: 32rpx 28rpx 40rpx;
  position: relative;
  z-index: 1;
}

.category-tag-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 16rpx;
}
.category-tag {
  font-size: 24rpx;
  background: #FFF0F0;
  color: #B71C1C;
  padding: 6rpx 20rpx;
  border-radius: 24rpx;
  font-weight: 600;
}
.publish-date {
  font-size: 24rpx;
  color: #999;
}

.article-title {
  display: block;
  font-size: 38rpx;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.4;
  margin-bottom: 16rpx;
}

.article-subtitle {
  display: block;
  font-size: 28rpx;
  color: #666;
  line-height: 1.6;
  margin-bottom: 20rpx;
}

.author-row {
  display: flex;
  align-items: center;
  gap: 20rpx;
  margin-bottom: 20rpx;
}
.author-name {
  font-size: 26rpx;
  color: #B71C1C;
  font-weight: 500;
}
.source-name {
  font-size: 24rpx;
  color: #999;
}

.divider {
  height: 1rpx;
  background: #f0f0f0;
  margin-bottom: 24rpx;
}

.rich-content {
  line-height: 1.8;
  color: #333;
  font-size: 30rpx;
}

.view-count-row {
  text-align: center;
  padding-top: 40rpx;
  border-top: 1rpx solid #f0f0f0;
  margin-top: 40rpx;
}
.view-count-text {
  font-size: 24rpx;
  color: #bbb;
}

/* 骨架屏 */
.skeleton {
  padding: 0 24rpx;
}
.skeleton-cover {
  width: 100%;
  height: 480rpx;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  border-radius: 0 0 20rpx 20rpx;
  margin-bottom: -40rpx;
}
.skeleton-body {
  background: #fff;
  border-radius: 20rpx;
  padding: 32rpx 28rpx;
}
.skeleton-tag {
  width: 100rpx;
  height: 40rpx;
  background: #f0f0f0;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
}
.skeleton-title {
  width: 90%;
  height: 40rpx;
  background: #f0f0f0;
  border-radius: 8rpx;
  margin-bottom: 16rpx;
}
.skeleton-title.short { width: 60%; }
.skeleton-text {
  width: 100%;
  height: 24rpx;
  background: #f0f0f0;
  border-radius: 6rpx;
  margin-bottom: 16rpx;
}
</style>
