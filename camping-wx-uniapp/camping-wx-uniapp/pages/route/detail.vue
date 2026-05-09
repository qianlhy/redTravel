<!-- 路线详情页 -->
<template>
  <view class="detail-page">
    <!-- 顶部返回导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">路线详情</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 封面大图 -->
    <view class="cover-section" v-if="routeData.coverImage">
      <image :src="routeData.coverImage" mode="aspectFill" class="cover-img"></image>
      <view class="cover-overlay">
        <view class="cover-tag">{{ routeData.theme }}</view>
        <view class="cover-title">{{ routeData.name }}</view>
      </view>
    </view>

    <!-- 基础信息 -->
    <view class="info-section">
      <view class="price-row">
        <text class="price-symbol">¥</text>
        <text class="price-num">{{ routeData.price }}</text>
        <text class="price-unit">/人</text>
        <text class="original-price" v-if="routeData.originalPrice">原价¥{{ routeData.originalPrice }}</text>
      </view>
      <view class="meta-row">
        <view class="meta-item">
          <text class="meta-icon">🗓</text>
          <text class="meta-text">{{ routeData.durationDays }}天行程</text>
        </view>
        <view class="meta-item">
          <text class="meta-icon">👥</text>
          <text class="meta-text">{{ routeData.groupSize }}人团</text>
        </view>
        <view class="meta-item">
          <text class="meta-icon">📍</text>
          <text class="meta-text">{{ routeData.startLocation }} → {{ routeData.endLocation }}</text>
        </view>
      </view>
    </view>

    <!-- 行程安排 -->
    <view class="section">
      <view class="section-title">
        <text class="title-icon">📌</text>
        行程安排
      </view>
      <view class="itinerary-list">
        <view class="day-block" v-for="day in groupedAttractions" :key="day.dayIndex">
          <view class="day-header">
            <view class="day-badge">第{{ day.dayIndex }}天</view>
          </view>
          <view class="spot-list">
            <view class="spot-item" v-for="(spot, idx) in day.spots" :key="idx">
              <view class="spot-time" v-if="spot.visitTime">{{ spot.visitTime }}</view>
              <view class="spot-time" v-else></view>
              <view class="spot-line">
                <view class="spot-dot"></view>
                <view class="spot-conn" v-if="idx < day.spots.length - 1"></view>
              </view>
              <view class="spot-content">
                <view class="spot-name">{{ spot.name }}</view>
                <view class="spot-address" v-if="spot.province">{{ spot.province }}{{ spot.city }}</view>
                <view class="spot-memo" v-if="spot.memo">{{ spot.memo }}</view>
              </view>
            </view>
          </view>
        </view>
      </view>
      <view v-if="!groupedAttractions.length" class="empty-schedule">
        <text>暂无行程安排数据</text>
      </view>
    </view>

    <!-- 费用说明 -->
    <view class="section" v-if="routeData.included && routeData.included.length">
      <view class="section-title">
        <text class="title-icon">✅</text>
        费用包含
      </view>
      <view class="fee-list">
        <view class="fee-item" v-for="(item, idx) in routeData.included" :key="idx">
          <text class="fee-check">✓</text>
          <text class="fee-text">{{ item }}</text>
        </view>
      </view>
    </view>

    <!-- 温馨提示 -->
    <view class="section" v-if="routeData.tips">
      <view class="section-title">
        <text class="title-icon">💡</text>
        温馨提示
      </view>
      <view class="tips-text">{{ routeData.tips }}</view>
    </view>

    <!-- 底部操作栏 -->
    <view class="bottom-bar">
      <view class="meeting-info">
        <view class="meeting-row">
          <text class="meeting-label">集合地点：</text>
          <text class="meeting-value">{{ routeData.meetingAddress }}</text>
        </view>
        <view class="meeting-row">
          <text class="meeting-label">集合时间：</text>
          <text class="meeting-value highlight">{{ routeData.meetingTime }}</text>
        </view>
      </view>
      <view class="action-btns">
        <button class="btn-book" @click="goBooking">立即预约</button>
      </view>
    </view>
    <view style="height: 160rpx"></view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const routeData = ref({});
const loading = ref(false);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadDetail();
});

const loadDetail = async () => {
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1];
  const id = currentPage.options?.id || 1;
  loading.value = true;
  try {
    const res = await h5Api.getRouteDetail(id);
    routeData.value = res.data || {};
  } catch (e) {
    // 模拟数据
    routeData.value = {
      id: 1, name: '红色党建张家港线', theme: '红色教育', durationDays: 1, groupSize: 30,
      price: 168, originalPrice: 198,
      startLocation: '苏州市区集合', endLocation: '张家港',
      coverImage: 'https://picsum.photos/750/400?random=201',
      meetingAddress: '苏州市人民路广场集合', meetingTime: '07:30',
      summary: '追寻红色记忆，传承革命精神',
      highlights: ['南湖红船精神', '重温入党誓词', '红色教育基地'],
      included: ['全程正规旅游大巴', '景区门票', '研学导师讲解', '午餐', '研学手册', '团队横幅', '旅游意外险'],
      tips: '穿着轻便运动装，携带身份证件，建议提前15分钟到达集合点',
      attractions: [
        { name: '张家港双山岛渡江战役纪念馆', province: '江苏省', city: '苏州市', visitTime: '09:00-11:30', memo: '参观渡江战役纪念馆', dayIndex: 1 },
        { name: '张家港红色教育基地', province: '江苏省', city: '苏州市', visitTime: '13:00-16:00', memo: '红色主题教育活动', dayIndex: 1 },
      ],
    };
  }
  loading.value = false;
};

// 按天分组景点
const groupedAttractions = computed(() => {
  const list = routeData.value.attractions || [];
  const map = {};
  list.forEach(item => {
    const day = item.dayIndex || 1;
    if (!map[day]) map[day] = { dayIndex: day, spots: [] };
    map[day].spots.push(item);
  });
  return Object.values(map).sort((a, b) => a.dayIndex - b.dayIndex);
});

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
const goBooking = () => {
  const pages = getCurrentPages();
  const currentPage = pages[pages.length - 1];
  const id = currentPage.options?.id;
  uni.navigateTo({ url: `/pages/booking/form?routeId=${id || ''}` });
};
</script>

<style scoped>
.detail-page { background: #f5f5f5; min-height: 100vh; padding-bottom: env(safe-area-inset-bottom); }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

.cover-section { position: relative; height: 400rpx; }
.cover-img { width: 100%; height: 100%; }
.cover-overlay { position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(transparent, rgba(0,0,0,0.7)); padding: 40rpx 24rpx 24rpx; }
.cover-tag { display: inline-block; font-size: 22rpx; color: #fff; background: #C41E3A; padding: 4rpx 16rpx; border-radius: 20rpx; margin-bottom: 8rpx; }
.cover-title { font-size: 36rpx; font-weight: 700; color: #fff; }

.info-section { background: #fff; padding: 24rpx; margin-bottom: 16rpx; }
.price-row { display: flex; align-items: baseline; margin-bottom: 16rpx; }
.price-symbol { font-size: 28rpx; color: #C41E3A; }
.price-num { font-size: 48rpx; font-weight: 700; color: #C41E3A; margin-left: 4rpx; }
.price-unit { font-size: 24rpx; color: #999; margin-left: 4rpx; }
.original-price { font-size: 24rpx; color: #999; text-decoration: line-through; margin-left: 16rpx; }
.meta-row { display: flex; flex-wrap: wrap; gap: 16rpx; }
.meta-item { display: flex; align-items: center; gap: 6rpx; }
.meta-icon { font-size: 26rpx; }
.meta-text { font-size: 26rpx; color: #666; }

.section { background: #fff; padding: 24rpx; margin-bottom: 16rpx; }
.section-title { font-size: 32rpx; font-weight: 600; color: #1a1a1a; margin-bottom: 20rpx; display: flex; align-items: center; gap: 8rpx; }
.title-icon { font-size: 28rpx; }

.itinerary-list {}
.day-block { margin-bottom: 24rpx; }
.day-header { margin-bottom: 16rpx; }
.day-badge { display: inline-block; background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; font-size: 24rpx; padding: 6rpx 20rpx; border-radius: 24rpx; }

.spot-list {}
.spot-item { display: flex; align-items: flex-start; margin-bottom: 24rpx; }
.spot-time { width: 140rpx; font-size: 24rpx; color: #C41E3A; font-weight: 500; flex-shrink: 0; padding-top: 4rpx; }
.spot-line { width: 40rpx; display: flex; flex-direction: column; align-items: center; flex-shrink: 0; }
.spot-dot { width: 16rpx; height: 16rpx; border-radius: 50%; background: #C41E3A; flex-shrink: 0; margin-top: 8rpx; }
.spot-conn { width: 2rpx; flex: 1; background: #f0c0c0; min-height: 40rpx; margin-top: 4rpx; }
.spot-content { flex: 1; }
.spot-name { font-size: 28rpx; font-weight: 600; color: #333; margin-bottom: 4rpx; }
.spot-address { font-size: 24rpx; color: #999; margin-bottom: 4rpx; }
.spot-memo { font-size: 24rpx; color: #666; background: #f9f9f9; padding: 8rpx 12rpx; border-radius: 8rpx; margin-top: 4rpx; }

.fee-list {}
.fee-item { display: flex; align-items: flex-start; gap: 12rpx; margin-bottom: 16rpx; }
.fee-check { color: #67C23A; font-size: 28rpx; flex-shrink: 0; }
.fee-text { font-size: 28rpx; color: #666; line-height: 1.5; }

.tips-text { font-size: 28rpx; color: #666; line-height: 1.8; }

.empty-schedule { text-align: center; padding: 40rpx; color: #ccc; font-size: 28rpx; }

.bottom-bar { position: fixed; bottom: 0; left: 0; right: 0; background: #fff; padding: 16rpx 24rpx; padding-bottom: calc(16rpx + env(safe-area-inset-bottom)); box-shadow: 0 -2rpx 12rpx rgba(0,0,0,0.08); display: flex; align-items: center; gap: 16rpx; z-index: 100; }
.meeting-info { flex: 1; }
.meeting-row { display: flex; font-size: 24rpx; margin-bottom: 4rpx; }
.meeting-label { color: #999; flex-shrink: 0; }
.meeting-value { color: #333; }
.meeting-value.highlight { color: #C41E3A; font-weight: 600; }
.action-btns {}
.btn-book { background: linear-gradient(135deg, #E6A23C, #B8860B); color: #fff; border-radius: 40rpx; font-size: 28rpx; font-weight: 600; padding: 0 40rpx; height: 72rpx; line-height: 72rpx; }
</style>
