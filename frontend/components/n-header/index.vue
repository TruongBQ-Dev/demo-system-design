<template>
  <a-layout-header
    class="flex items-center justify-between transition-all [transition-property:all,background] [transition-duration:0.4s,0s] bg-white dark:bg-[#141414] !pr-4"
  >
    <div class="logo" />
    <n-locale />
  </a-layout-header>
</template>
<style scoped>
.logo {
  float: left;
  width: 120px;
  height: 31px;
  margin: 16px 24px 16px 0;
  background: rgba(255, 255, 255, 0.3);
}

.ant-row-rtl .logo {
  float: right;
  margin: 16px 0 16px 24px;
}
</style>
