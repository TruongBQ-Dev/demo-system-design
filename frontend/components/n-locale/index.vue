<template>
  <a-select
    :value="locale"
    class="h-[32px]"
    style="width: 140px"
    @change="handleLocaleChange"
  >
    <a-select-option
      v-for="i in locales"
      :key="i.code"
      :value="i.code"
      :label="i.name"
    >
      <span role="img" :aria-label="i.name">{{ i.icon }}</span>
      &nbsp;&nbsp;{{ i.name }}
    </a-select-option>
  </a-select>
</template>
<script setup lang="ts">
const { setLocale, locale, locales } = useI18n();

const handleLocaleChange = (value: any) => {
  setLocale(value);
};
</script>
