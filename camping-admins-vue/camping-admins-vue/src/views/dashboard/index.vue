<template>
  <div class="dashboard">
    <!-- 页面标题 -->
    <div class="page-header">
      <div>
        <h2>数据看板</h2>
        <p>实时监控红色旅游平台核心运营数据</p>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card" v-for="stat in statCards" :key="stat.label"
        :style="{ '--accent': stat.color }">
        <div class="stat-icon" :style="{ background: stat.color + '18', color: stat.color }">
          <el-icon size="28"><component :is="stat.icon" /></el-icon>
        </div>
        <div class="stat-body">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
        <div class="stat-sub" v-if="stat.sub">{{ stat.sub }}</div>
      </div>
    </div>

    <!-- 图表区域 -->
    <div class="charts-row">
      <div class="chart-card">
        <div class="chart-header">
          <span class="chart-title">预约趋势图</span>
          <el-radio-group v-model="trendDays" size="small" @change="loadTrend">
            <el-radio-button value="7">近7天</el-radio-button>
            <el-radio-button value="15">近15天</el-radio-button>
            <el-radio-button value="30">近30天</el-radio-button>
          </el-radio-group>
        </div>
        <div ref="trendChartRef" class="chart-body"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, markRaw } from 'vue';
import * as echarts from 'echarts';
import { Calendar, Check, Clock, Close, Guide, Tickets, SuccessFilled, WarnTriangleFilled } from '@element-plus/icons-vue';
import request from '@/utils/request';
import type { AxiosRequestConfig } from 'axios';

const trendChartRef = ref<HTMLDivElement>();
let trendChart: echarts.ECharts | null = null;
const trendDays = ref('7');

interface StatCard {
  label: string;
  value: number | string;
  sub?: string;
  icon: string;
  color: string;
}

const statCards = reactive<StatCard[]>([
  { label: '今日新增预约', value: 0, icon: 'Calendar', color: '#C41E3A' },
  { label: '待处理预约', value: 0, sub: '需尽快处理', icon: 'Clock', color: '#E6A23C' },
  { label: '已确认预约', value: 0, icon: 'Check', color: '#409EFF' },
  { label: '累计预约数', value: 0, icon: 'Tickets', color: '#67C23A' },
  { label: '上架路线', value: 0, icon: 'Guide', color: '#9B59B6' },
  { label: '已完成出行', value: 0, icon: 'SuccessFilled', color: '#1ABC9C' },
]);

const iconMap: Record<string, unknown> = {
  Calendar: markRaw(Calendar),
  Clock: markRaw(Clock),
  Check: markRaw(Check),
  Tickets: markRaw(Tickets),
  Guide: markRaw(Guide),
  SuccessFilled: markRaw(SuccessFilled),
  WarnTriangleFilled: markRaw(WarnTriangleFilled),
};

const initTrendChart = () => {
  if (!trendChartRef.value) return;
  trendChart = echarts.init(trendChartRef.value);
  const option: echarts.EChartsOption = {
    tooltip: { trigger: 'axis' },
    grid: { top: 20, right: 20, bottom: 30, left: 50 },
    xAxis: { type: 'category', data: [], axisLine: { lineStyle: { color: '#ddd' } }, axisLabel: { color: '#666' } },
    yAxis: { type: 'value', axisLine: { show: false }, splitLine: { lineStyle: { color: '#f0f0f0' } }, axisLabel: { color: '#666' } },
    series: [{
      name: '预约数',
      type: 'bar',
      data: [],
      itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
        { offset: 0, color: '#C41E3A' },
        { offset: 1, color: '#FF6B6B' },
      ]), borderRadius: [4, 4, 0, 0] },
      barMaxWidth: 40,
    }],
  };
  trendChart.setOption(option);
};

const loadStats = async () => {
  try {
    const res = await request<Record<string, number>>({ url: '/admin/dashboard/stats', method: 'get' } as AxiosRequestConfig);
    const d = res;
    statCards[0]!.value = d.todayBookings ?? 0;
    statCards[1]!.value = d.pendingBookings ?? 0;
    statCards[2]!.value = d.confirmedBookings ?? 0;
    statCards[3]!.value = d.totalBookings ?? 0;
    statCards[4]!.value = d.activeRoutes ?? 0;
    statCards[5]!.value = d.completedBookings ?? 0;
  } catch { /* ignore */ }
};

const loadTrend = async () => {
  if (!trendChart) return;
  try {
    const res = await request<{ date: string; count: number }[]>({
      url: '/admin/dashboard/booking-trend',
      method: 'get',
      params: { days: trendDays.value },
    } as AxiosRequestConfig);
    const data = res || [];
    trendChart.setOption({
      xAxis: { data: data.map((d: { date: string }) => d.date) },
      series: [{ data: data.map((d: { count: number }) => d.count) }],
    });
  } catch { /* ignore */ }
};

onMounted(async () => {
  // Map icon names to actual components
  statCards.forEach(card => {
    const ic = iconMap[card.icon];
    if (ic) card.icon = ic as unknown as string;
  });
  initTrendChart();
  await loadStats();
  await loadTrend();
  window.addEventListener('resize', () => trendChart?.resize());
});
</script>

<style scoped>
.dashboard { max-width: 1400px; margin: 0 auto; }

.page-header { margin-bottom: 24px; }
.page-header h2 { font-size: 20px; font-weight: 600; color: #1a1a2e; margin: 0 0 4px; }
.page-header p { color: #909399; font-size: 14px; margin: 0; }

.stat-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  transition: box-shadow 0.2s;
  position: relative;
  overflow: hidden;
}
.stat-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
.stat-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; height: 3px;
  background: var(--accent);
}

.stat-icon {
  width: 52px; height: 52px;
  border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}

.stat-body { flex: 1; }
.stat-value { font-size: 24px; font-weight: 700; color: #1a1a2e; line-height: 1.2; }
.stat-label { font-size: 13px; color: #909399; margin-top: 4px; }
.stat-sub { font-size: 12px; color: #E6A23C; }

.charts-row { display: flex; gap: 16px; }

.chart-card {
  flex: 1;
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.chart-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}
.chart-title { font-size: 15px; font-weight: 600; color: #333; }

.chart-body { height: 280px; }
</style>
