export const useMeStore = defineStore("me", {
  state: () => ({
    user: null,
  }),
  actions: {
    async getProfile() {
      try {
        this.user = await useFetchClient.get(`/v1/users/profile`);
      } catch (error) {
        this.user = null;
      }
    },
    setData(data: any) {
      this.user = data;
    },
    clear() {
      this.user = null;
    },
  },
});
