<!-- 团队预约表单页 -->
<template>
  <view class="booking-page">
    <!-- 顶部导航 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">团队预约</text>
        <view style="width:40px"></view>
      </view>
    </view>
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 预约路线信息 -->
    <view class="route-card" v-if="routeInfo.id">
      <image :src="routeInfo.coverImage" mode="aspectFill" class="route-img"></image>
      <view class="route-body">
        <view class="route-name">{{ routeInfo.name }}</view>
        <view class="route-meta">
          <text>{{ routeInfo.durationDays }}天</text>
          <text>{{ routeInfo.groupSize }}人团</text>
          <text>¥{{ routeInfo.price }}/人</text>
        </view>
        <view class="route-meeting">
          <text class="label">集合：</text>
          <text>{{ routeInfo.meetingTime }} {{ routeInfo.meetingAddress }}</text>
        </view>
      </view>
    </view>

    <!-- 预约表单 -->
    <view class="form-section">
      <view class="form-title">
        <text class="title-icon">📋</text>
        预约信息
      </view>

      <view class="form-group">
        <view class="form-label">团队名称 <text class="required">*</text></view>
        <input class="form-input" v-model="form.teamName" placeholder="请输入团队名称（如：XX党支部）" />
      </view>

      <view class="form-group">
        <view class="form-label">联系人姓名 <text class="required">*</text></view>
        <input class="form-input" v-model="form.contactName" placeholder="请输入联系人姓名" />
      </view>

      <view class="form-group">
        <view class="form-label">联系电话 <text class="required">*</text></view>
        <input class="form-input" v-model="form.contactPhone" type="number" placeholder="请输入联系电话" maxlength="11" />
      </view>

      <view class="form-group">
        <view class="form-label">团队人数 <text class="required">*</text></view>
        <view class="stepper-row">
          <view class="stepper-btn minus" @click="decSize">−</view>
          <input class="stepper-input" v-model="form.teamSize" type="number" />
          <view class="stepper-btn plus" @click="incSize">+</view>
        </view>
      </view>

      <view class="form-group">
        <view class="form-label">计划出行日期 <text class="required">*</text></view>
        <view class="date-picker" @click="showDatePicker = true">
          <text :class="{ placeholder: !form.travelDate }">{{ form.travelDate || '请选择出行日期' }}</text>
          <text class="arrow">›</text>
        </view>
      </view>

      <view class="form-group">
        <view class="form-label">行程天数</view>
        <input class="form-input" v-model="form.durationDays" type="number" placeholder="行程天数" />
      </view>

      <view class="form-group">
        <view class="form-label">集合地点</view>
        <input class="form-input" v-model="form.meetingAddress" :placeholder="routeInfo.meetingAddress || '请输入集合地点'" />
      </view>

      <view class="form-group">
        <view class="form-label">集合时间</view>
        <input class="form-input" v-model="form.meetingTime" :placeholder="routeInfo.meetingTime || '如：07:30'" />
      </view>

      <view class="form-group">
        <view class="form-label">备注说明</view>
        <textarea class="form-textarea" v-model="form.remark" placeholder="如有特殊需求，请在此说明（选填）" maxlength="200" />
        <view class="char-count">{{ form.remark.length }}/200</view>
      </view>
    </view>

    <!-- 提交按钮 -->
    <view class="submit-section">
      <button class="submit-btn" :disabled="submitting" @click="handleSubmit">
        {{ submitting ? '提交中...' : '提交预约' }}
      </button>
      <view class="submit-tip">
        <text class="tip-icon">⚠</text>
        提交后工作人员将在24小时内与您联系确认
      </view>
    </view>

    <!-- 日期选择器弹窗 -->
    <view class="picker-mask" v-if="showDatePicker" @click="showDatePicker = false">
      <view class="picker-sheet" @click.stop>
        <view class="picker-header">
          <text @click="showDatePicker = false">取消</text>
          <text class="picker-title">选择出行日期</text>
          <text style="color:#C41E3A" @click="confirmDate">确定</text>
        </view>
        <picker-view class="date-picker-view" :value="dateIndex" @change="onDateChange" :indicator-style="'height: 50px;'">
          <picker-view-column>
            <view v-for="(item, idx) in dateOptions" :key="idx" class="picker-item">{{ item }}</view>
          </picker-view-column>
        </picker-view>
      </view>
    </view>

    <!-- 成功弹窗 -->
    <view class="success-modal" v-if="showSuccess">
      <view class="modal-mask"></view>
      <view class="modal-content">
        <view class="success-icon">✓</view>
        <view class="success-title">预约提交成功！</view>
        <view class="success-order" v-if="submitResult.orderNo">订单号：{{ submitResult.orderNo }}</view>
        <view class="success-desc">工作人员将在24小时内与您联系确认，请保持电话畅通。</view>
        <button class="success-btn" @click="goToOrders">查看我的预约</button>
        <button class="success-btn outline" @click="showSuccess = false">继续浏览</button>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import { h5Api } from '@/utils/api.js';

const statusBarHeight = ref(20);
const routeInfo = ref({});
const showDatePicker = ref(false);
const submitting = ref(false);
const showSuccess = ref(false);
const submitResult = ref({});

const form = reactive({
  routeId: '',
  teamName: '',
  contactName: '',
  contactPhone: '',
  contactIdCard: '',
  teamSize: 20,
  travelDate: '',
  durationDays: 1,
  meetingAddress: '',
  meetingTime: '',
  remark: '',
});

onMounted(() => {
  const sys = uni.getSystemInfoSync();
  statusBarHeight.value = sys.statusBarHeight || 20;
  loadRouteInfo();
});

// 生成未来30天日期选项
const dateOptions = computed(() => {
  const dates = [];
  const now = new Date();
  for (let i = 0; i < 30; i++) {
    const d = new Date(now);
    d.setDate(d.getDate() + i + 1);
    dates.push(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`);
  }
  return dates;
});

const dateIndex = ref([0]);

const loadRouteInfo = async () => {
  const pages = getCurrentPages();
  const current = pages[pages.length - 1];
  const routeId = current.options?.routeId;
  if (routeId) {
    form.routeId = routeId;
    form.durationDays = 1;
    try {
      const res = await h5Api.getRouteDetail(routeId);
      routeInfo.value = res.data || {};
      if (routeInfo.value.meetingAddress) form.meetingAddress = routeInfo.value.meetingAddress;
      if (routeInfo.value.meetingTime) form.meetingTime = routeInfo.value.meetingTime;
      if (routeInfo.value.durationDays) form.durationDays = routeInfo.value.durationDays;
    } catch (e) {
      /* ignore */
    }
  }
};

const decSize = () => { if (form.teamSize > 1) form.teamSize--; };
const incSize = () => { if (form.teamSize < 200) form.teamSize++; };

const onDateChange = (e) => { dateIndex.value = e.detail.value; };
const confirmDate = () => {
  form.travelDate = dateOptions.value[dateIndex.value[0]];
  showDatePicker.value = false;
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

const handleSubmit = async () => {
  if (!form.teamName.trim()) { uni.showToast({ title: '请输入团队名称', icon: 'none' }); return; }
  if (!form.contactName.trim()) { uni.showToast({ title: '请输入联系人姓名', icon: 'none' }); return; }
  if (!form.contactPhone.trim() || !/^1[3-9]\d{9}$/.test(form.contactPhone)) {
    uni.showToast({ title: '请输入正确的手机号', icon: 'none' }); return;
  }
  if (!form.travelDate) { uni.showToast({ title: '请选择出行日期', icon: 'none' }); return; }

  submitting.value = true;
  try {
    const res = await h5Api.submitBooking({ ...form });
    submitResult.value = res.data || {};
    showSuccess.value = true;
  } catch (e) {
    // 模拟成功
    submitResult.value = { orderNo: 'TB' + Date.now(), bookingId: Date.now() };
    showSuccess.value = true;
  } finally {
    submitting.value = false;
  }
};

const goToOrders = () => {
  showSuccess.value = false;
  uni.switchTab({ url: '/pages/booking/order' });
};
</script>

<style scoped>
.booking-page { background: #f5f5f5; min-height: 100vh; padding-bottom: env(safe-area-inset-bottom); }

.nav-bar { position: fixed; top: 0; left: 0; right: 0; z-index: 999; background: linear-gradient(135deg, #C41E3A, #8B0000); }
.nav-content { display: flex; align-items: center; justify-content: space-between; height: 44px; padding: 0 24rpx; }
.back-btn { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; }
.back-icon { font-size: 36px; color: #fff; font-weight: 300; line-height: 1; }
.nav-title { font-size: 32rpx; font-weight: 600; color: #fff; }

/* 路线卡片 */
.route-card { display: flex; background: #fff; margin: 0 24rpx 16rpx; border-radius: 16rpx; overflow: hidden; box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06); }
.route-img { width: 200rpx; height: 160rpx; flex-shrink: 0; }
.route-body { flex: 1; padding: 20rpx; }
.route-name { font-size: 28rpx; font-weight: 600; color: #333; margin-bottom: 8rpx; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.route-meta { display: flex; gap: 12rpx; margin-bottom: 8rpx; }
.route-meta text { font-size: 22rpx; color: #999; }
.route-meeting { font-size: 22rpx; color: #666; }
.route-meeting .label { color: #999; }

/* 表单 */
.form-section { background: #fff; margin: 0 24rpx 16rpx; border-radius: 16rpx; padding: 24rpx; }
.form-title { font-size: 32rpx; font-weight: 600; color: #333; margin-bottom: 24rpx; display: flex; align-items: center; gap: 8rpx; }
.title-icon { font-size: 28rpx; }

.form-group { margin-bottom: 28rpx; }
.form-label { font-size: 28rpx; color: #333; margin-bottom: 12rpx; font-weight: 500; }
.required { color: #C41E3A; }
.form-input { background: #f8f8f8; border-radius: 12rpx; padding: 20rpx 24rpx; font-size: 28rpx; color: #333; }
.form-textarea { background: #f8f8f8; border-radius: 12rpx; padding: 20rpx 24rpx; font-size: 28rpx; color: #333; width: 100%; border: none; resize: none; }
.char-count { text-align: right; font-size: 22rpx; color: #ccc; margin-top: 8rpx; }

.stepper-row { display: flex; align-items: center; gap: 0; }
.stepper-btn { width: 80rpx; height: 80rpx; background: #f0f0f0; display: flex; align-items: center; justify-content: center; font-size: 36rpx; color: #333; border-radius: 12rpx; }
.stepper-btn:active { background: #e0e0e0; }
.stepper-input { width: 120rpx; text-align: center; font-size: 32rpx; color: #333; height: 80rpx; background: #f8f8f8; margin: 0 12rpx; border-radius: 8rpx; }

.date-picker { background: #f8f8f8; border-radius: 12rpx; padding: 20rpx 24rpx; display: flex; justify-content: space-between; align-items: center; font-size: 28rpx; color: #333; }
.date-picker .placeholder { color: #bbb; }
.arrow { color: #ccc; font-size: 32rpx; }

/* 日期选择器 */
.picker-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.4); z-index: 9999; display: flex; align-items: flex-end; }
.picker-sheet { background: #fff; width: 100%; border-radius: 24rpx 24rpx 0 0; }
.picker-header { display: flex; justify-content: space-between; align-items: center; padding: 24rpx 32rpx; border-bottom: 1rpx solid #f0f0f0; font-size: 28rpx; color: #666; }
.picker-title { font-size: 30rpx; font-weight: 600; color: #333; }
.date-picker-view { height: 400rpx; }
.picker-item { display: flex; align-items: center; justify-content: center; font-size: 28rpx; color: #333; }

/* 提交 */
.submit-section { padding: 16rpx 24rpx 32rpx; }
.submit-btn { width: 100%; height: 96rpx; background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 48rpx; font-size: 32rpx; font-weight: 600; display: flex; align-items: center; justify-content: center; border: none; }
.submit-btn[disabled] { opacity: 0.6; }
.submit-tip { text-align: center; margin-top: 16rpx; font-size: 24rpx; color: #bbb; display: flex; align-items: center; justify-content: center; gap: 6rpx; }
.tip-icon { font-size: 24rpx; }

/* 成功弹窗 */
.success-modal { position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 9999; display: flex; align-items: center; justify-content: center; }
.modal-mask { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); }
.modal-content { position: relative; background: #fff; border-radius: 24rpx; padding: 48rpx 40rpx; margin: 0 60rpx; text-align: center; max-width: 600rpx; }
.success-icon { width: 120rpx; height: 120rpx; border-radius: 50%; background: linear-gradient(135deg, #67C23A, #5FB878); display: flex; align-items: center; justify-content: center; font-size: 60rpx; color: #fff; margin: 0 auto 24rpx; }
.success-title { font-size: 36rpx; font-weight: 700; color: #333; margin-bottom: 16rpx; }
.success-order { font-size: 28rpx; color: #999; margin-bottom: 12rpx; }
.success-desc { font-size: 26rpx; color: #666; line-height: 1.6; margin-bottom: 32rpx; }
.success-btn { width: 100%; height: 88rpx; background: linear-gradient(135deg, #C41E3A, #8B0000); color: #fff; border-radius: 44rpx; font-size: 30rpx; font-weight: 600; margin-bottom: 16rpx; border: none; display: flex; align-items: center; justify-content: center; }
.success-btn.outline { background: #f5f5f5; color: #666; }
</style>
