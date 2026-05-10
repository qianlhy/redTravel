<template>
  <div class="page-container">
    <div class="page-header">
      <div>
        <h2>旅游路线管理</h2>
        <p>管理红色旅游精品路线，包含行程安排、集合信息等</p>
      </div>
      <el-button type="primary" @click="openForm()">
        <el-icon><Plus /></el-icon> 新增路线
      </el-button>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="搜索路线名称" clearable style="width:240px" @keyup.enter="loadData" />
      <el-select v-model="themeFilter" placeholder="全部主题" clearable style="width:160px" @change="loadData">
        <el-option label="红色教育" value="红色教育" />
        <el-option label="历史追溯" value="历史追溯" />
        <el-option label="研学旅行" value="研学旅行" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="keyword=''; themeFilter=''; loadData()">重置</el-button>
    </div>

    <!-- 数据表格 -->
    <div class="table-card">
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="name" label="路线名称" min-width="200" />
        <el-table-column prop="theme" label="主题" width="100" align="center">
          <template #default="{ row }">
            <el-tag size="small" type="danger">{{ row.theme || '-' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="durationDays" label="天数" width="80" align="center">
          <template #default="{ row }">{{ row.durationDays }}天</template>
        </el-table-column>
        <el-table-column prop="groupSize" label="人数" width="80" align="center" />
        <el-table-column prop="price" label="价格" width="100" align="center">
          <template #default="{ row }">
            <span style="color:#C41E3A;font-weight:600">¥{{ row.price }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="startLocation" label="出发地" width="120" align="center" />
        <el-table-column prop="endLocation" label="目的地" width="120" align="center" />
        <el-table-column prop="meetingTime" label="集合时间" width="100" align="center" />
        <el-table-column prop="status" label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'" size="small">
              {{ row.status === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="封面图" width="90" align="center">
          <template #default="{ row }">
            <el-image v-if="row.coverImage" :src="row.coverImage" fit="cover"
              style="width:60px;height:40px;border-radius:4px" :preview-src-list="[row.coverImage]" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="220" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openForm(row)">编辑</el-button>
            <el-button type="primary" link size="small" @click="openDetail(row)">查看详情</el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="pagination">
      <el-pagination background layout="total, prev, pager, next"
        :total="total" :page-size="pageSize" :current-page="pageNum"
        @current-change="loadData" />
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="formVisible" :title="formData.id ? '编辑路线' : '新增路线'" width="760px" destroy-on-close>
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="16">
            <el-form-item label="路线名称" prop="name">
              <el-input v-model="formData.name" placeholder="请输入路线名称" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="主题" prop="theme">
              <el-select v-model="formData.theme" placeholder="请选择" style="width:100%">
                <el-option label="红色教育" value="红色教育" />
                <el-option label="历史追溯" value="历史追溯" />
                <el-option label="研学旅行" value="研学旅行" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="行程天数" prop="durationDays">
              <el-input-number v-model="formData.durationDays" :min="1" :max="30" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="建议人数" prop="groupSize">
              <el-input-number v-model="formData.groupSize" :min="1" :max="500" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="价格(元/人)" prop="price">
              <el-input-number v-model="formData.price" :min="0" :precision="2" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="出发地" prop="startLocation">
              <el-input v-model="formData.startLocation" placeholder="如：上海人民广场" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="目的地" prop="endLocation">
              <el-input v-model="formData.endLocation" placeholder="如：嘉兴南湖" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="集合地点" prop="meetingAddress">
              <el-input v-model="formData.meetingAddress" placeholder="请输入集合地点" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="集合时间" prop="meetingTime">
              <el-input v-model="formData.meetingTime" placeholder="如：07:30" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="路线简介" prop="summary">
          <el-input v-model="formData.summary" type="textarea" :rows="2" placeholder="请输入路线简介" />
        </el-form-item>
        <el-form-item label="封面图片" prop="coverImage">
          <el-input v-model="formData.coverImage" placeholder="请输入封面图片URL" />
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="排序" prop="sort">
              <el-input-number v-model="formData.sort" :min="0" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="formData.status">
                <el-radio :value="1">上架</el-radio>
                <el-radio :value="0">下架</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="formVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">保存</el-button>
      </template>
    </el-dialog>

    <!-- 详情弹窗 -->
    <el-dialog v-model="detailVisible" title="路线详情" width="800px">
      <div v-if="currentRow" class="route-detail">
        <div class="detail-banner">
          <el-image :src="currentRow.coverImage" fit="cover" style="width:100%;height:200px;border-radius:8px" />
        </div>
        <el-descriptions :column="2" border style="margin-top:16px">
          <el-descriptions-item label="路线名称">{{ currentRow.name }}</el-descriptions-item>
          <el-descriptions-item label="主题">{{ currentRow.theme }}</el-descriptions-item>
          <el-descriptions-item label="行程天数">{{ currentRow.durationDays }}天</el-descriptions-item>
          <el-descriptions-item label="建议人数">{{ currentRow.groupSize }}人</el-descriptions-item>
          <el-descriptions-item label="价格">¥{{ currentRow.price }} /人</el-descriptions-item>
          <el-descriptions-item label="出发地">{{ currentRow.startLocation }}</el-descriptions-item>
          <el-descriptions-item label="目的地">{{ currentRow.endLocation }}</el-descriptions-item>
          <el-descriptions-item label="集合时间">{{ currentRow.meetingTime }}</el-descriptions-item>
          <el-descriptions-item label="集合地点" :span="2">{{ currentRow.meetingAddress }}</el-descriptions-item>
          <el-descriptions-item label="路线简介" :span="2">{{ currentRow.summary }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import request from '@/utils/request';
import type { AxiosRequestConfig } from 'axios';

const keyword = ref('');
const themeFilter = ref('');
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);
const tableData = ref<Record<string, unknown>[]>([]);
const formVisible = ref(false);
const detailVisible = ref(false);
const submitLoading = ref(false);
const currentRow = ref<Record<string, unknown> | null>(null);
const formRef = ref<FormInstance>();

const formData = reactive<Record<string, unknown>>({
  id: null, name: '', theme: '', durationDays: 1, groupSize: 30, price: 0,
  startLocation: '', endLocation: '', meetingAddress: '', meetingTime: '',
  summary: '', coverImage: '', sort: 0, status: 1,
});

const formRules: FormRules = {
  name: [{ required: true, message: '请输入路线名称', trigger: 'blur' }],
  durationDays: [{ required: true, message: '请输入行程天数', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
};

const defaultForm = () => ({
  id: null, name: '', theme: '', durationDays: 1, groupSize: 30, price: 0,
  startLocation: '', endLocation: '', meetingAddress: '', meetingTime: '',
  summary: '', coverImage: '', sort: 0, status: 1,
});

const loadData = async (page = 1) => {
  pageNum.value = page;
  loading.value = true;
  try {
    const res = await request<{ list: Record<string, unknown>[]; total: number }>({
      url: '/admin/travel-route/list', method: 'get',
      params: { keyword: keyword.value, theme: themeFilter.value, pageNum: pageNum.value, pageSize: pageSize.value },
    } as AxiosRequestConfig);
    tableData.value = res?.list || res || [];
    total.value = (res as unknown as { total: number })?.total || tableData.value.length;
  } catch { /* ignore */ }
  finally { loading.value = false; }
};

const openForm = (row?: Record<string, unknown>) => {
  if (row) Object.assign(formData, row);
  else Object.assign(formData, defaultForm());
  formVisible.value = true;
};

const openDetail = (row: Record<string, unknown>) => {
  currentRow.value = row;
  detailVisible.value = true;
};

const handleSubmit = async () => {
  if (!formRef.value) return;
  try { await formRef.value.validate(); }
  catch { return; }
  submitLoading.value = true;
  try {
    await request({ url: '/admin/travel-route/save', method: 'post', data: formData } as AxiosRequestConfig);
    ElMessage.success('保存成功');
    formVisible.value = false;
    loadData();
  } catch { /* ignore */ }
  finally { submitLoading.value = false; }
};

const handleDelete = (row: Record<string, unknown>) => {
  ElMessageBox.confirm('确定删除该路线吗？', '提示', { type: 'warning' })
    .then(async () => {
      await request({ url: `/admin/travel-route/delete/${row.id}`, method: 'post' } as AxiosRequestConfig);
      ElMessage.success('删除成功');
      loadData();
    }).catch(() => {});
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
