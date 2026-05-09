<template>
  <div class="page-container">
    <div class="page-header">
      <div>
        <h2>红色景点管理</h2>
        <p>管理红色旅游景点、革命圣地、纪念馆等景点信息</p>
      </div>
      <el-button type="primary" @click="openForm()">
        <el-icon><Plus /></el-icon> 新增景点
      </el-button>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="搜索景点名称/城市" clearable @clear="loadData" style="width:280px" />
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="keyword=''; loadData()">重置</el-button>
    </div>

    <!-- 数据表格 -->
    <div class="table-card">
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="name" label="景点名称" min-width="180" />
        <el-table-column prop="province" label="省份" width="100" align="center" />
        <el-table-column prop="city" label="城市" width="100" align="center" />
        <el-table-column prop="openTime" label="开放时间" width="120" align="center" />
        <el-table-column prop="ticketPrice" label="门票(元)" width="90" align="center">
          <template #default="{ row }">{{ row.ticketPrice ?? '免费' }}</template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="80" align="center" />
        <el-table-column prop="status" label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'" size="small">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="封面图" width="90" align="center">
          <template #default="{ row }">
            <el-image v-if="row.coverImage" :src="row.coverImage" fit="cover"
              style="width:60px;height:40px;border-radius:4px" :preview-src-list="[row.coverImage]" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openForm(row)">编辑</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
            <el-button type="warning" link size="small" @click="toggleStatus(row)">
              {{ row.status === 1 ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination background layout="total, prev, pager, next"
        :total="total" :page-size="pageSize" :current-page="pageNum"
        @current-change="loadData" />
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="formVisible" :title="formData.id ? '编辑景点' : '新增景点'" width="720px" destroy-on-close>
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="景点名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入景点名称" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="省份" prop="province">
              <el-input v-model="formData.province" placeholder="如：浙江省" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市" prop="city">
              <el-input v-model="formData.city" placeholder="如：嘉兴市" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="formData.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="开放时间" prop="openTime">
              <el-input v-model="formData.openTime" placeholder="如：09:00-17:00" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="门票价格" prop="ticketPrice">
              <el-input-number v-model="formData.ticketPrice" :min="0" :precision="2" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="封面图片" prop="coverImage">
          <el-input v-model="formData.coverImage" placeholder="请输入封面图片URL" />
        </el-form-item>
        <el-form-item label="景点简介" prop="description">
          <el-input v-model="formData.description" type="textarea" :rows="3" placeholder="请输入景点简介" />
        </el-form-item>
        <el-form-item label="红色故事" prop="historyStory">
          <el-input v-model="formData.historyStory" type="textarea" :rows="3" placeholder="请输入红色历史故事" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="formData.sort" :min="0" style="width:100%" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :value="1">启用</el-radio>
            <el-radio :value="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="formVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox, FormInstance, FormRules } from 'element-plus';
import request from '@/utils/request';
import type { AxiosRequestConfig } from 'axios';

const keyword = ref('');
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);
const tableData = ref<Record<string, unknown>[]>([]);
const formVisible = ref(false);
const submitLoading = ref(false);
const formRef = ref<FormInstance>();

const formData = reactive<Record<string, unknown>>({
  id: null, name: '', province: '', city: '', address: '', openTime: '',
  ticketPrice: 0, coverImage: '', description: '', historyStory: '', sort: 0, status: 1,
});

const formRules: FormRules = {
  name: [{ required: true, message: '请输入景点名称', trigger: 'blur' }],
  province: [{ required: true, message: '请输入省份', trigger: 'blur' }],
  city: [{ required: true, message: '请输入城市', trigger: 'blur' }],
};

const defaultForm = () => ({
  id: null, name: '', province: '', city: '', address: '', openTime: '',
  ticketPrice: 0, coverImage: '', description: '', historyStory: '', sort: 0, status: 1,
});

const loadData = async (page = 1) => {
  pageNum.value = page;
  loading.value = true;
  try {
    const res = await request<{ list: Record<string, unknown>[]; total: number }>({
      url: '/admin/red-attraction/list',
      method: 'get',
      params: { keyword: keyword.value, pageNum: pageNum.value, pageSize: pageSize.value },
    } as AxiosRequestConfig);
    tableData.value = res.data?.list || res.data || [];
    total.value = (res.data as Record<string, number>)?.total || tableData.value.length;
  } catch { /* ignore */ }
  finally { loading.value = false; }
};

const openForm = (row?: Record<string, unknown>) => {
  if (row) Object.assign(formData, row);
  else Object.assign(formData, defaultForm());
  formVisible.value = true;
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try { await formRef.value.validate(); }
  catch { return; }
  submitLoading.value = true;
  try {
    await request({ url: '/admin/red-attraction/save', method: 'post', data: formData } as AxiosRequestConfig);
    ElMessage.success('保存成功');
    formVisible.value = false;
    loadData();
  } catch { /* ignore */ }
  finally { submitLoading.value = false; }
};

const handleDelete = (row: Record<string, unknown>) => {
  ElMessageBox.confirm('确定删除该景点吗？', '提示', { type: 'warning' })
    .then(async () => {
      await request({ url: `/admin/red-attraction/delete/${row.id}`, method: 'post' } as AxiosRequestConfig);
      ElMessage.success('删除成功');
      loadData();
    }).catch(() => {});
};

const toggleStatus = async (row: Record<string, unknown>) => {
  const newStatus = row.status === 1 ? 0 : 1;
  await request({ url: `/admin/red-attraction/status/${row.id}`, method: 'post', params: { status: newStatus } } as AxiosRequestConfig);
  ElMessage.success(newStatus === 1 ? '已启用' : '已禁用');
  loadData();
};

onMounted(() => loadData());
</script>

<style scoped>
.page-container { max-width: 1400px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h2 { font-size: 20px; font-weight: 600; color: #1a1a2e; margin: 0 0 4px; }
.page-header p { color: #909399; font-size: 14px; margin: 0; }
.search-bar { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; }
.table-card { background: #fff; border-radius: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.pagination { display: flex; justify-content: flex-end; margin-top: 16px; }
</style>
