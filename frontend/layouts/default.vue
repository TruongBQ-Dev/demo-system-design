<template>
  <a-app class="h-screen">
    <a-layout class="h-screen">
      <n-header />
      <a-layout>
        <n-sider />
        <a-layout class="pl-2 pt-2 md:pl-4 md:pt-4">
          <!-- <n-breadcrumb /> -->
          <a-layout-content class="bg-white min-h-[280px] rounded-tl-lg p-4">
            <slot />
          </a-layout-content>
        </a-layout>
      </a-layout>
    </a-layout>
  </a-app>
</template>
