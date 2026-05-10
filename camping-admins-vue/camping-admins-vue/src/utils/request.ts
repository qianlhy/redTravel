// src/utils/request.ts
import { useAdminUserStore } from '@/store/adminUser';
import axios from 'axios';
import type { AxiosRequestConfig } from 'axios';
import { ElMessage } from 'element-plus';

const service = axios.create({
  baseURL: (import.meta.env.VITE_API_BASE_URL as string) || 'https://kko.wfeezor.cn',
  timeout: 15000,
  headers: { 'Content-Type': 'application/json;charset=utf-8' },
});

service.interceptors.request.use((config) => {
    const adminUserStore = useAdminUserStore();
    if (adminUserStore.token) {
      config.headers = config.headers || {};
      config.headers['X-Admin-Id'] = String(adminUserStore.userId);
      config.headers['Authorization'] = 'Bearer ' + adminUserStore.token;  // 添加这行
    }
    return config;
  }, (error) => Promise.reject(error));

service.interceptors.response.use(
  (response) => {
    const res = response.data;
    if (res.code !== 200) {
      // 非 200 业务错误：只 reject 不弹 toast
      // 各页面 catch 块自行处理提示
      return Promise.reject(new Error(res.msg));
    }
    return res.data;  // ← 修改这里
  },
  (error) => {
    const adminUserStore = useAdminUserStore();
    if (error.response?.status === 401) {
      adminUserStore.logout();
      ElMessage.error('登录过期，请重新登录');
      window.location.href = '/#/login';
    } else if (error.response?.status === 403) {
      ElMessage.error('无权限访问');
    } else if (error.response?.status >= 500) {
      ElMessage.error('服务器异常，请稍后重试');
    } else if (!error.response) {
      ElMessage.error('网络异常，请检查网络连接');
    }
    return Promise.reject(error);
  }
);

const request = <T = unknown>(config: AxiosRequestConfig): Promise<T> => {
  return service(config) as Promise<T>;
};

export default request;
