<template>
  <!-- 营位卡片 -->
  <view class="camp-item" @click="goToCampDetail">
    <!-- 营位图片 -->
    <view class="camp-img">
      <image :src="camp.image" mode="aspectFill"></image>
      <!-- 营位状态标签 -->
      <view class="camp-status" :style="{ background: camp.status === '可预订' ? '#4CAF50' : '#FF9800' }">
        {{ camp.status }}
      </view>
    </view>
    <!-- 营位信息 -->
    <view class="camp-info">
      <view class="camp-name">{{ camp.name }}</view>
      <view class="camp-store">{{ camp.storeName }}</view>
      <view class="camp-price">
        <text class="price">¥{{ camp.price }}</text>
        <text class="unit">/晚</text>
      </view>
    </view>
  </view>
</template>

<script setup>
// import { navigateTo } from '@dcloudio/uni-app';

// 接收父组件传递的营位数据
const props = defineProps({
  camp: {
    type: Object,
    required: true,
    default: () => ({
      id: '',
      name: '',
      image: '',
      storeName: '',
      price: 0,
      status: ''
    })
  }
});

// 点击跳转营位详情页
const goToCampDetail = () => {
  uni.navigateTo({
    url: `/pages/camp/detail?id=${props.camp.id}`
  });
};
</script>

<style scoped>
.camp-item {
  width: 340rpx;
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.camp-img {
  width: 100%;
  height: 200rpx;
  position: relative;
  overflow: hidden;
}

.camp-img image {
  width: 100%;
  height: 100%;
}

.camp-status {
  position: absolute;
  top: 12rpx;
  right: 12rpx;
  font-size: 24rpx;
  color: #fff;
  padding: 4rpx 12rpx;
  border-radius: 32rpx;
}

.camp-info {
  padding: 16rpx;
}

.camp-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 8rpx;
}

.camp-store {
  font-size: 24rpx;
  color: #999;
  margin-bottom: 12rpx;
}

.camp-price {
  display: flex;
  align-items: baseline;
}

.price {
  font-size: 32rpx;
  font-weight: 600;
  color: #E53935;
}

.unit {
  font-size: 24rpx;
  color: #999;
  margin-left: 4rpx;
}
</style>