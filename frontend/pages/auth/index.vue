<template>
  <div class="max-w-md w-full space-y-8">
    <!-- Change locale -->
    <n-locale class="absolute top-4 right-4 z-10" />
    <!-- Header -->
    <div class="text-center">
      <div
        class="w-16 h-16 bg-slate-700 rounded-lg mx-auto mb-4 flex items-center justify-center"
      >
        <div class="w-8 h-8 bg-white rounded opacity-80" />
      </div>
      <h2 class="text-3xl font-bold text-gray-900 mb-2">
        {{ isLogin ? $t("login") : $t("register") }}
      </h2>
      <p class="text-gray-600">
        {{ isLogin ? $t("welcomeBack") : $t("createAccount") }}
      </p>
    </div>

    <!-- Form Card -->
    <div class="bg-white rounded-lg shadow-md p-8">
      <a-form
        ref="formRef"
        :rules="rules"
        :model="formData"
        layout="vertical"
        class="space-y-4"
      >
        <!-- Name field (only for register) -->
        <a-form-item
          v-if="!isLogin"
          ref="name"
          name="name"
          :label="$t('fullName')"
        >
          <a-input
            v-model:value="formData.name"
            size="large"
            :placeholder="$t('inputFullName')"
            :prefix="h(UserOutlined)"
          />
        </a-form-item>

        <!-- Email field -->
        <a-form-item ref="email" name="email" :label="$t('email')">
          <a-input
            v-model:value="formData.email"
            type="email"
            size="large"
            :placeholder="$t('inputEmail')"
            :prefix="h(MailOutlined)"
          />
        </a-form-item>

        <!-- Password field -->
        <a-form-item ref="password" name="password" :label="$t('password')">
          <a-input-password
            v-model:value="formData.password"
            size="large"
            :placeholder="$t('inputPassword')"
            :prefix="h(LockOutlined)"
          />
        </a-form-item>

        <!-- Confirm Password field (only for register) -->
        <a-form-item
          v-if="!isLogin"
          ref="confirmPassword"
          name="confirmPassword"
          :label="$t('confirmPassword')"
        >
          <a-input-password
            v-model:value="formData.confirmPassword"
            size="large"
            :placeholder="$t('inputConfirmPassword')"
            :prefix="h(LockOutlined)"
          />
        </a-form-item>

        <!-- Remember me / Terms (conditional) -->
        <a-form-item v-if="isLogin" ref="remember" name="remember">
          <div class="flex items-center justify-between">
            <a-checkbox v-model:checked="formData.remember">
              {{ $t("remember") }}
            </a-checkbox>
            <a href="#" class="text-blue-600 hover:text-blue-500 text-sm">
              {{ $t("forgotPassword") }}
            </a>
          </div>
        </a-form-item>

        <a-form-item v-else ref="agreeTerms" name="agreeTerms">
          <a-checkbox v-model:checked="formData.agreeTerms">
            {{ $t("agreeTerms.prefix") }}
            <a href="#" class="text-blue-600 hover:text-blue-500">
              {{ $t("agreeTerms.terms") }}
            </a>
            {{ $t("agreeTerms.and") }}
            <a href="#" class="text-blue-600 hover:text-blue-500">
              {{ $t("agreeTerms.privacy") }}
            </a>
          </a-checkbox>
        </a-form-item>

        <!-- Submit Button -->
        <a-form-item class="mb-0 pt-4">
          <a-button
            type="primary"
            html-type="submit"
            size="large"
            block
            :loading="loading"
            class="bg-slate-700 border-slate-700 hover:bg-slate-600 hover:border-slate-600"
            @click="handleSubmit"
          >
            {{ isLogin ? $t("login") : $t("register") }}
          </a-button>
        </a-form-item>
      </a-form>

      <!-- Divider -->
      <a-divider class="!my-4">
        <span class="text-gray-400 text-sm">{{ $t("or") }}</span>
      </a-divider>

      <!-- Social Login -->
      <div class="space-y-3">
        <a-button
          size="large"
          block
          class="flex items-center justify-center space-x-2"
        >
          <svg class="w-5 h-5" viewBox="0 0 24 24">
            <path
              fill="#4285F4"
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
            />
            <path
              fill="#34A853"
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
            />
            <path
              fill="#FBBC05"
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
            />
            <path
              fill="#EA4335"
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
            />
          </svg>
          <span
            >{{ isLogin ? $t("login") : $t("register") }}
            {{ $t("loginWithGoogle") }}</span
          >
        </a-button>

        <a-button
          size="large"
          block
          class="flex items-center justify-center space-x-2"
        >
          <svg class="w-5 h-5" fill="#1877F2" viewBox="0 0 24 24">
            <path
              d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"
            />
          </svg>
          <span
            >{{ isLogin ? $t("login") : $t("register") }}
            {{ $t("loginWithFacebook") }}</span
          >
        </a-button>
      </div>

      <!-- Switch Form -->
      <div class="text-center mt-6 pt-4 border-t border-gray-200">
        <span class="text-gray-600">
          {{ isLogin ? $t("dontHaveAccount") : $t("alreadyHaveAccount") }}
        </span>
        <a
          href="#"
          class="ml-2 text-blue-600 hover:text-blue-500 font-medium"
          @click.prevent="toggleForm"
        >
          {{ isLogin ? $t("signUpNow") : $t("login") }}
        </a>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  UserOutlined,
  MailOutlined,
  LockOutlined,
} from "@ant-design/icons-vue";

const { t } = useI18n();
const router = useRouter();

// Define page
definePageMeta({
  layout: "auth",
});

// State
const isLogin = ref(true);
const loading = ref(false);

// Form data
const formRef = ref();
const formData = reactive({
  name: "",
  email: "",
  password: "",
  confirmPassword: "",
  remember: false,
  agreeTerms: false,
});

// Form errors
const rules = computed(() => ({
  name: [{ required: !isLogin.value, message: t("validate.nameRequired") }],
  email: [
    { required: true, message: t("validate.emailRequired") },
    { type: "email", message: t("validate.emailInvalid") },
  ],
  password: [
    { required: true, message: t("validate.passwordRequired") },
    { min: 6, message: t("validate.passwordMinLength") },
  ],
  confirmPassword: [
    {
      required: !isLogin.value,
      message: t("validate.confirmPasswordRequired"),
    },
    {
      validator(_, value) {
        if (value !== formData.password) {
          return Promise.reject(t("validate.confirmPasswordMatch"));
        }
        return Promise.resolve();
      },
    },
  ],
}));

// Methods
const handleSubmit = async (e) => {
  e.preventDefault();
  loading.value = true;

  formRef.value
    .validate()
    .then(async () => {
      if (isLogin.value) {
        const { access_token } = await useFetchClient.post(`/v1/auth/login`, {
          email: formData.email,
          password: formData.password,
        });
        const token = useCookie("auth_token");
        token.value = access_token;

        router.push("/");
      } else {
        console.log("Register:", {
          name: formData.name,
          email: formData.email,
          password: formData.password,
          agreeTerms: formData.agreeTerms,
        });
      }
    })
    .catch((error) => {
      console.log("error", error);
    })
    .finally(() => {
      console.log("finally");
      loading.value = false;
    });
};

const toggleForm = () => {
  isLogin.value = !isLogin.value;

  // Reset form data
  Object.keys(formData).forEach((key) => {
    if (typeof formData[key] === "string") {
      formData[key] = "";
    } else if (typeof formData[key] === "boolean") {
      formData[key] = false;
    }
  });
};
</script>

<style scoped>
.ant-input-affix-wrapper {
  border-radius: 6px;
}

.ant-btn {
  border-radius: 6px;
  font-weight: 500;
}

.ant-checkbox-wrapper {
  font-size: 14px;
}

.ant-divider-horizontal.ant-divider-with-text {
  margin: 24px 0;
}
</style>
