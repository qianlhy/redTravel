// src/store/adminUser.ts
import { adminLogin, getAdminInfo } from '@/api/login';
import type { AdminInfoData, LoginFormData, LoginResponseData } from '@/types/login';
import { ElMessage } from 'element-plus';
import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useAdminUserStore = defineStore('adminUser', () => {
  // state
  const token = ref<string>(localStorage.getItem('adminToken') || '');
  const username = ref<string>(localStorage.getItem('adminUsername') || '');
  const realName = ref<string>(localStorage.getItem('adminRealName') || '');
  const role = ref<string>(localStorage.getItem('adminRole') || '');
  const userId = ref<number>(Number(localStorage.getItem('adminUserId') || '0'));

  // computed
  const isLogin = computed(() => !!token.value);

  // actions
  async function login(form: LoginFormData): Promise<void> {
    const res = await adminLogin(form);
    const data: LoginResponseData = res;
    token.value = data.token;
    username.value = data.username;
    realName.value = data.realName || '';
    role.value = data.role;
    userId.value = data.userId;
    localStorage.setItem('adminToken', data.token);
    localStorage.setItem('adminUsername', data.username);
    localStorage.setItem('adminRealName', data.realName || '');
    localStorage.setItem('adminRole', data.role);
    localStorage.setItem('adminUserId', String(data.userId));
    ElMessage.success('登录成功');
  }

  async function fetchInfo(): Promise<void> {
    const res = await getAdminInfo();
    const info: AdminInfoData = res;
    username.value = info.username;
    realName.value = info.realName;
    role.value = info.role;
  }

  function logout(): void {
    token.value = '';
    username.value = '';
    realName.value = '';
    role.value = '';
    userId.value = 0;
    localStorage.removeItem('adminToken');
    localStorage.removeItem('adminUsername');
    localStorage.removeItem('adminRealName');
    localStorage.removeItem('adminRole');
    localStorage.removeItem('adminUserId');
  }

  return { token, username, realName, role, userId, isLogin, login, fetchInfo, logout };
});
