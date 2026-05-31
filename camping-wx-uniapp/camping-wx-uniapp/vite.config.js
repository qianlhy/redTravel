import uni from '@dcloudio/vite-plugin-uni';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [uni()],
  server: {
    port: 5173,
    proxy: {
      // 将 /api 开头的请求代理到后端服务器
      '/api': {
        target: 'https://kko.wfeezor.cn',
        changeOrigin: true,
      },
    },
  },
});
