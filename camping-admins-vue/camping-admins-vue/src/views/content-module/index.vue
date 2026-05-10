<!-- 内容模块管理 — 统一管理六个分类内容 -->
<template>
  <div class="page-container">

    <!-- 页面头部 -->
    <div class="page-header">
      <div>
        <h2>内容模块管理</h2>
        <p>管理走看聚、清风廉政、与法同行、数字乡村、一县一片、室外线路六个分类的内容</p>
      </div>
      <el-button type="primary" @click="openForm()">
        <el-icon><Plus /></el-icon> 新增内容
      </el-button>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-select v-model="filterCategory" placeholder="全部分类" clearable style="width:160px" @change="loadData(1)">
        <el-option v-for="cat in categories" :key="cat.code" :label="cat.name" :value="cat.code" />
      </el-select>
      <el-input v-model="filterKeyword" placeholder="搜索标题关键词" clearable style="width:240px"
        @keyup.enter="loadData(1)" @clear="loadData(1)" />
      <el-button type="primary" @click="loadData(1)">搜索</el-button>
      <el-button @click="filterCategory=''; filterKeyword=''; loadData(1)">重置</el-button>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div v-for="cat in categories" :key="cat.code"
        class="stat-card"
        :class="{ active: filterCategory === cat.code }"
        @click="filterCategory = filterCategory === cat.code ? '' : cat.code; loadData(1)"
      >
        <div class="stat-name">{{ cat.name }}</div>
        <div class="stat-count">{{ categoryCount[cat.code] || 0 }}</div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="table-card">
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="categoryName" label="分类" width="110" align="center">
          <template #default="{ row }">
            <el-tag size="small" type="danger">{{ row.categoryName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="280" show-overflow-tooltip />
        <el-table-column prop="subtitle" label="副标题" min-width="200" show-overflow-tooltip />
        <el-table-column prop="author" label="作者" width="120" align="center" show-overflow-tooltip />
        <el-table-column prop="source" label="来源" width="150" align="center" show-overflow-tooltip />
        <el-table-column prop="publishDate" label="发布日期" width="120" align="center" />
        <el-table-column prop="viewCount" label="浏览量" width="90" align="center" />
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
        <el-table-column label="操作" width="200" fixed="right" align="center">
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

    <div class="pagination">
      <el-pagination background layout="total, prev, pager, next"
        :total="total" :page-size="pageSize" :current-page="pageNum"
        @current-change="loadData" />
    </div>

    <!-- 新增/编辑弹窗 -->
    <el-dialog v-model="formVisible" :title="formData.id ? '编辑内容' : '新增内容'" width="820px"
      destroy-on-close class="content-dialog">
      <el-form ref="formRef" :model="formData" :rules="formRules" label-width="100px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="所属分类" prop="category">
              <el-select v-model="formData.category" placeholder="请选择分类" style="width:100%">
                <el-option v-for="cat in categories" :key="cat.code" :label="cat.name" :value="cat.code" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发布日期" prop="publishDate">
              <el-date-picker v-model="formData.publishDate" type="date" placeholder="选择日期"
                value-format="YYYY-MM-DD" style="width:100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="内容标题" prop="title">
          <el-input v-model="formData.title" placeholder="请输入内容标题" maxlength="200" show-word-limit />
        </el-form-item>

        <el-form-item label="副标题">
          <el-input v-model="formData.subtitle" placeholder="请输入副标题/简介（可选）" maxlength="200" show-word-limit />
        </el-form-item>

        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="作者">
              <el-input v-model="formData.author" placeholder="请输入作者（可选）" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="来源单位">
              <el-input v-model="formData.source" placeholder="请输入来源单位（可选）" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="封面图片">
          <el-input v-model="formData.coverImage" placeholder="请输入封面图片URL" />
          <div v-if="formData.coverImage" style="margin-top:8px">
            <el-image :src="formData.coverImage" fit="cover"
              style="width:200px;height:120px;border-radius:8px" />
          </div>
        </el-form-item>

        <el-form-item label="详细内容" prop="content">
          <el-input v-model="formData.content" type="textarea" :rows="8"
            placeholder="请输入详细内容，支持HTML富文本格式。如：&lt;p&gt;段落内容&lt;/p&gt;" />
        </el-form-item>

        <el-row :gutter="16">
          <el-col :span="8">
            <el-form-item label="排序">
              <el-input-number v-model="formData.sort" :min="0" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="浏览量">
              <el-input-number v-model="formData.viewCount" :min="0" style="width:100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="状态">
              <el-radio-group v-model="formData.status">
                <el-radio :value="1">启用</el-radio>
                <el-radio :value="0">禁用</el-radio>
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import request from '@/utils/request';
import type { AxiosRequestConfig } from 'axios';

interface Category {
  code: string;
  name: string;
}

const categories: Category[] = [
  { code: 'zkaju', name: '走看聚' },
  { code: 'qflz', name: '清风廉政' },
  { code: 'yffl', name: '与法同行' },
  { code: 'szxc', name: '数字乡村' },
  { code: 'yxyp', name: '一县一片' },
  { code: 'swxl', name: '室外线路' },
];

const filterCategory = ref('');
const filterKeyword = ref('');
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);
const tableData = ref<Record<string, unknown>[]>([]);
const categoryCount = ref<Record<string, number>>({});
const formVisible = ref(false);
const submitLoading = ref(false);
const formRef = ref<FormInstance>();

const formData = reactive<Record<string, unknown>>({
  id: null, category: '', categoryName: '', title: '', subtitle: '',
  content: '', coverImage: '', author: '', source: '',
  publishDate: '', viewCount: 0, sort: 0, status: 1,
});

const formRules: FormRules = {
  category: [{ required: true, message: '请选择所属分类', trigger: 'change' }],
  title: [{ required: true, message: '请输入内容标题', trigger: 'blur' }],
};

const defaultForm = () => ({
  id: null, category: '', categoryName: '', title: '', subtitle: '',
  content: '', coverImage: '', author: '', source: '',
  publishDate: '', viewCount: 0, sort: 0, status: 1,
});

// 加载列表数据
const loadData = async (page = 1) => {
  pageNum.value = page;
  loading.value = true;
  try {
    const res = await request<{ records: Record<string, unknown>[]; total: number }>({
      url: '/admin/content-block/list',
      method: 'get',
      params: {
        category: filterCategory.value || undefined,
        keyword: filterKeyword.value || undefined,
        pageNum: pageNum.value,
        pageSize: pageSize.value,
      },
    } as AxiosRequestConfig);
    tableData.value = res?.records || res || [];
    total.value = (res as unknown as { total: number })?.total || tableData.value.length;

    // 统计各分类数量
    if (page === 1 && !filterCategory.value && !filterKeyword.value) {
      const counts: Record<string, number> = {};
      for (const cat of categories) {
        counts[cat.code] = 0;
      }
      for (const row of tableData.value) {
        const c = row.category as string;
        if (c && counts[c] !== undefined) counts[c]++;
      }
      categoryCount.value = counts;
    }
  } catch { /* ignore */ }
  finally { loading.value = false; }
};

// 打开表单
const openForm = (row?: Record<string, unknown>) => {
  if (row) {
    Object.assign(formData, {
      ...row,
      publishDate: row.publishDate ? String(row.publishDate).substring(0, 10) : '',
    });
  } else {
    Object.assign(formData, defaultForm());
  }
  // 自动填充 categoryName
  if (formData.category) {
    const cat = categories.find(c => c.code === formData.category);
    formData.categoryName = cat?.name || '';
  }
  formVisible.value = true;
};

// 提交保存
const handleSubmit = async () => {
  if (!formRef.value) return;
  try { await formRef.value.validate(); }
  catch { return; }
  // 同步 categoryName
  const cat = categories.find(c => c.code === formData.category);
  formData.categoryName = cat?.name || '';
  submitLoading.value = true;
  try {
    await request({ url: '/admin/content-block/save', method: 'post', data: formData } as AxiosRequestConfig);
    ElMessage.success('保存成功');
    formVisible.value = false;
    loadData();
  } catch { /* ignore */ }
  finally { submitLoading.value = false; }
};

// 删除
const handleDelete = (row: Record<string, unknown>) => {
  ElMessageBox.confirm('确定删除该内容吗？删除后无法恢复。', '提示', { type: 'warning' })
    .then(async () => {
      await request({ url: `/admin/content-block/delete/${row.id}`, method: 'post' } as AxiosRequestConfig);
      ElMessage.success('删除成功');
      loadData();
    }).catch(() => {});
};

// 切换状态
const toggleStatus = async (row: Record<string, unknown>) => {
  const newStatus = row.status === 1 ? 0 : 1;
  await request({ url: `/admin/content-block/status/${row.id}`, method: 'post', params: { status: newStatus } } as AxiosRequestConfig);
  ElMessage.success(newStatus === 1 ? '已启用' : '已禁用');
  loadData();
};

onMounted(() => loadData());
</script>

<style scoped>
.page-container { max-width: 1600px; margin: 0 auto; }

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.page-header h2 { font-size: 20px; font-weight: 600; color: #1a1a2e; margin: 0 0 4px; }
.page-header p { color: #909399; font-size: 14px; margin: 0; }

.filter-bar {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 16px;
}

/* 分类统计卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 12px;
  margin-bottom: 16px;
}
.stat-card {
  background: #fff;
  border-radius: 10px;
  padding: 14px 16px;
  text-align: center;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.2s;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
.stat-card:hover { border-color: #C41E3A; }
.stat-card.active { border-color: #C41E3A; background: #FFF5F5; }
.stat-name { font-size: 13px; color: #666; margin-bottom: 4px; }
.stat-count { font-size: 20px; font-weight: 700; color: #C41E3A; }

.table-card {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
.pagination { display: flex; justify-content: flex-end; margin-top: 16px; }
</style>
