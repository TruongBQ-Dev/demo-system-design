import type { UsersState, User } from "~/types/users.types";

export const useUsersStore = defineStore("users", {
  state: (): UsersState => ({
    users: [],
    loading: false,
    error: null,
  }),
  actions: {
    async fetchUsers() {
      this.loading = true;
      this.error = null;
      try {
        const res: User[] = await useFetchClient.get(`/v1/users`);
        this.users = res;
      } catch (error) {
        this.error =
          error instanceof Error
            ? error.message
            : "An error occurred while fetching users.";
      } finally {
        this.loading = false;
      }
    },
  },
});
