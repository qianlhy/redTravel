<template>
  <div class="login-page">
    <div class="login-card">
      <div class="card-header">
        <div class="logo-area">
          <svg width="48" height="48" viewBox="0 0 28 28" fill="none">
            <path d="M14 2L26 8V20L14 26L2 20V8L14 2Z" fill="#C41E3A" stroke="#fff" stroke-width="1.5"/>
            <path d="M14 8L20 11V17L14 20L8 17V11L14 8Z" fill="#FFD700"/>
          </svg>
        </div>
        <h1 class="title">红色旅游管理后台</h1>
        <p class="subtitle">Red Tourism Admin System</p>
      </div>

      <el-form ref="formRef" :model="form" :rules="rules" label-position="top" class="login-form">
        <el-form-item label="管理员账号" prop="username">
          <el-input v-model="form.username" placeholder="请输入管理员账号" size="large" prefix-icon="User" clearable />
        </el-form-item>
        <el-form-item label="登录密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入登录密码" size="large"
            prefix-icon="Lock" show-password @keyup.enter="handleLogin" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" :loading="loading" class="login-btn" @click="handleLogin">
            {{ loading ? '登录中...' : '登 录' }}
          </el-button>
        </el-form-item>
      </el-form>

      <div class="tips">
        <span>默认账号：admin</span>
        <span>默认密码：123456</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAdminUserStore } from '@/store/adminUser';
import { ElMessage, FormInstance, FormRules } from 'element-plus';

const router = useRouter();
const adminUserStore = useAdminUserStore();
const formRef = ref<FormInstance>();
const loading = ref(false);

const form = reactive({ username: '', password: '' });

const rules: FormRules = {
  username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
};

const handleLogin = async () => {
  if (!formRef.value) return;
  try { await formRef.value.validate(); }
  catch { return; }
  loading.value = true;
  try {
    await adminUserStore.login(form);
    router.push('/dashboard');
  } catch (err: unknown) {
    ElMessage.error((err as Error)?.message || '登录失败，请检查账号密码');
  }
  finally { loading.value = false; }
};
</script>

<style scoped>
.login-page {
  width: 100vw; height: 100vh;
  background: linear-gradient(135deg, #C41E3A 0%, #8B0000 50%, #5C0011 100%);
  display: flex; align-items: center; justify-content: center;
}

.login-card {
  width: 420px;
  background: #fff;
  border-radius: 16px;
  padding: 40px 36px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

.card-header { text-align: center; margin-bottom: 32px; }
.logo-area { display: flex; justify-content: center; margin-bottom: 16px; }
.title { font-size: 22px; font-weight: 700; color: #333; margin-bottom: 4px; }
.subtitle { font-size: 13px; color: #999; letter-spacing: 1px; }

.login-form { margin-top: 8px; }
.login-btn { width: 100%; height: 48px; font-size: 16px; letter-spacing: 4px; margin-top: 8px; }

.tips {
  margin-top: 16px;
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #bbb;
}
</style>
