import { defineNuxtRouteMiddleware, navigateTo } from "nuxt/app";

export default defineNuxtRouteMiddleware(async (to) => {
  const token = useCookie("auth_token");

  if (!token.value) {
    if (to.path === "/auth") {
      return;
    }
    return navigateTo("/auth");
  }

  if (to.path === "/auth") {
    const meStore = useMeStore();
    if (!meStore.user) {
      try {
        await meStore.getProfile();
        return navigateTo("/");
      } catch {
        token.value = null;
        return;
      }
    } else {
      return navigateTo("/");
    }
  }

  const meStore = useMeStore();
  if (!meStore.user) {
    try {
      await meStore.getProfile();
    } catch {
      token.value = null;
      return navigateTo("/auth");
    }
  }
});
