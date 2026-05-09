<!-- 我的预约（订单列表）页 -->
<template>
  <view class="order-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack" v-if="!isTabPage">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">我的预约</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 搜索栏：输入手机号查询预约 -->
    <view class="search-bar" v-if="orderList.length === 0 && !loading">
      <view class="search-hint">
        <text class="hint-icon">📞</text>
        <text class="hint-text">请输入预约时填写的手机号查询预约记录</text>
      </view>
      <view class="search-row">
        <input
          class="search-input"
          v-model="searchPhone"
          type="number"
          placeholder="请输入手机号"
          maxlength="11"
        />
        <button class="search-btn" @click="handleSearch">查询</button>
      </view>
    </view>

    <!-- 状态Tab -->
    <view class="status-tabs" v-if="orderList.length > 0">
      <view
        v-for="tab in statusTabs"
        :key="tab.value"
        class="status-tab"
        :class="{ active: currentStatus === tab.value }"
        @click="switchStatus(tab.value)"
      >
        <text>{{ tab.label }}</text>
        <view class="tab-dot" v-if="tab.count > 0">{{ tab.count > 99 ? '99+' : tab.count }}</view>
      </view>
    </view>

    <!-- 订单列表 -->
    <view class="order-list">
      <view
        class="order-card"
        v-for="item in orderList"
        :key="item.id"
        @click="goDetail(item.id)"
      >
        <view class="order-header">
          <text class="order-no">订单号：{{ item.orderNo }}</text>
          <view class="order-status" :class="'status-' + item.status">
            {{ statusLabel(item.status) }}
          </view>
        </view>
        <view class="order-body">
          <view class="order-name">{{ item.teamName }}</view>
          <view class="order-meta">
            <text>👤 {{ item.contactName }} {{ item.contactPhone }}</text>
          </view>
          <view class="order-meta">
            <text>👥 {{ item.teamSize }}人</text>
            <text style="margin-left:20rpx">🗓 {{ item.travelDate }} {{ item.durationDays }}天行程</text>
          </view>
          <view class="order-meta">
            <text>📍 集合：{{ item.meetingAddress || '待通知' }}</text>
          </view>
          <view class="order-meta">
            <text class="time-text">⏰ 集合时间：{{ item.meetingTime || '待通知' }}</text>
          </view>
        </view>
        <view class="order-footer">
          <text class="order-date">下单时间：{{ formatDate(item.createTime) }}</text>
          <view class="order-action" @click.stop>
            <text class="action-btn" v-if="item.status === 0" @click="cancelOrder(item)">取消预约</text>
            <text class="action-btn primary" @click="goDetail(item.id)">查看详情 ›</text>
          </view>
        </view>
      </view>

      <!-- 无数据 -->
      <view class="empty-state" v-if="!loading && orderList.length === 0 && hasSearched">
        <view class="empty-icon">📋</view>
        <view class="empty-text">暂无预约记录</view>
        <button class="go-book-btn" @click="goToIndex">去预约</button>
      </view>

      <!-- 加载中 -->
      <view class="loading-state" v-if="loading">
        <text>加载中...</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, onShow } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const currentStatus = ref('all');
const orderList = ref([]);
const loading = ref(false);
const searchPhone = ref('');
const hasSearched = ref(false);

// 判断是否从TabBar进入（首页有tabBar，子页面没有）
const isTabPage = ref(true);

const statusTabs = ref([
  { label: '全部', value: 'all', count: 0 },
  { label: '待确认', value: '0', count: 0 },
  { label: '已确认', value: '1', count: 0 },
  { label: '已完成', value: '3', count: 0 },
  { label: '已拒绝', value: '2', count: 0 },
]);

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
});

onShow(() => {
  // 如果有缓存的手机号，自动加载
  const cachedPhone = uni.getStorageSync('userPhone');
  if (cachedPhone) {
    searchPhone.value = cachedPhone;
    loadOrders();
  }
});

const statusLabel = (status) => {
  const map = { 0: '待确认', 1: '已确认', 2: '已拒绝', 3: '已完成', 4: '已取消' };
  return map[status] || '未知';
};

const switchStatus = (status) => {
  currentStatus.value = status;
  loadOrders();
};

const handleSearch = () => {
  if (!searchPhone.value || !/^1[3-9]\d{9}$/.test(searchPhone.value)) {
    uni.showToast({ title: '请输入正确的手机号', icon: 'none' });
    return;
  }
  uni.setStorageSync('userPhone', searchPhone.value);
  loadOrders();
};

const loadOrders = async () => {
  if (!searchPhone.value) return;
  loading.value = true;
  hasSearched.value = true;
  try {
    const res = await h5Api.queryBooking(searchPhone.value);
    let list = res.data?.list || res.data || [];

    // 更新各状态数量
    const allCount = list.length;
    const pendingCount = list.filter(i => i.status === 0).length;
    const confirmedCount = list.filter(i => i.status === 1).length;
    const completedCount = list.filter(i => i.status === 3).length;
    const rejectedCount = list.filter(i => i.status === 2).length;
    statusTabs.value = [
      { label: '全部', value: 'all', count: allCount },
      { label: '待确认', value: '0', count: pendingCount },
      { label: '已确认', value: '1', count: confirmedCount },
      { label: '已完成', value: '3', count: completedCount },
      { label: '已拒绝', value: '2', count: rejectedCount },
    ];

    if (currentStatus.value !== 'all') {
      list = list.filter(item => String(item.status) === currentStatus.value);
    }
    orderList.value = list;
  } catch (e) {
    orderList.value = [];
  } finally {
    loading.value = false;
  }
};

const formatDate = (dateStr) => {
  if (!dateStr) return '-';
  return String(dateStr).substring(0, 16);
};

const cancelOrder = (item) => {
  uni.showModal({
    title: '确认取消',
    content: `确定取消"${item.teamName}"的预约吗？`,
    success: async (res) => {
      if (res.confirm) {
        uni.showToast({ title: '已取消预约', icon: 'success' });
        loadOrders();
      }
    },
  });
};

const goDetail = (id) => {
  uni.navigateTo({ url: `/pages/order/detail?id=${id}` });
};

const goBack = () => uni.navigateBack();
const goToIndex = () => {
  uni.switchTab({ url: '/pages/index/index' });
};
</script>

<style scoped>
.order-page { background: #f5f5f5; min-height: 100vh; padding-bottom: calc(120rpx + env(safe-area-inset-bottom)); }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

/* 搜索栏 */
.search-bar { background: #fff; margin: 0 24rpx 16rpx; border-radius: 16rpx; padding: 24rpx; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.search-hint { display: flex; align-items: center; gap: 8rpx; margin-bottom: 20rpx; }
.hint-icon { font-size: 28rpx; }
.hint-text { font-size: 26rpx; color: #999; line-height: 1.5; }
.search-row { display: flex; gap: 16rpx; }
.search-input { flex: 1; background: #f8f8f8; border-radius: 12rpx; padding: 20rpx 24rpx; font-size: 28rpx; color: #333; }
.search-btn { background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 12rpx; font-size: 28rpx; padding: 0 32rpx; height: 80rpx; line-height: 80rpx; border: none; white-space: nowrap; }

/* 状态Tab */
.status-tabs { display: flex; background: #fff; padding: 0 8rpx; position: sticky; top: 0; z-index: 99; border-bottom: 1rpx solid #f0f0f0; }
.status-tab { flex: 1; display: flex; align-items: center; justify-content: center; gap: 6rpx; padding: 20rpx 0; font-size: 28rpx; color: #666; position: relative; white-space: nowrap; }
.status-tab.active { color: #C41E3A; font-weight: 600; }
.status-tab.active::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 48rpx; height: 4rpx; background: #C41E3A; border-radius: 2rpx; }
.tab-dot { background: #C41E3A; color: #fff; font-size: 20rpx; padding: 2rpx 8rpx; border-radius: 20rpx; min-width: 32rpx; text-align: center; }

.order-list { padding: 16rpx 24rpx; }
.order-card { background: #fff; border-radius: 16rpx; margin-bottom: 20rpx; overflow: hidden; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.order-header { display: flex; justify-content: space-between; align-items: center; padding: 20rpx 24rpx; border-bottom: 1rpx solid #f5f5f5; }
.order-no { font-size: 24rpx; color: #999; }
.order-status { font-size: 26rpx; font-weight: 600; padding: 4rpx 16rpx; border-radius: 20rpx; }
.status-0 { background: #FFF3E0; color: #E65100; }
.status-1 { background: #E8F5E9; color: #2E7D32; }
.status-2 { background: #FFEBEE; color: #C62828; }
.status-3 { background: #E3F2FD; color: #1565C0; }
.status-4 { background: #F5F5F5; color: #999; }

.order-body { padding: 20rpx 24rpx; }
.order-name { font-size: 30rpx; font-weight: 600; color: #333; margin-bottom: 12rpx; }
.order-meta { font-size: 26rpx; color: #666; margin-bottom: 8rpx; display: flex; flex-wrap: wrap; gap: 4rpx; }
.time-text { color: #C41E3A; font-weight: 500; }

.order-footer { display: flex; justify-content: space-between; align-items: center; padding: 16rpx 24rpx; border-top: 1rpx solid #f5f5f5; background: #fafafa; }
.order-date { font-size: 24rpx; color: #bbb; }
.order-action { display: flex; gap: 16rpx; }
.action-btn { font-size: 26rpx; color: #999; }
.action-btn.primary { color: #C41E3A; font-weight: 600; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 120rpx 0; }
.empty-icon { font-size: 96rpx; margin-bottom: 24rpx; }
.empty-text { font-size: 28rpx; color: #999; margin-bottom: 40rpx; }
.go-book-btn { background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 40rpx; padding: 0 60rpx; height: 72rpx; line-height: 72rpx; font-size: 28rpx; border: none; }
.loading-state { text-align: center; padding: 40rpx; color: #999; font-size: 28rpx; }
</style>
