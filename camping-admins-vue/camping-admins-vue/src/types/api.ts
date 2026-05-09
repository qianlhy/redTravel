// src/types/api.ts
export interface ApiResponse<T = Record<string, unknown>> {
  code: number;
  msg: string;
  data: T;
  timestamp?: number;
}

export interface PageResult<T = unknown> {
  list: T[];
  total: number;
  pageNum: number;
  pageSize: number;
  pages: number;
}


  