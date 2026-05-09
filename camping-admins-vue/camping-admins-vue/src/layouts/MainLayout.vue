<template>
  <el-container class="app-container">
    <!-- 左侧导航 -->
    <el-aside :width="isCollapsed ? '64px' : '220px'" class="aside">
      <!-- Logo区域 -->
      <div class="logo-area">
        <div class="logo-icon">
          <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
            <path d="M14 2L26 8V20L14 26L2 20V8L14 2Z" fill="#C41E3A" stroke="#fff" stroke-width="1.5"/>
            <path d="M14 8L20 11V17L14 20L8 17V11L14 8Z" fill="#FFD700"/>
          </svg>
        </div>
        <span v-show="!isCollapsed" class="logo-text">红色旅游后台</span>
      </div>

      <!-- 导航菜单 -->
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapsed"
        :collapse-transition="false"
        router
        class="nav-menu"
        background-color="#1a1a2e"
        text-color="#a0a0b0"
        active-text-color="#ffffff"
      >
        <el-menu-item index="/dashboard">
          <el-icon><DataLine /></el-icon>
          <template #title>数据看板</template>
        </el-menu-item>
        <el-menu-item index="/red-attraction">
          <el-icon><OfficeBuilding /></el-icon>
          <template #title>红色景点管理</template>
        </el-menu-item>
        <el-menu-item index="/travel-route">
          <el-icon><Guide /></el-icon>
          <template #title>旅游路线管理</template>
        </el-menu-item>
        <el-menu-item index="/team-booking">
          <el-icon><Calendar /></el-icon>
          <template #title>团队预约管理</template>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <!-- 右侧主区域 -->
    <el-container>
      <!-- 顶部栏 -->
      <el-header class="header">
        <div class="header-left">
          <el-button text @click="isCollapsed = !isCollapsed">
            <el-icon size="20"><Fold v-if="!isCollapsed" /><Expand v-else /></el-icon>
          </el-button>
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="header-right">
          <span class="admin-name">{{ adminUserStore.realName || adminUserStore.username }}</span>
          <el-dropdown @command="handleCommand">
            <el-avatar :size="36" style="background:#C41E3A;cursor:pointer">
              {{ (adminUserStore.realName || adminUserStore.username || 'A').charAt(0) }}
            </el-avatar>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 内容区 -->
      <el-main class="main-content">
        <RouterView />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAdminUserStore } from '@/store/adminUser';
import { Fold, Expand, DataLine, OfficeBuilding, Guide, Calendar } from '@element-plus/icons-vue';

const route = useRoute();
const router = useRouter();
const adminUserStore = useAdminUserStore();
const isCollapsed = ref(false);

const activeMenu = computed(() => route.path);
const currentTitle = computed(() => {
  const meta = route.meta as { title?: string };
  return meta?.title || '数据看板';
});

const handleCommand = (command: string) => {
  if (command === 'logout') {
    adminUserStore.logout();
    router.push('/login');
  }
};
</script>

<style scoped>
.app-container { width: 100vw; height: 100vh; overflow: hidden; }

.aside {
  background: #1a1a2e;
  transition: width 0.3s;
  overflow-x: hidden;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.logo-area {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 16px;
  gap: 12px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  background: #1a1a2e;
  flex-shrink: 0;
}

.logo-icon { display: flex; align-items: center; flex-shrink: 0; }
.logo-text {
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
}

.nav-menu {
  border-right: none;
  flex: 1;
}

:deep(.el-menu-item.is-active) {
  background: rgba(196,30,58,0.2) !important;
  border-left: 3px solid #C41E3A;
}

:deep(.el-menu-item:hover) {
  background: rgba(255,255,255,0.06) !important;
  color: #fff;
}

.header {
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  border-bottom: 1px solid #f0f0f0;
  height: 60px;
}

.header-left { display: flex; align-items: center; gap: 16px; }
.header-right { display: flex; align-items: center; gap: 12px; }
.admin-name { font-size: 14px; color: #333; }

.main-content {
  background: #f0f2f5;
  padding: 20px;
  overflow-y: auto;
  height: calc(100vh - 60px);
}
</style>
