<template>
  <!-- 门店卡片 -->
  <view class="store-card" @click="goToStoreDetail">
    <!-- 门店图片 -->
    <view class="store-img">
      <image :src="store.image" mode="aspectFill"></image>
    </view>
    <!-- 门店信息 -->
    <view class="store-info">
      <view class="store-name">{{ store.name }}</view>
      <view class="store-tag">
        <text v-for="tag in store.tags" :key="tag" class="tag-item">{{ tag }}</text>
      </view>
      <view class="store-meta">
        <text class="distance">{{ store.distance }}</text>
        <text class="camp-count">可订营位 {{ store.availableCamp }} 个</text>
      </view>
    </view>
  </view>
</template>

<script setup>
// import { navigateTo } from '@dcloudio/uni-app';

// 接收父组件传递的门店数据
const props = defineProps({
  store: {
    type: Object,
    required: true,
    default: () => ({
      id: '',
      name: '',
      image: '',
      tags: [],
      distance: '',
      availableCamp: 0
    })
  }
});

// 点击跳转门店详情页
const goToStoreDetail = () => {
  uni.navigateTo({
    url: `/pages/store/detail?id=${props.store.id}`
  });
};
</script>

<style scoped>
.store-card {
  display: flex;
  padding: 16rpx;
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 16rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.store-img {
  width: 160rpx;
  height: 160rpx;
  border-radius: 12rpx;
  overflow: hidden;
}

.store-img image {
  width: 100%;
  height: 100%;
}

.store-info {
  flex: 1;
  padding: 8rpx 16rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.store-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.store-tag {
  display: flex;
  gap: 12rpx;
  margin: 8rpx 0;
}

.tag-item {
  font-size: 24rpx;
  padding: 4rpx 12rpx;
  background: #f5fafe;
  color: #2F80ED;
  border-radius: 32rpx;
}

.store-meta {
  display: flex;
  justify-content: space-between;
  font-size: 26rpx;
  color: #999;
}
</style>