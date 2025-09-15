export interface UsersState {
  users: User[];
  loading: boolean;
  error: string | null;
}

export interface User {
  id: number;
  email: string;
  name: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}
