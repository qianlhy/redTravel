// src/router/index.ts
import type { RouteMeta } from '@/types/router';
import { useAdminUserStore } from '@/store/adminUser';
import { ElMessage } from 'element-plus';
import { createRouter, createWebHashHistory } from 'vue-router';
import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/index.vue'),
    meta: { title: '管理员登录' } as RouteMeta,
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('@/views/dashboard/index.vue'), meta: { title: '数据看板', requiresAuth: true } as RouteMeta },
      { path: 'content-module', name: 'ContentModule', component: () => import('@/views/content-module/index.vue'), meta: { title: '内容模块管理', requiresAuth: true } as RouteMeta },
      { path: 'red-attraction', name: 'RedAttraction', component: () => import('@/views/red-attraction/index.vue'), meta: { title: '红色景点管理', requiresAuth: true } as RouteMeta },
      { path: 'travel-route', name: 'TravelRoute', component: () => import('@/views/travel-route/index.vue'), meta: { title: '旅游路线管理', requiresAuth: true } as RouteMeta },
      { path: 'team-booking', name: 'TeamBooking', component: () => import('@/views/team-booking/index.vue'), meta: { title: '团队预约管理', requiresAuth: true } as RouteMeta },
    ],
  },
  { path: '/:pathMatch(.*)*', redirect: '/dashboard' },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const adminUserStore = useAdminUserStore();
  const isLogin = !!adminUserStore.token;
  const meta = to.meta as RouteMeta;
  if (meta.title) document.title = `${meta.title} - 红色旅游管理后台`;
  if (meta.requiresAuth) {
    if (isLogin) next();
    else { ElMessage.warning('请先登录'); next({ path: '/login', query: { redirect: to.fullPath } }); }
  } else {
    if (to.path === '/login' && isLogin) next('/dashboard');
    else next();
  }
});

export default router;
