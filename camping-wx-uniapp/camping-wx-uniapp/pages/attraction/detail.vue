<!-- 景点详情页 -->
<template>
  <view class="detail-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">景点详情</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 封面图 -->
    <view class="cover-section" v-if="attraction.coverImage">
      <image :src="attraction.coverImage" mode="aspectFill" class="cover-img"></image>
      <view class="cover-overlay">
        <view class="cover-title">{{ attraction.name }}</view>
      </view>
    </view>

    <!-- 基本信息 -->
    <view class="info-section">
      <view class="info-row" v-if="attraction.province || attraction.city">
        <text class="info-label">📍 地理位置</text>
        <text class="info-value">{{ attraction.province }} {{ attraction.city }} {{ attraction.address }}</text>
      </view>
      <view class="info-row" v-if="attraction.openTime">
        <text class="info-label">🕘 开放时间</text>
        <text class="info-value">{{ attraction.openTime }}</text>
      </view>
      <view class="info-row">
        <text class="info-label">🎫 门票价格</text>
        <text class="info-value price" v-if="attraction.ticketPrice > 0">¥{{ attraction.ticketPrice }}</text>
        <text class="info-value price-free" v-else>免费参观</text>
      </view>
    </view>

    <!-- 景点简介 -->
    <view class="section" v-if="attraction.description">
      <view class="section-title">
        <text class="title-icon">🏛</text>
        景点简介
      </view>
      <view class="section-text">{{ attraction.description }}</view>
    </view>

    <!-- 红色故事 -->
    <view class="section story-section" v-if="attraction.historyStory">
      <view class="section-title">
        <text class="title-icon">📜</text>
        红色历史
      </view>
      <view class="story-content">
        <view class="story-text">{{ attraction.historyStory }}</view>
      </view>
    </view>

    <!-- 相关路线 -->
    <view class="section" v-if="relatedRoutes.length">
      <view class="section-title">
        <text class="title-icon">🗺</text>
        相关路线
      </view>
      <view class="route-list">
        <view class="route-item" v-for="route in relatedRoutes" :key="route.id" @click="goRoute(route.id)">
          <image :src="route.coverImage" mode="aspectFill" class="route-img"></image>
          <view class="route-body">
            <view class="route-name">{{ route.name }}</view>
            <view class="route-meta">
              <text>{{ route.durationDays }}天</text>
              <text>¥{{ route.price }}/人</text>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const attraction = ref({});
const relatedRoutes = ref([]);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadDetail();
});

const loadDetail = async () => {
  const pages = getCurrentPages();
  const current = pages[pages.length - 1];
  const id = current.options?.id;
  try {
    const res = await h5Api.getAttractionDetail(id);
    attraction.value = res.data || {};
  } catch (e) {
    attraction.value = {
      id, name: '南湖红船纪念地', coverImage: 'https://picsum.photos/750/400?random=101',
      province: '浙江省', city: '嘉兴市', address: '南湖路83号',
      openTime: '09:00-17:00', ticketPrice: 0,
      description: '南湖位于浙江省嘉兴市，是中国共产党的诞生地。1921年7月，中国共产党第一次全国代表大会在这里胜利闭幕，宣告了中国共产党的成立。',
      historyStory: '1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。',
    };
  }
  // 加载相关路线
  try {
    const res = await h5Api.getRecommendRoutes();
    relatedRoutes.value = (res.data || []).slice(0, 3);
  } catch (e) { /* ignore */ }
};

const goBack = () => uni.navigateBack();
const goRoute = (id) => uni.navigateTo({ url: `/pages/route/detail?id=${id}` });
</script>

<style scoped>
.detail-page { background: #f5f5f5; min-height: 100vh; padding-bottom: 60rpx; }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

.cover-section { position: relative; height: 400rpx; }
.cover-img { width: 100%; height: 100%; }
.cover-overlay { position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(transparent, rgba(0,0,0,0.7)); padding: 40rpx 24rpx 24rpx; }
.cover-title { font-size: 36rpx; font-weight: 700; color: #fff; }

.info-section { background: #fff; padding: 24rpx; margin-bottom: 16rpx; }
.info-row { display: flex; align-items: flex-start; gap: 16rpx; margin-bottom: 16rpx; }
.info-row:last-child { margin-bottom: 0; }
.info-label { font-size: 28rpx; color: #999; flex-shrink: 0; width: 140rpx; }
.info-value { font-size: 28rpx; color: #333; flex: 1; line-height: 1.5; }
.info-value.price { color: #C41E3A; font-weight: 600; }
.info-value.price-free { color: #67C23A; font-weight: 600; }

.section { background: #fff; padding: 24rpx; margin-bottom: 16rpx; }
.section-title { font-size: 32rpx; font-weight: 600; color: #333; margin-bottom: 16rpx; display: flex; align-items: center; gap: 8rpx; }
.title-icon { font-size: 28rpx; }
.section-text { font-size: 28rpx; color: #666; line-height: 1.8; }

.story-section { background: linear-gradient(135deg, #FFF8F8, #fff); }
.story-content { border-left: 6rpx solid #C41E3A; padding-left: 20rpx; }
.story-text { font-size: 28rpx; color: #555; line-height: 2; }

.route-list {}
.route-item { display: flex; background: #fafafa; border-radius: 12rpx; margin-bottom: 16rpx; overflow: hidden; }
.route-img { width: 160rpx; height: 120rpx; flex-shrink: 0; }
.route-body { flex: 1; padding: 16rpx; }
.route-name { font-size: 28rpx; font-weight: 600; color: #333; margin-bottom: 8rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.route-meta { display: flex; gap: 16rpx; font-size: 24rpx; color: #999; }
.route-meta text:last-child { color: #C41E3A; font-weight: 600; }
</style>
