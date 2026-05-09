<template>
  <!-- Vue3 模板语法和 Vue2 基本一致，uniapp 依旧使用 view、text 等小程序标签 -->
  <view class="book-page-container">
    <text class="page-title">露营预订页面（Vue3 版本）</text>
  </view>
</template>

<!-- Vue3 核心：script setup 语法，无需 export default，直接写逻辑 -->
<script setup lang="ts"> // 若使用 TypeScript，添加 lang="ts"；纯 JS 可删除该配置
// 1. 导入 uniapp 生命周期、API（按需导入，也可直接使用 uni.xxx）
import { onLoad, onShow } from '@dcloudio/uni-app';

// 2. 定义响应式数据（Vue3 推荐使用 ref/reactive）
import { ref, reactive } from 'vue';

// 简单类型响应式数据（ref）
const pageTitle = ref('露营预订');
// 复杂对象响应式数据（reactive）
const bookForm = reactive({
  campName: '',
  bookDate: '',
  personCount: 1
});

// 3. 定义自定义方法（直接声明即可，无需放在 methods 中）
const handleSubmitBook = () => {
  console.log('提交预订信息：', bookForm);
  // 后续可调用 uni.request 发送预订请求
  uni.showToast({
    title: '预订提交中...',
    icon: 'loading'
  });
};

// 4. 调用 uniapp 页面生命周期（和 Vue2 的页面生命周期一致，写法更简洁）
onLoad((options) => {
  // 页面加载时执行，接收跳转传递的参数
  console.log('预订页面加载完成，接收参数：', options);
  // 示例：如果跳转时传递了 campName，赋值给响应式数据
  if (options.campName) {
    bookForm.campName = options.campName;
  }
});

onShow(() => {
  // 页面显示时执行（比如从其他页面返回时刷新数据）
  console.log('预订页面显示');
});
</script>

<style scoped>
/* scoped 表示样式仅对当前页面生效，避免样式污染 */
.book-page-container {
  padding: 30rpx 20rpx;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.page-title {
  font-size: 36rpx;
  color: #333;
  font-weight: 600;
  margin-bottom: 20rpx;
}
</style>