/**
 * 红色旅游 H5 API 封装
 * 所有接口调用统一从这里发出，配合 vite proxy 自动代理到后端 http://localhost:8080
 *
 * 后端接口前缀说明：
 *   /api/h5/*  — 公开接口（无需登录）
 *   /api/admin/* — 管理员接口
 */

const BASE_URL = import.meta.env.VITE_API_BASE_URL || '';

function request(url, options = {}) {
  return new Promise((resolve, reject) => {
    uni.showLoading({ title: '加载中...', mask: true });
    uni.request({
      url: BASE_URL + url,
      method: options.method || 'GET',
      data: options.data || {},
      header: {
        'Content-Type': 'application/json',
        ...(options.header || {}),
      },
      success: (res) => {
        uni.hideLoading();
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data);
        } else {
          const msg = res.data?.msg || `请求失败 (${res.statusCode})`;
          uni.showToast({ title: msg, icon: 'none', duration: 2000 });
          reject(new Error(msg));
        }
      },
      fail: (err) => {
        uni.hideLoading();
        uni.showToast({ title: '网络异常，请稍后重试', icon: 'none', duration: 2000 });
        reject(err);
      },
    });
  });
}

export const h5Api = {
  // ===== 轮播图 =====
  getBannerList: () => request('/api/h5/banner/list'),

  // ===== 景点 =====
  /** 推荐景点列表 */
  getRecommendAttractions: () => request('/api/h5/attraction/recommend'),
  /** 景点列表（支持搜索） */
  getAttractionList: (params) => request('/api/h5/attraction/list', { data: params }),
  /** 景点详情 */
  getAttractionDetail: (id) => request(`/api/h5/attraction/detail/${id}`),

  // ===== 路线 =====
  /** 推荐路线列表 */
  getRecommendRoutes: () => request('/api/h5/route/recommend'),
  /** 路线列表（支持筛选） */
  getRouteList: (params) => request('/api/h5/route/list', { data: params }),
  /** 路线详情 */
  getRouteDetail: (id) => request(`/api/h5/route/detail/${id}`),

  // ===== 预约 =====
  /** 提交团队预约 */
  submitBooking: (data) => request('/api/h5/booking/submit', { method: 'POST', data }),
  /** 按手机号查询预约 */
  queryBooking: (phone) => request('/api/h5/booking/query', { data: { phone } }),
  /** 按ID查询预约详情 */
  queryBookingById: (id) => request('/api/h5/booking/query', { data: { id } }),
};
