<!-- 预约订单详情页 -->
<template>
  <view class="detail-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">预约详情</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 订单状态 -->
    <view class="status-banner" :class="'status-bg-' + (order.status || 0)">
      <view class="status-icon">
        <text>{{ statusIcon(order.status) }}</text>
      </view>
      <view class="status-text">{{ statusLabel(order.status) }}</view>
      <view class="status-desc">{{ statusDesc(order.status) }}</view>
    </view>

    <!-- 路线信息 -->
    <view class="section" v-if="order.routeName">
      <view class="section-title">
        <text class="title-icon">🗺</text>
        预约路线
      </view>
      <view class="route-name">{{ order.routeName }}</view>
    </view>

    <!-- 基本信息 -->
    <view class="section">
      <view class="section-title">
        <text class="title-icon">📋</text>
        预约信息
      </view>
      <view class="info-list">
        <view class="info-item">
          <text class="info-label">订单编号</text>
          <text class="info-value">{{ order.orderNo || '-' }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">团队名称</text>
          <text class="info-value">{{ order.teamName || '-' }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">联系人</text>
          <text class="info-value">{{ order.contactName || '-' }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">联系电话</text>
          <text class="info-value">{{ order.contactPhone || '-' }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">团队人数</text>
          <text class="info-value">{{ order.teamSize || '-' }} 人</text>
        </view>
        <view class="info-item">
          <text class="info-label">计划出行</text>
          <text class="info-value">{{ order.travelDate || '-' }} · {{ order.durationDays || 1 }}天行程</text>
        </view>
        <view class="info-item">
          <text class="info-label">集合地点</text>
          <text class="info-value">{{ order.meetingAddress || '待通知' }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">集合时间</text>
          <text class="info-value highlight">{{ order.meetingTime || '待通知' }}</text>
        </view>
        <view class="info-item" v-if="order.remark">
          <text class="info-label">备注说明</text>
          <text class="info-value">{{ order.remark }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">下单时间</text>
          <text class="info-value">{{ formatDate(order.createTime) }}</text>
        </view>
      </view>
    </view>

    <!-- 底部操作 -->
    <view class="bottom-bar" v-if="order.status === 0">
      <button class="btn-cancel" @click="cancelOrder">取消预约</button>
    </view>
    <view style="height: 160rpx"></view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const order = ref({});
const _backUrl = '/pages/booking/order';

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadDetail();
});

const loadDetail = async () => {
  const pages = getCurrentPages();
  const current = pages[pages.length - 1];
  const id = current.options?.id;
  if (!id) {
    uni.showToast({ title: '参数错误', icon: 'none' });
    return;
  }
  try {
    const res = await h5Api.queryBookingById(id);
    if (res.data) {
      order.value = res.data;
    } else {
      uni.showToast({ title: '未找到订单', icon: 'none' });
    }
  } catch (e) {
    uni.showToast({ title: '加载失败', icon: 'none' });
  }
};

const statusLabel = (status) => {
  const map = { 0: '待确认', 1: '已确认', 2: '已拒绝', 3: '已完成', 4: '已取消' };
  return map[status] || '未知';
};

const statusIcon = (status) => {
  const map = { 0: '⏳', 1: '✅', 2: '❌', 3: '🏆', 4: '🚫' };
  return map[status] || '❓';
};

const statusDesc = (status) => {
  const map = {
    0: '工作人员将在24小时内与您联系确认',
    1: '预约已确认，请按时到达集合地点',
    2: '很遗憾本次预约未通过审核',
    3: '恭喜！您已完成本次红色之旅',
    4: '该预约已取消',
  };
  return map[status] || '';
};

const formatDate = (dateStr) => {
  if (!dateStr) return '-';
  return dateStr.substring(0, 16);
};

const cancelOrder = () => {
  uni.showModal({
    title: '确认取消',
    content: `确定取消该预约吗？`,
    success: async (res) => {
      if (res.confirm) {
        uni.showToast({ title: '已取消预约', icon: 'success' });
        setTimeout(() => {
          uni.redirectTo({ url: '/pages/booking/order' });
        }, 1500);
      }
    },
  });
};

const goBack = () => {
  if (_backUrl) {
    uni.redirectTo({ url: _backUrl });
  } else {
    uni.switchTab({ url: '/pages/booking/order' });
  }
};
</script>

<style scoped>
.detail-page { background: #f5f5f5; min-height: 100vh; }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

.status-banner { padding: 40rpx 32rpx; display: flex; flex-direction: column; align-items: center; color: #fff; }
.status-bg-0 { background: linear-gradient(135deg, #E65100, #FF8F00); }
.status-bg-1 { background: linear-gradient(135deg, #2E7D32, #4CAF50); }
.status-bg-2 { background: linear-gradient(135deg, #C62828, #EF5350); }
.status-bg-3 { background: linear-gradient(135deg, #1565C0, #42A5F5); }
.status-bg-4 { background: linear-gradient(135deg, #757575, #BDBDBD); }
.status-icon { font-size: 64rpx; margin-bottom: 12rpx; }
.status-text { font-size: 36rpx; font-weight: 700; margin-bottom: 8rpx; }
.status-desc { font-size: 24rpx; opacity: 0.9; text-align: center; }

.section { background: #fff; margin: 16rpx 24rpx; border-radius: 16rpx; padding: 24rpx; }
.section-title { font-size: 30rpx; font-weight: 600; color: #333; margin-bottom: 20rpx; display: flex; align-items: center; gap: 8rpx; }
.title-icon { font-size: 28rpx; }
.route-name { font-size: 30rpx; font-weight: 600; color: #C41E3A; }

.info-list {}
.info-item { display: flex; justify-content: space-between; align-items: flex-start; padding: 16rpx 0; border-bottom: 1rpx solid #f5f5f5; gap: 24rpx; }
.info-item:last-child { border-bottom: none; }
.info-label { font-size: 28rpx; color: #999; flex-shrink: 0; }
.info-value { font-size: 28rpx; color: #333; text-align: right; flex: 1; }
.info-value.highlight { color: #C41E3A; font-weight: 600; }

.bottom-bar { position: fixed; bottom: 0; left: 0; right: 0; background: #fff; padding: 16rpx 24rpx; padding-bottom: calc(16rpx + env(safe-area-inset-bottom)); box-shadow: 0 -2rpx 12rpx rgba(0,0,0,0.08); display: flex; justify-content: center; z-index: 100; }
.btn-cancel { background: #f5f5f5; color: #666; border-radius: 40rpx; font-size: 28rpx; padding: 0 60rpx; height: 72rpx; line-height: 72rpx; border: none; }
</style>
