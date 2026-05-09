// src/types/login.ts
export interface LoginFormData {
  username: string;
  password: string;
}

export interface LoginResponseData {
  token: string;
  userId: number;
  username: string;
  realName: string;
  role: string;
}

export interface AdminInfoData {
  id: number;
  username: string;
  realName: string;
  role: string;
  phone?: string;
}
