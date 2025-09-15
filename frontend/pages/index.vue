<template>
  <a-table :data-source="users" :columns="columns" :loading="loading" bordered>
    <template #bodyCell="{ column, record }">
      <span v-if="column.dataIndex === 'isActive'">
        <a-tag :color="!record.isActive ? 'volcano' : 'green'">
          {{ record.isActive ? "Active" : "Inactive" }}
        </a-tag>
      </span>
      <span
        v-else-if="
          column.dataIndex === 'createdAt' || column.dataIndex === 'updatedAt'
        "
      >
        {{ new Date(record[column.dataIndex]).toLocaleDateString() }}
      </span>
    </template>
  </a-table>
</template>
<script setup lang="ts">
const usersStore = useUsersStore();
const { users, loading } = storeToRefs(usersStore);
const { t } = useI18n();

const columns = computed(() => [
  {
    title: "ID",
    dataIndex: "id",
    key: "id",
  },
  {
    title: t("name"),
    dataIndex: "name",
    key: "name",
  },
  {
    title: t("email"),
    dataIndex: "email",
    key: "email",
  },
  {
    title: t("status"),
    dataIndex: "isActive",
    key: "isActive",
  },
  {
    title: t("createdAt"),
    dataIndex: "createdAt",
    key: "createdAt",
  },
  {
    title: t("updatedAt"),
    dataIndex: "updatedAt",
    key: "updatedAt",
  },
]);

// ** Fetch data
try {
  await usersStore.fetchUsers();
} catch (error) {
  console.error("Failed to fetch users:", error);
}
</script>
