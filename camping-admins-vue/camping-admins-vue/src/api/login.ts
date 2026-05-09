// src/api/login.ts
import request from '@/utils/request';
import type { ApiResponse } from '@/types/api';
import type { AdminInfoData, LoginFormData, LoginResponseData } from '@/types/login';

export const adminLogin = (data: LoginFormData): Promise<ApiResponse<LoginResponseData>> => {
  return request<LoginResponseData>({ url: '/api/admin/login', method: 'post', data });
};

export const getAdminInfo = (): Promise<ApiResponse<AdminInfoData>> => {
  return request<AdminInfoData>({ url: '/api/admin/info', method: 'post' });
};
