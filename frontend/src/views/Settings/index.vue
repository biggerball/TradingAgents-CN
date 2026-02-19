<template>
  <div class="settings">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1 class="page-title">
        <el-icon><Setting /></el-icon>
        {{ pageTitle }}
      </h1>
      <p class="page-description">
        {{ pageDescription }}
      </p>
    </div>

    <el-row :gutter="24">
      <!-- 左侧：设置菜单 -->
      <el-col :span="6">
        <el-card class="settings-menu" shadow="never">
          <el-menu
            :default-active="activeTab"
            @select="handleMenuSelect"
            class="settings-nav"
          >
            <!-- 个人设置菜单 -->
            <template v-if="currentSection === 'personal'">
              <el-menu-item index="general">
                <el-icon><User /></el-icon>
                <span>通用设置</span>
              </el-menu-item>
              <el-menu-item index="appearance">
                <el-icon><Brush /></el-icon>
                <span>外观设置</span>
              </el-menu-item>
              <el-menu-item index="analysis">
                <el-icon><TrendCharts /></el-icon>
                <span>分析偏好</span>
              </el-menu-item>
              <el-menu-item index="notifications">
                <el-icon><Bell /></el-icon>
                <span>通知设置</span>
              </el-menu-item>
              <el-menu-item index="security">
                <el-icon><Lock /></el-icon>
                <span>安全设置</span>
              </el-menu-item>
            </template>

            <!-- 系统配置菜单 -->
            <template v-else-if="currentSection === 'config'">
              <el-menu-item index="config">
                <el-icon><Tools /></el-icon>
                <span>配置管理</span>
              </el-menu-item>
              <el-menu-item index="usage">
                <el-icon><DataAnalysis /></el-icon>
                <span>使用统计</span>
              </el-menu-item>
              <el-menu-item index="cache">
                <el-icon><Coin /></el-icon>
                <span>缓存管理</span>
              </el-menu-item>
            </template>

            <!-- 系统管理菜单 -->
            <template v-else-if="currentSection === 'admin'">
              <el-menu-item index="database">
                <el-icon><Monitor /></el-icon>
                <span>数据库管理</span>
              </el-menu-item>
              <el-menu-item index="logs">
                <el-icon><Document /></el-icon>
                <span>操作日志</span>
              </el-menu-item>
              <el-menu-item index="sync">
                <el-icon><Refresh /></el-icon>
                <span>多数据源同步</span>
              </el-menu-item>
            </template>
          </el-menu>
        </el-card>
      </el-col>

      <!-- 右侧：设置内容 -->
      <el-col :span="18">
        <!-- 通用设置 -->
        <el-card v-show="activeTab === 'general'" class="settings-content" shadow="never">
          <template #header>
            <h3>通用设置</h3>
          </template>
          
          <el-form :model="generalSettings" label-width="120px">
            <el-form-item label="用户名">
              <el-input v-model="generalSettings.username" disabled />
            </el-form-item>
            
            <el-form-item label="邮箱">
              <el-input v-model="generalSettings.email" />
            </el-form-item>
            
            <el-form-item label="语言">
              <el-select v-model="generalSettings.language">
                <el-option label="简体中文" value="zh-CN" />
                <el-option label="English" value="en-US" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="时区">
              <el-select v-model="generalSettings.timezone">
                <el-option label="北京时间 (UTC+8)" value="Asia/Shanghai" />
                <el-option label="纽约时间 (UTC-5)" value="America/New_York" />
                <el-option label="伦敦时间 (UTC+0)" value="Europe/London" />
              </el-select>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="saveGeneralSettings">
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 外观设置 -->
        <el-card v-show="activeTab === 'appearance'" class="settings-content" shadow="never">
          <template #header>
            <h3>外观设置</h3>
          </template>
          
          <el-form :model="appearanceSettings" label-width="120px">
            <el-form-item label="主题模式">
              <el-radio-group v-model="appearanceSettings.theme" @change="handleThemeChange">
                <el-radio label="light">浅色主题</el-radio>
                <el-radio label="dark">深色主题</el-radio>
                <el-radio label="auto">跟随系统</el-radio>
              </el-radio-group>
            </el-form-item>

            <el-form-item label="侧边栏宽度">
              <el-slider
                v-model="appearanceSettings.sidebarWidth"
                :min="200"
                :max="400"
                :step="20"
                show-input
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="saveAppearanceSettings">
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 分析偏好 -->
        <el-card v-show="activeTab === 'analysis'" class="settings-content" shadow="never">
          <template #header>
            <h3>分析偏好</h3>
          </template>
          
          <el-form :model="analysisSettings" label-width="120px">
            <el-form-item label="默认市场">
              <el-select v-model="analysisSettings.defaultMarket">
                <el-option label="A股" value="A股" />
                <el-option label="美股" value="美股" />
                <el-option label="港股" value="港股" />
                <el-option label="🪙 大宗商品" value="COMMODITY" />
              </el-select>
            </el-form-item>
            
            <el-form-item label="默认分析深度">
              <el-select v-model="analysisSettings.defaultDepth">
                <el-option label="1级 - 快速分析" value="1" />
                <el-option label="2级 - 基础分析" value="2" />
                <el-option label="3级 - 标准分析（推荐）" value="3" />
                <el-option label="4级 - 深度分析" value="4" />
                <el-option label="5级 - 全面分析" value="5" />
              </el-select>
            </el-form-item>

            <el-form-item label="默认分析师">
              <el-checkbox-group v-model="analysisSettings.defaultAnalysts">
                <el-checkbox label="市场分析师">市场分析师</el-checkbox>
                <el-checkbox label="基本面分析师">基本面分析师</el-checkbox>
                <el-checkbox label="新闻分析师">新闻分析师</el-checkbox>
                <el-checkbox label="社媒分析师">社媒分析师</el-checkbox>
              </el-checkbox-group>
            </el-form-item>


            
            <el-form-item label="自动刷新">
              <el-switch v-model="analysisSettings.autoRefresh" />
              <span class="setting-description">自动刷新分析结果</span>
            </el-form-item>
            
            <el-form-item label="刷新间隔">
              <el-input-number
                v-model="analysisSettings.refreshInterval"
                :min="10"
                :max="300"
                :step="10"
                :disabled="!analysisSettings.autoRefresh"
              />
              <span class="setting-description">秒</span>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="saveAnalysisSettings">
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 通知设置 -->
        <el-card v-show="activeTab === 'notifications'" class="settings-content" shadow="never">
          <template #header>
            <h3>通知设置</h3>
          </template>
          
          <el-form :model="notificationSettings" label-width="120px">
            <el-form-item label="桌面通知">
              <el-switch v-model="notificationSettings.desktop" />
              <span class="setting-description">显示桌面通知</span>
            </el-form-item>

            <el-form-item label="分析完成通知">
              <el-switch v-model="notificationSettings.analysisComplete" />
            </el-form-item>

            <el-form-item label="系统维护通知">
              <el-switch v-model="notificationSettings.systemMaintenance" />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="saveNotificationSettings">
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 安全设置 -->
        <el-card v-show="activeTab === 'security'" class="settings-content" shadow="never">
          <template #header>
            <h3>安全设置</h3>
          </template>

          <el-form label-width="120px">
            <el-form-item label="修改密码">
              <el-button type="primary" @click="changePasswordDialogVisible = true">
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>



        <!-- 配置管理 -->
        <el-card v-show="activeTab === 'config'" class="settings-content" shadow="never">
          <template #header>
            <h3>配置管理</h3>
          </template>

          <div class="config-content">
            <el-alert
              title="配置管理"
              type="info"
              description="管理 LLM 配置、数据源配置和市场分类配置"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToConfigManagement">
              进入配置管理
            </el-button>
          </div>
        </el-card>

        <!-- 使用统计 -->
        <el-card v-show="activeTab === 'usage'" class="settings-content" shadow="never">
          <template #header>
            <h3>使用统计</h3>
          </template>

          <div class="cache-content">
            <el-alert
              title="使用统计与计费"
              type="info"
              description="查看模型使用情况、Token 消耗和成本统计"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToUsageStatistics">
              查看使用统计
            </el-button>
          </div>
        </el-card>

        <!-- 缓存管理 -->
        <el-card v-show="activeTab === 'cache'" class="settings-content" shadow="never">
          <template #header>
            <h3>缓存管理</h3>
          </template>

          <div class="settings-section">
            <el-alert
              title="缓存管理"
              type="info"
              description="管理系统缓存，清理过期数据"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToCacheManagement">
              进入缓存管理
            </el-button>
          </div>
        </el-card>

        <!-- 数据库管理 -->
        <el-card v-show="activeTab === 'database'" class="settings-content" shadow="never">
          <template #header>
            <h3>数据库管理</h3>
          </template>

          <div class="database-content">
            <el-alert
              title="数据库管理"
              type="info"
              description="管理数据库连接、备份和恢复"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToDatabaseManagement">
              进入数据库管理
            </el-button>
          </div>
        </el-card>

        <!-- 操作日志 -->
        <el-card v-show="activeTab === 'logs'" class="settings-content" shadow="never">
          <template #header>
            <h3>操作日志</h3>
          </template>

          <div class="logs-content">
            <el-alert
              title="操作日志"
              type="info"
              description="查看系统操作日志和审计记录"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToOperationLogs">
              查看操作日志
            </el-button>
          </div>
        </el-card>

        <!-- 多数据源同步 -->
        <el-card v-show="activeTab === 'sync'" class="settings-content" shadow="never">
          <template #header>
            <h3>多数据源同步</h3>
          </template>

          <div class="sync-content">
            <el-alert
              title="多数据源同步"
              type="info"
              description="管理多个数据源的同步配置和状态"
              :closable="false"
              style="margin-bottom: 20px;"
            />
            <el-button type="primary" @click="goToMultiSourceSync">
              进入同步管理
            </el-button>
          </div>
        </el-card>


      </el-col>
    </el-row>

    <!-- 修改密码对话框 -->
    <el-dialog
      v-model="changePasswordDialogVisible"
      title="修改密码"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form
        ref="changePasswordFormRef"
        :model="changePasswordForm"
        :rules="changePasswordRules"
        label-width="100px"
      >
        <el-form-item label="当前密码" prop="oldPassword">
          <el-input
            v-model="changePasswordForm.oldPassword"
            type="password"
            placeholder="请输入当前密码"
            show-password
          />
        </el-form-item>

        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="changePasswordForm.newPassword"
            type="password"
            placeholder="请输入新密码（至少6位）"
            show-password
          />
        </el-form-item>

        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="changePasswordForm.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="changePasswordDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="changePasswordLoading" @click="handleChangePassword">
          确认修改
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAppStore } from '@/stores/app'
import { useAuthStore } from '@/stores/auth'
import {
  Setting,
  User,
  Brush,
  TrendCharts,
  Bell,
  Lock,
  Tools,
  Monitor,
  Coin,
  Document,
  Refresh,
  DataAnalysis
} from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const appStore = useAppStore()
const authStore = useAuthStore()

// 当前分组：personal（个人设置）、config（系统配置）、admin（系统管理）
const currentSection = ref('personal')

// 页面标题和描述
const pageTitle = computed(() => {
  switch (currentSection.value) {
    case 'personal':
      return '个人设置'
    case 'config':
      return '系统配置'
    case 'admin':
      return '系统管理'
    default:
      return '设置'
  }
})

const pageDescription = computed(() => {
  switch (currentSection.value) {
    case 'personal':
      return '个性化配置和偏好设置'
    case 'config':
      return 'LLM、数据源、使用统计和缓存配置'
    case 'admin':
      return '数据库、日志和同步管理'
    default:
      return '个性化配置和系统管理'
  }
})

// 响应式数据
const activeTab = ref('general')

// 根据路由路径和 query 参数确定当前分组和默认激活的标签
const updateSectionFromRoute = () => {
  const path = route.path
  const tab = route.query.tab as string

  if (path === '/settings') {
    // 个人设置页面
    currentSection.value = 'personal'
    // 根据 tab 参数切换标签
    if (tab) {
      activeTab.value = tab
    } else {
      activeTab.value = 'general'
    }
  } else if (path === '/settings/config') {
    currentSection.value = 'config'
    activeTab.value = 'config'
  } else if (path === '/settings/usage') {
    currentSection.value = 'config'
    activeTab.value = 'usage'
  } else if (path === '/settings/cache') {
    currentSection.value = 'config'
    activeTab.value = 'cache'
  } else if (path === '/settings/database') {
    currentSection.value = 'admin'
    activeTab.value = 'database'
  } else if (path === '/settings/logs') {
    currentSection.value = 'admin'
    activeTab.value = 'logs'
  } else if (path === '/settings/sync') {
    currentSection.value = 'admin'
    activeTab.value = 'sync'
  }
}

// 监听路由变化（包括 query 参数）
watch(() => [route.path, route.query.tab], updateSectionFromRoute, { immediate: true })

// 从 authStore 获取用户信息（使用 computed 实现响应式）
const generalSettings = ref({
  username: authStore.user?.username || 'admin',
  email: authStore.user?.email || 'admin@example.com',
  language: authStore.user?.preferences?.language || 'zh-CN',
  timezone: 'Asia/Shanghai'
})

const appearanceSettings = ref({
  theme: authStore.user?.preferences?.ui_theme || 'light',
  sidebarWidth: authStore.user?.preferences?.sidebar_width || 240
})

const analysisSettings = ref({
  defaultMarket: authStore.user?.preferences?.default_market || 'A股',
  defaultDepth: authStore.user?.preferences?.default_depth || '3',
  defaultAnalysts: authStore.user?.preferences?.default_analysts || ['市场分析师', '基本面分析师'],
  autoRefresh: authStore.user?.preferences?.auto_refresh ?? true,
  refreshInterval: authStore.user?.preferences?.refresh_interval || 30
})

const notificationSettings = ref({
  desktop: authStore.user?.preferences?.desktop_notifications ?? true,
  analysisComplete: authStore.user?.preferences?.analysis_complete_notification ?? true,
  systemMaintenance: authStore.user?.preferences?.system_maintenance_notification ?? true
})

// 监听用户信息变化，同步更新设置
watch(() => authStore.user, (newUser) => {
  if (newUser) {
    // 更新通用设置
    generalSettings.value.username = newUser.username || 'admin'
    generalSettings.value.email = newUser.email || 'admin@example.com'
    generalSettings.value.language = newUser.preferences?.language || 'zh-CN'

    // 更新外观设置
    appearanceSettings.value.theme = newUser.preferences?.ui_theme || 'light'
    appearanceSettings.value.sidebarWidth = newUser.preferences?.sidebar_width || 240

    // 更新分析偏好
    analysisSettings.value.defaultMarket = newUser.preferences?.default_market || 'A股'
    analysisSettings.value.defaultDepth = newUser.preferences?.default_depth || '3'
    analysisSettings.value.defaultAnalysts = newUser.preferences?.default_analysts || ['市场分析师', '基本面分析师']
    analysisSettings.value.autoRefresh = newUser.preferences?.auto_refresh ?? true
    analysisSettings.value.refreshInterval = newUser.preferences?.refresh_interval || 30

    // 更新通知设置
    notificationSettings.value.desktop = newUser.preferences?.desktop_notifications ?? true
    notificationSettings.value.analysisComplete = newUser.preferences?.analysis_complete_notification ?? true
    notificationSettings.value.systemMaintenance = newUser.preferences?.system_maintenance_notification ?? true
  }
}, { deep: true })

// 方法
const handleMenuSelect = (index: string) => {
  activeTab.value = index
}

const handleThemeChange = (theme: string) => {
  appStore.setTheme(theme as any)
}

const saveGeneralSettings = async () => {
  try {
    // 调用 authStore 更新用户信息
    const success = await authStore.updateUserInfo({
      email: generalSettings.value.email,
      preferences: {
        language: generalSettings.value.language
      }
    })

    if (success) {
      ElMessage.success('通用设置已保存')
    }
  } catch (error) {
    console.error('保存通用设置失败:', error)
    ElMessage.error('保存通用设置失败')
  }
}

const saveAppearanceSettings = async () => {
  try {
    // 更新本地 store（立即生效）
    appStore.setSidebarWidth(appearanceSettings.value.sidebarWidth)
    appStore.setTheme(appearanceSettings.value.theme as any)

    // 保存到后端
    const success = await authStore.updateUserInfo({
      preferences: {
        ui_theme: appearanceSettings.value.theme,
        sidebar_width: appearanceSettings.value.sidebarWidth
      }
    })

    if (success) {
      ElMessage.success('外观设置已保存')
    }
  } catch (error) {
    console.error('保存外观设置失败:', error)
    ElMessage.error('保存外观设置失败')
  }
}

const saveAnalysisSettings = async () => {
  try {
    // 更新本地 store（立即生效）
    appStore.updatePreferences({
      defaultMarket: analysisSettings.value.defaultMarket as any,
      defaultDepth: analysisSettings.value.defaultDepth as any,
      autoRefresh: analysisSettings.value.autoRefresh,
      refreshInterval: analysisSettings.value.refreshInterval
    })

    // 保存到后端
    const success = await authStore.updateUserInfo({
      preferences: {
        default_market: analysisSettings.value.defaultMarket,
        default_depth: analysisSettings.value.defaultDepth,
        default_analysts: analysisSettings.value.defaultAnalysts,
        auto_refresh: analysisSettings.value.autoRefresh,
        refresh_interval: analysisSettings.value.refreshInterval
      }
    })

    if (success) {
      ElMessage.success('分析偏好已保存')
    }
  } catch (error) {
    console.error('保存分析偏好失败:', error)
    ElMessage.error('保存分析偏好失败')
  }
}

const saveNotificationSettings = async () => {
  try {
    // 保存到后端
    const success = await authStore.updateUserInfo({
      preferences: {
        desktop_notifications: notificationSettings.value.desktop,
        analysis_complete_notification: notificationSettings.value.analysisComplete,
        system_maintenance_notification: notificationSettings.value.systemMaintenance,
        notifications_enabled: notificationSettings.value.desktop || notificationSettings.value.analysisComplete || notificationSettings.value.systemMaintenance
      }
    })

    if (success) {
      ElMessage.success('通知设置已保存')
    }
  } catch (error) {
    console.error('保存通知设置失败:', error)
    ElMessage.error('保存通知设置失败')
  }
}

// 导航函数
const goToConfigManagement = () => {
  router.push('/settings/config')
}

const goToUsageStatistics = () => {
  router.push('/settings/usage')
}

const goToCacheManagement = () => {
  router.push('/settings/cache')
}

const goToDatabaseManagement = () => {
  router.push('/settings/database')
}

const goToOperationLogs = () => {
  router.push('/settings/logs')
}

const goToMultiSourceSync = () => {
  router.push('/settings/sync')
}

// 修改密码相关
const changePasswordDialogVisible = ref(false)
const changePasswordLoading = ref(false)
const changePasswordFormRef = ref()
const changePasswordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const validateConfirmPassword = (rule: any, value: any, callback: any) => {
  if (value === '') {
    callback(new Error('请再次输入新密码'))
  } else if (value !== changePasswordForm.value.newPassword) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const changePasswordRules = {
  oldPassword: [
    { required: true, message: '请输入当前密码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少为6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const handleChangePassword = async () => {
  if (!changePasswordFormRef.value) return

  await changePasswordFormRef.value.validate(async (valid: boolean) => {
    if (valid) {
      changePasswordLoading.value = true
      try {
        const success = await authStore.changePassword(
          changePasswordForm.value.oldPassword,
          changePasswordForm.value.newPassword
        )

        if (success) {
          ElMessage.success('密码修改成功，请重新登录')
          changePasswordDialogVisible.value = false
          changePasswordForm.value = {
            oldPassword: '',
            newPassword: '',
            confirmPassword: ''
          }
          // 延迟跳转到登录页
          setTimeout(() => {
            authStore.logout()
            router.push('/login')
          }, 1500)
        }
      } catch (error: any) {
        ElMessage.error(error.message || '密码修改失败')
      } finally {
        changePasswordLoading.value = false
      }
    }
  })
}



// 生命周期
onMounted(() => {
  // 从store加载设置
  appearanceSettings.value.theme = appStore.theme
  appearanceSettings.value.sidebarWidth = appStore.sidebarWidth
  
  analysisSettings.value.defaultMarket = appStore.preferences.defaultMarket
  analysisSettings.value.defaultDepth = appStore.preferences.defaultDepth
  analysisSettings.value.autoRefresh = appStore.preferences.autoRefresh
  analysisSettings.value.refreshInterval = appStore.preferences.refreshInterval
})
</script>

<style lang="scss" scoped>
.settings {
  .page-header {
    margin-bottom: 24px;

    .page-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 24px;
      font-weight: 600;
      color: var(--el-text-color-primary);
      margin: 0 0 8px 0;
    }

    .page-description {
      color: var(--el-text-color-regular);
      margin: 0;
    }
  }

  .settings-menu {
    .settings-nav {
      border: none;
    }
  }

  .settings-content {
    min-height: 500px;

    .setting-description {
      margin-left: 8px;
      font-size: 12px;
      color: var(--el-text-color-placeholder);
    }

    .about-content {
      .system-info,
      .system-status,
      .links {
        margin-bottom: 32px;

        h4 {
          margin: 0 0 16px 0;
          color: var(--el-text-color-primary);
        }

        p {
          margin: 8px 0;
          color: var(--el-text-color-regular);
        }
      }

      .links {
        .el-link {
          margin-right: 16px;
          margin-bottom: 8px;
        }
      }
    }
  }
}
</style>
