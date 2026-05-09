// src/store/adminUser.ts
import { adminLogin, getAdminInfo } from '@/api/login';
import type { AdminInfoData, LoginFormData, LoginResponseData } from '@/types/login';
import { ElMessage } from 'element-plus';
import { defineStore } from 'pinia';

interface AdminUserState {
  token: string;
  username: string;
  realName: string;
  role: string;
  userId: number;
}

export const useAdminUserStore = defineStore('adminUser', {
  state: (): AdminUserState => ({
    token: localStorage.getItem('adminToken') || '',
    username: localStorage.getItem('adminUsername') || '',
    realName: localStorage.getItem('adminRealName') || '',
    role: localStorage.getItem('adminRole') || '',
    userId: Number(localStorage.getItem('adminUserId') || '0'),
  }),
  actions: {
    async login(form: LoginFormData): Promise<void> {
      const res = await adminLogin(form);
      const data: LoginResponseData = res.data;
      this.token = data.token;
      this.username = data.username;
      this.realName = data.realName;
      this.role = data.role;
      this.userId = data.userId;
      localStorage.setItem('adminToken', data.token);
      localStorage.setItem('adminUsername', data.username);
      localStorage.setItem('adminRealName', data.realName || '');
      localStorage.setItem('adminRole', data.role);
      localStorage.setItem('adminUserId', String(data.userId));
      ElMessage.success('登录成功');
    },
    async fetchInfo(): Promise<void> {
      const res = await getAdminInfo();
      const info: AdminInfoData = res.data;
      this.username = info.username;
      this.realName = info.realName;
      this.role = info.role;
    },
    logout(): void {
      this.token = '';
      this.username = '';
      this.realName = '';
      this.role = '';
      this.userId = 0;
      localStorage.removeItem('adminToken');
      localStorage.removeItem('adminUsername');
      localStorage.removeItem('adminRealName');
      localStorage.removeItem('adminRole');
      localStorage.removeItem('adminUserId');
    },
  },
});
