<script>
export default {
  onLaunch: function() {
    // #ifdef H5
    console.log('App Launch');
    // #endif
  },
  onShow: function() {
    console.log('App Show');
  },
  onHide: function() {
    console.log('App Hide');
  },
};
</script>

<style lang="scss">
@import './common/uni.css';
@import '@/static/customicons.css';

page {
  background-color: #efeff4;
  height: 100%;
  font-size: 28rpx;
}
</style>
