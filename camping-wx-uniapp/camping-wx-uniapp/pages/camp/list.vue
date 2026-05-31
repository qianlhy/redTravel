<template>
  <view class="camp-list-page">
    <!-- 筛选栏 -->
    <view class="filter-bar">
      <!-- 门店筛选（下拉选择） -->
      <view class="filter-item" @click="showStoreFilter = true">
        <text>{{ selectedStore.name || '全部门店' }}</text>
        <uni-icons type="down" size="16" color="#999"></uni-icons>
      </view>
      
      <!-- 价格排序 -->
      <view class="filter-item" @click="togglePriceSort">
        <text>价格{{ priceSort === 'asc' ? '↑' : priceSort === 'desc' ? '↓' : '' }}</text>
      </view>
      
      <!-- 营位状态 -->
      <view class="filter-item" @click="toggleCampStatus">
        <text>{{ selectedStatus === 'all' ? '全部状态' : selectedStatus === 'enable' ? '可预订' : '已下架' }}</text>
      </view>
    </view>

    <!-- 营位列表 -->
    <view class="camp-container" v-if="!loading">
      <!-- 复用camp-item组件 -->
      <view class="camp-list">
        <camp-item :camp="camp" v-for="camp in filterCampList" :key="camp.id"></camp-item>
      </view>
      
      <!-- 空状态提示 -->
      <view class="empty-tip" v-if="filterCampList.length === 0">
        <image src="/static/images/empty.png" mode="widthFix" class="empty-img"></image>
        <text>暂无符合条件的营位~</text>
      </view>
    </view>

    <!-- 加载中状态 -->
    <view class="loading-tip" v-if="loading">
      <uni-load-more type="loading" text="加载中..."></uni-load-more>
    </view>

    <!-- 门店筛选弹窗 -->
    <uni-popup v-model="showStoreFilter" type="bottom">
      <view class="popup-content">
        <view class="popup-title">选择门店</view>
        <view class="store-option" v-for="store in storeList" :key="store.id" @click="selectStore(store)">
          <text>{{ store.storeName }}</text>
          <uni-icons type="checkmark" size="18" color="#2F80ED" v-if="selectedStore.id === store.id"></uni-icons>
        </view>
        <view class="popup-footer">
          <button class="cancel-btn" @click="showStoreFilter = false">取消</button>
          <button class="confirm-btn" @click="confirmStoreFilter">确认</button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { onLoad, onPullDownRefresh, onReachBottom } from '@dcloudio/uni-app';
import campItem from '@/components/camp-item.vue';

// 后端接口基础地址
const baseUrl = 'https://kko.wfeezor.cn/api';

// 定义响应式数据
let campList = []; // 原始营位列表
let storeList = []; // 门店列表（用于筛选）
let loading = true; // 加载状态
let showStoreFilter = false; // 是否显示门店筛选弹窗
let selectedStore = { id: '', name: '全部门店' }; // 选中的门店
let priceSort = ''; // 价格排序：asc-升序，desc-降序
let selectedStatus = 'all'; // 营位状态：all-全部，enable-可预订

// 筛选后的营位列表（计算属性）
const filterCampList = () => {
  let result = [...campList];
  
  // 1. 门店筛选
  if (selectedStore.id) {
    result = result.filter(camp => camp.storeName === selectedStore.name);
  }
  
  // 2. 价格排序
  if (priceSort === 'asc') {
    result.sort((a, b) => a.price - b.price);
  } else if (priceSort === 'desc') {
    result.sort((a, b) => b.price - a.price);
  }
  
  // 3. 状态筛选
  if (selectedStatus === 'enable') {
    result = result.filter(camp => camp.status === '可预订');
  } else if (selectedStatus === 'disable') {
    result = result.filter(camp => camp.status !== '可预订');
  }
  
  return result;
};

// 加载营位列表数据
const loadCampList = () => {
  loading = true;
  // 调用后端营位列表接口（当前复用推荐营位接口，后续可替换为专门的列表接口 /api/camp/list）
  uni.request({
    url: `${baseUrl}/index/recommendCamp`,
    method: 'GET',
    success: (res) => {
      if (res.data.code === 200) {
        campList = res.data.data;
      } else {
        uni.showToast({ title: res.data.msg, icon: 'none' });
      }
    },
    fail: () => {
      uni.showToast({ title: '网络请求失败', icon: 'none' });
    },
    complete: () => {
      loading = false;
      uni.stopPullDownRefresh(); // 停止下拉刷新
    }
  });
};

// 加载门店列表（用于筛选）
const loadStoreList = () => {
  uni.request({
    url: `${baseUrl}/index/hotStore`,
    method: 'GET',
    success: (res) => {
      if (res.data.code === 200) {
        storeList = res.data.data;
      }
    }
  });
};

// 价格排序切换
const togglePriceSort = () => {
  if (priceSort === '') {
    priceSort = 'asc';
  } else if (priceSort === 'asc') {
    priceSort = 'desc';
  } else {
    priceSort = '';
  }
};

// 营位状态切换
const toggleCampStatus = () => {
  if (selectedStatus === 'all') {
    selectedStatus = 'enable';
  } else if (selectedStatus === 'enable') {
    selectedStatus = 'disable';
  } else {
    selectedStatus = 'all';
  }
};

// 选择门店
const selectStore = (store) => {
  selectedStore = { id: store.id, name: store.storeName };
};

// 确认门店筛选
const confirmStoreFilter = () => {
  showStoreFilter = false;
};

// 页面加载时执行
onLoad(() => {
  loadCampList();
  loadStoreList();
});

// 下拉刷新
onPullDownRefresh(() => {
  loadCampList();
});

// 上拉加载更多（预留分页功能）
onReachBottom(() => {
  // 后续对接后端分页接口时，添加分页逻辑
  uni.showToast({ title: '暂无更多数据', icon: 'none' });
});
</script>

<style scoped>
.camp-list-page {
  background: #f5f7fa;
  min-height: 100vh;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  justify-content: space-around;
  padding: 16rpx 0;
  background: #fff;
  border-bottom: 1rpx solid #f0f0f0;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
  font-size: 28rpx;
  color: #333;
}

/* 营位列表 */
.camp-container {
  padding: 16rpx;
}

.camp-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  justify-content: space-between;
}

/* 空状态 */
.empty-tip {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 100rpx 0;
  color: #999;
  font-size: 28rpx;
}

.empty-img {
  width: 200rpx;
  height: 200rpx;
  margin-bottom: 24rpx;
}

/* 加载中 */
.loading-tip {
  padding: 40rpx 0;
  text-align: center;
}

/* 筛选弹窗 */
.popup-content {
  background: #fff;
  border-radius: 20rpx 20rpx 0 0;
  padding-bottom: 40rpx;
}

.popup-title {
  font-size: 32rpx;
  font-weight: 600;
  padding: 24rpx;
  border-bottom: 1rpx solid #f0f0f0;
  text-align: center;
}

.store-option {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24rpx 32rpx;
  font-size: 28rpx;
  border-bottom: 1rpx solid #f5f5f5;
}

.popup-footer {
  display: flex;
  margin-top: 24rpx;
  padding: 0 32rpx;
  gap: 20rpx;
}

.popup-footer button {
  flex: 1;
  height: 88rpx;
  line-height: 88rpx;
  border-radius: 44rpx;
  font-size: 32rpx;
}

.cancel-btn {
  background: #f5f5f5;
  color: #666;
}

.confirm-btn {
  background: #2F80ED;
  color: #fff;
}
</style>