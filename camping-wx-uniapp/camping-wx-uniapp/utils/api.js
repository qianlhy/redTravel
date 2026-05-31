/**
 * 红色旅游 H5 API 封装
 * 所有接口调用统一从这里发出，配合 vite proxy 自动代理到后端 http://localhost:8080
 *
 * 后端接口前缀说明：
 *   /api/h5/*  — 公开接口（无需登录）
 *   /api/admin/* — 管理员接口
 */

const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://kko.wfeezor.cn';

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
  getRecommendAttractions: () => request('/api/h5/attraction/recommend'),
  getAttractionList: (params) => request('/api/h5/attraction/list', { data: params }),
  getAttractionDetail: (id) => request(`/api/h5/attraction/detail/${id}`),

  // ===== 路线 =====
  getRecommendRoutes: () => request('/api/h5/route/recommend'),
  getRouteList: (params) => request('/api/h5/route/list', { data: params }),
  getRouteDetail: (id) => request(`/api/h5/route/detail/${id}`),

  // ===== 预约 =====
  submitBooking: (data) => request('/api/h5/booking/submit', { method: 'POST', data }),
  queryBooking: (phone) => request('/api/h5/booking/query', { data: { phone } }),
  queryBookingById: (id) => request('/api/h5/booking/query', { data: { id } }),

  // ===== 内容模块（6个分类） =====
  /** 获取六个分类配置 */
  getContentCategories: () => request('/api/h5/content/categories'),
  /** 按分类获取内容列表（首页展示用） */
  getContentByCategory: (category, limit) =>
    request(`/api/h5/content/list/${category}`, { data: limit ? { limit } : {} }),
  /** 分页内容列表（列表页用） */
  getContentPage: (params) => request('/api/h5/content/page', { data: params }),
  /** 内容详情 */
  getContentDetail: (id) => request(`/api/h5/content/detail/${id}`),
};
