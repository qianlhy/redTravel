<template>
  <div class="page-container">
    <div class="page-header">
      <div>
        <h2>团队预约管理</h2>
        <p>管理团队旅游预约，处理预约确认、拒绝、完成等操作</p>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="搜索团队名称/联系人/手机号/订单号" clearable
        style="width:300px" @keyup.enter="loadData" />
      <el-select v-model="statusFilter" placeholder="全部状态" clearable style="width:140px" @change="loadData">
        <el-option label="待确认" :value="0" />
        <el-option label="已确认" :value="1" />
        <el-option label="已拒绝" :value="2" />
        <el-option label="已完成" :value="3" />
        <el-option label="已取消" :value="4" />
      </el-select>
      <el-button type="primary" @click="loadData">搜索</el-button>
      <el-button @click="keyword=''; statusFilter=''; loadData()">重置</el-button>
    </div>

    <!-- 统计概览 -->
    <div class="status-cards">
      <div v-for="s in statusSummary" :key="s.value" class="status-card"
        :class="{ active: statusFilter === s.value }" @click="toggleStatus(s.value)">
        <div class="sc-num">{{ s.count }}</div>
        <div class="sc-label">{{ s.label }}</div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="table-card">
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="orderNo" label="订单号" width="180" />
        <el-table-column prop="teamName" label="团队名称" min-width="200" />
        <el-table-column prop="contactName" label="联系人" width="100" align="center" />
        <el-table-column prop="contactPhone" label="手机号" width="120" align="center" />
        <el-table-column prop="teamSize" label="人数" width="70" align="center" />
        <el-table-column label="计划出行" width="110" align="center">
          <template #default="{ row }">
            <div>{{ row.travelDate }}</div>
            <div style="font-size:12px;color:#999">{{ row.durationDays }}天</div>
          </template>
        </el-table-column>
        <el-table-column prop="meetingAddress" label="集合地点" min-width="160" show-overflow-tooltip />
        <el-table-column prop="meetingTime" label="集合时间" width="90" align="center" />
        <el-table-column prop="status" label="状态" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="statusTagType(row.status)" size="small">
              {{ statusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" width="160" align="center" />
        <el-table-column label="操作" width="200" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="openDetail(row)">查看详情</el-button>
            <template v-if="row.status === 0">
              <el-button type="success" link size="small" @click="handleConfirm(row)">确认</el-button>
              <el-button type="danger" link size="small" @click="handleReject(row)">拒绝</el-button>
            </template>
            <template v-else-if="row.status === 1">
              <el-button type="info" link size="small" @click="handleComplete(row)">完成</el-button>
              <el-button type="danger" link size="small" @click="handleCancel(row)">取消</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div class="pagination">
      <el-pagination background layout="total, prev, pager, next"
        :total="total" :page-size="pageSize" :current-page="pageNum"
        @current-change="loadData" />
    </div>

    <!-- 详情弹窗 -->
    <el-dialog v-model="detailVisible" title="预约详情" width="680px">
      <div v-if="currentRow" class="booking-detail">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单编号" :span="2">{{ currentRow.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="团队名称">{{ currentRow.teamName }}</el-descriptions-item>
          <el-descriptions-item label="团队人数">{{ currentRow.teamSize }}人</el-descriptions-item>
          <el-descriptions-item label="联系人">{{ currentRow.contactName }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ currentRow.contactPhone }}</el-descriptions-item>
          <el-descriptions-item label="计划出行">{{ currentRow.travelDate }}</el-descriptions-item>
          <el-descriptions-item label="行程天数">{{ currentRow.durationDays }}天</el-descriptions-item>
          <el-descriptions-item label="集合地点" :span="2">{{ currentRow.meetingAddress }}</el-descriptions-item>
          <el-descriptions-item label="集合时间">{{ currentRow.meetingTime }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ currentRow.createTime }}</el-descriptions-item>
          <el-descriptions-item label="状态" :span="2">
            <el-tag :type="statusTagType(currentRow.status)">{{ statusLabel(currentRow.status) }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="备注说明" :span="2">{{ currentRow.remark || '无' }}</el-descriptions-item>
          <el-descriptions-item v-if="currentRow.statusRemark" label="状态说明" :span="2">
            <span style="color:#E6A23C">{{ currentRow.statusRemark }}</span>
          </el-descriptions-item>
          <el-descriptions-item v-if="currentRow.route" label="预约路线" :span="2">
            {{ currentRow.route.name }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer v-if="currentRow?.status === 0">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="success" @click="handleConfirm(currentRow)">确认预约</el-button>
        <el-button type="danger" @click="handleReject(currentRow)">拒绝预约</el-button>
      </template>
      <template #footer v-else>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 拒绝原因弹窗 -->
    <el-dialog v-model="rejectVisible" title="拒绝原因" width="480px">
      <el-form>
        <el-form-item label="拒绝说明">
          <el-input v-model="rejectRemark" type="textarea" :rows="3" placeholder="请输入拒绝原因（选填）" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rejectVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmReject">确认拒绝</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus';
import request from '@/utils/request';
import type { AxiosRequestConfig } from 'axios';

const keyword = ref('');
const statusFilter = ref('');
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const loading = ref(false);
const tableData = ref<Record<string, unknown>[]>([]);
const detailVisible = ref(false);
const rejectVisible = ref(false);
const currentRow = ref<Record<string, unknown> | null>(null);
const rejectRemark = ref('');

const statusSummary = ref([
  { label: '待确认', value: 0, count: 0 },
  { label: '已确认', value: 1, count: 0 },
  { label: '已拒绝', value: 2, count: 0 },
  { label: '已完成', value: 3, count: 0 },
  { label: '已取消', value: 4, count: 0 },
]);

const statusLabel = (s: unknown) => ['待确认', '已确认', '已拒绝', '已完成', '已取消'][(s as number) || 0];
const statusTagType = (s: unknown) => ['warning', 'success', 'danger', 'success', 'info'][(s as number) || 0];

const loadData = async (page = 1) => {
  pageNum.value = page;
  loading.value = true;
  try {
    const res = await request<{ list: Record<string, unknown>[]; total: number }>({
      url: '/admin/team-booking/list', method: 'get',
      params: { keyword: keyword.value, status: statusFilter.value, pageNum: pageNum.value, pageSize: pageSize.value },
    } as AxiosRequestConfig);
    tableData.value = res.data?.list || res.data || [];
    total.value = (res.data as Record<string, number>)?.total || tableData.value.length;
  } catch { /* ignore */ }
  finally { loading.value = false; }
};

const loadSummary = async () => {
  try {
    const res = await request<Record<string, number>>({ url: '/admin/dashboard/stats', method: 'get' } as AxiosRequestConfig);
    const d = res.data;
    if (d) {
      statusSummary.value[0].count = d.pendingBookings || 0;
      statusSummary.value[1].count = d.confirmedBookings || 0;
      statusSummary.value[2].count = d.rejectedBookings || 0;
      statusSummary.value[3].count = d.completedBookings || 0;
      statusSummary.value[4].count = d.cancelledBookings || 0;
    }
  } catch { /* ignore */ }
};

const toggleStatus = (val: number) => {
  statusFilter.value = statusFilter.value === val ? '' : String(val);
  loadData();
};

const openDetail = (row: Record<string, unknown>) => {
  currentRow.value = row;
  detailVisible.value = true;
};

const handleConfirm = async (row: Record<string, unknown>) => {
  await request({ url: `/admin/team-booking/confirm/${row.id}`, method: 'post' } as AxiosRequestConfig);
  ElMessage.success('已确认该预约');
  detailVisible.value = false;
  loadData();
  loadSummary();
};

const handleReject = (row: Record<string, unknown>) => {
  currentRow.value = row;
  rejectRemark.value = '';
  detailVisible.value = false;
  rejectVisible.value = true;
};

const confirmReject = async () => {
  if (!currentRow.value) return;
  await request({
    url: `/admin/team-booking/reject/${currentRow.value.id}`,
    method: 'post',
    params: { remark: rejectRemark.value },
  } as AxiosRequestConfig);
  ElMessage.success('已拒绝该预约');
  rejectVisible.value = false;
  loadData();
  loadSummary();
};

const handleComplete = async (row: Record<string, unknown>) => {
  await request({ url: `/admin/team-booking/complete/${row.id}`, method: 'post' } as AxiosRequestConfig);
  ElMessage.success('已标记为完成');
  loadData();
  loadSummary();
};

const handleCancel = async (row: Record<string, unknown>) => {
  await request({ url: `/admin/team-booking/cancel/${row.id}`, method: 'post' } as AxiosRequestConfig);
  ElMessage.success('已取消该预约');
  loadData();
  loadSummary();
};

onMounted(() => { loadData(); loadSummary(); });
</script>

<style scoped>
.page-container { max-width: 1600px; margin: 0 auto; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h2 { font-size: 20px; font-weight: 600; color: #1a1a2e; margin: 0 0 4px; }
.page-header p { color: #909399; font-size: 14px; margin: 0; }
.search-bar { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; }

.status-cards {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}
.status-card {
  flex: 1;
  background: #fff;
  border-radius: 8px;
  padding: 12px 16px;
  text-align: center;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.2s;
  box-shadow: 0 2px 6px rgba(0,0,0,0.04);
}
.status-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.status-card.active { border-color: #C41E3A; }
.sc-num { font-size: 22px; font-weight: 700; color: #1a1a2e; }
.sc-label { font-size: 12px; color: #909399; margin-top: 2px; }

.table-card { background: #fff; border-radius: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.pagination { display: flex; justify-content: flex-end; margin-top: 16px; }
</style>
